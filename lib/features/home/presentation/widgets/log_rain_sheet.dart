import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/app_constants.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/data/providers/data_providers.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/home/application/home_providers.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/add_gauge_sheet.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";
import "package:rain_wise/shared/widgets/forms/app_dropdown.dart";
import "package:rain_wise/shared/widgets/forms/app_segmented_control.dart";

class LogRainSheet extends ConsumerStatefulWidget {
  const LogRainSheet({super.key});

  @override
  ConsumerState<LogRainSheet> createState() => _LogRainSheetState();
}

class _LogRainSheetState extends ConsumerState<LogRainSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;

  // State for form fields
  String? _selectedGaugeId;
  late MeasurementUnit _selectedUnit;
  DateTime _selectedDateTime = DateTime.now();
  bool _isUnitInitialized = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  Future<void> _showAddGaugeSheet() async {
    final RainGauge? newGauge = await showModalBottomSheet<RainGauge>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (final sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: const AddGaugeSheet(),
      ),
    );

    if (newGauge != null && mounted) {
      setState(() {
        _selectedGaugeId = newGauge.id;
      });
    }
  }

  Future<void> _saveRainfallData() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false) ||
        _selectedGaugeId == null) {
      return;
    }

    double amount = double.parse(_amountController.text);
    if (_selectedUnit == MeasurementUnit.inch) {
      amount = amount.toMillimeters();
    }

    final bool success = await ref
        .read(logRainControllerProvider.notifier)
        .saveEntry(
          gaugeId: _selectedGaugeId!,
          amount: amount,
          date: _selectedDateTime,
        );

    if (mounted && success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final AsyncValue<List<RainGauge>> gaugesAsync = ref.watch(
      allGaugesStreamProvider,
    );
    final AsyncValue<void> logRainState = ref.watch(logRainControllerProvider);
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<UserPreferences> userPreferences = ref.watch(
      userPreferencesProvider,
    );

    if (!_isUnitInitialized && userPreferences.hasValue) {
      _selectedUnit = userPreferences.value!.measurementUnit;
      _isUnitInitialized = true;
    } else if (!_isUnitInitialized) {
      _selectedUnit = MeasurementUnit.mm;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horiEdgePadding,
          vertical: 16,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.logRainfallSheetTitle,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                _buildSectionHeader(l10n.logRainfallSelectGaugeHeader),
                gaugesAsync.when(
                  loading: () => const AppLoader(),
                  error: (final err, final st) =>
                      Text(l10n.logRainfallGaugesError(err)),
                  data: (final gauges) {
                    String? effectiveGaugeId = _selectedGaugeId;
                    if (effectiveGaugeId == null) {
                      final String? favoriteGaugeId =
                          userPreferences.value?.favoriteGaugeId;
                      if (favoriteGaugeId != null) {
                        effectiveGaugeId = favoriteGaugeId;
                      }
                    }

                    if (effectiveGaugeId != null &&
                        !gauges.any((final g) => g.id == effectiveGaugeId)) {
                      effectiveGaugeId = null;
                    }

                    // Update local state if the effective ID has changed.
                    // This handles auto-selecting favorite and clearing invalid IDs.
                    if (_selectedGaugeId != effectiveGaugeId) {
                      _selectedGaugeId = effectiveGaugeId;
                    }

                    return AppDropdownFormField<String>(
                      value: _selectedGaugeId,
                      hintText: l10n.logRainfallSelectGaugeHint,
                      onChanged: (final newValue) {
                        if (newValue == "__ADD_NEW__") {
                          FocusScope.of(context).unfocus();
                          _showAddGaugeSheet();
                        } else {
                          setState(() {
                            _selectedGaugeId = newValue;
                          });
                        }
                      },
                      items: [
                        ...gauges.map((final gauge) {
                          final String displayName =
                              gauge.id == AppConstants.defaultGaugeId
                              ? l10n.defaultGaugeName
                              : gauge.name;
                          return DropdownMenuItem(
                            value: gauge.id,
                            child: Text(displayName),
                          );
                        }),
                        DropdownMenuItem<String>(
                          value: "__ADD_NEW__",
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.logRainfallAddNewGauge,
                                style: TextStyle(
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      validator: (final value) => value == null
                          ? l10n.logRainfallGaugeValidation
                          : null,
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSectionHeader(l10n.logRainfallAmountHeader),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          hintText: l10n.logRainfallAmountHint,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (final val) {
                          if (val == null || val.isEmpty) {
                            return l10n.logRainfallAmountValidationEmpty;
                          }
                          if (double.tryParse(val) == null) {
                            return l10n.logRainfallAmountValidationInvalid;
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r"^\d+\.?\d*"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: AppSegmentedControl<MeasurementUnit>(
                        selectedValue: _selectedUnit,
                        onSelectionChanged: (final value) {
                          setState(() {
                            _selectedUnit = value;
                          });
                        },
                        segments: [
                          SegmentOption(
                            value: MeasurementUnit.mm,
                            label: Text(l10n.unitMM),
                          ),
                          SegmentOption(
                            value: MeasurementUnit.inch,
                            label: Text(l10n.unitIn),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionHeader(l10n.logRainfallDateTimeHeader),
                InkWell(
                  onTap: _selectDateTime,
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat.yMMMd().add_jm().format(
                              _selectedDateTime,
                            ),
                            style: theme.textTheme.bodyLarge,
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: theme.colorScheme.onSurface,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  onPressed: _saveRainfallData,
                  label: l10n.logRainfallSaveButton,
                  isLoading: logRainState.isLoading,
                  isExpanded: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(final String title) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    ),
  );
}
