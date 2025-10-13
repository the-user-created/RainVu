import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/app_constants.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/data/providers/data_providers.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/core/utils/snackbar_service.dart";
import "package:rain_wise/features/home/application/home_providers.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";
import "package:rain_wise/shared/widgets/forms/app_dropdown.dart";
import "package:rain_wise/shared/widgets/forms/app_segmented_control.dart";
import "package:rain_wise/shared/widgets/sheets/interactive_sheet.dart";

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
  DateTime _selectedDateTime = DateTime.now();
  MeasurementUnit? _localSelectedUnit;

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
    final DateTime? picked = await showAppDateTimePicker(
      context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDateTime = picked;
      });
    }
  }

  Future<void> _saveRainfallData() async {
    FocusScope.of(context).unfocus();
    final AppLocalizations l10n = AppLocalizations.of(context);

    if (!(_formKey.currentState?.validate() ?? false) ||
        _selectedGaugeId == null) {
      return;
    }

    final MeasurementUnit globalUnit =
        ref.read(userPreferencesProvider).value?.measurementUnit ??
        MeasurementUnit.mm;
    final MeasurementUnit effectiveUnit = _localSelectedUnit ?? globalUnit;

    double amount = double.parse(_amountController.text);
    if (effectiveUnit == MeasurementUnit.inch) {
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
      showSnackbar(l10n.rainfallEntryLoggedSuccess, type: MessageType.success);
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

    final MeasurementUnit globalUnit =
        userPreferences.value?.measurementUnit ?? MeasurementUnit.mm;
    final MeasurementUnit effectiveUnit = _localSelectedUnit ?? globalUnit;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: InteractiveSheet(
        title: Text(l10n.logRainfallSheetTitle),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSectionHeader(l10n.logRainfallSelectGaugeHeader),
              gaugesAsync.when(
                loading: () => TextFormField(
                  enabled: false,
                  decoration: InputDecoration(hintText: l10n.loading),
                ),
                error: (final err, final st) =>
                    Text(l10n.logRainfallGaugesError(err)),
                data: (final gauges) {
                  // Determine the value to display in the dropdown for this build.
                  // Priority: 1. User's explicit selection, 2. Favorite gauge, 3. null
                  String? valueToDisplay = _selectedGaugeId;
                  if (valueToDisplay == null) {
                    final String? favoriteGaugeId =
                        userPreferences.value?.favoriteGaugeId;
                    if (favoriteGaugeId != null &&
                        gauges.any((final g) => g.id == favoriteGaugeId)) {
                      valueToDisplay = favoriteGaugeId;
                    }
                  }

                  // If the current selection is invalid (e.g., gauge was deleted), clear it.
                  if (valueToDisplay != null &&
                      !gauges.any((final g) => g.id == valueToDisplay)) {
                    valueToDisplay = null;
                  }

                  // Sync the internal state if it doesn't match the determined value.
                  // This is crucial for the initial selection of the favorite gauge.
                  if (_selectedGaugeId != valueToDisplay) {
                    _selectedGaugeId = valueToDisplay;
                  }

                  return AppDropdownFormField<String>(
                    value: valueToDisplay,
                    hintText: l10n.logRainfallSelectGaugeHint,
                    onChanged: (final newValue) {
                      setState(() {
                        _selectedGaugeId = newValue;
                      });
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
                    ],
                    validator: (final value) =>
                        value == null ? l10n.logRainfallGaugeValidation : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildSectionHeader(l10n.logRainfallAmountHeader),
              _AmountInputRow(
                amountController: _amountController,
                selectedUnit: effectiveUnit,
                onUnitChanged: (final value) {
                  setState(() {
                    _localSelectedUnit = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildSectionHeader(l10n.logRainfallDateTimeHeader),
              InkWell(
                onTap: _selectDateTime,
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 60),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            DateFormat.yMMMd().add_jm().format(
                              _selectedDateTime,
                            ),
                            style: theme.textTheme.bodyLarge,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(width: 8),
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
                style: AppButtonStyle.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(final String title) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
        softWrap: true,
        overflow: TextOverflow.visible,
      ),
    ),
  );
}

/// A responsive widget for the amount input field and unit selector.
class _AmountInputRow extends StatelessWidget {
  const _AmountInputRow({
    required this.amountController,
    required this.selectedUnit,
    required this.onUnitChanged,
  });

  final TextEditingController amountController;
  final MeasurementUnit selectedUnit;
  final ValueChanged<MeasurementUnit> onUnitChanged;

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double textScaleFactor = MediaQuery.textScalerOf(context).scale(1);

    final Widget amountField = TextFormField(
      controller: amountController,
      decoration: InputDecoration(hintText: l10n.logRainfallAmountHint),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
        FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d*")),
      ],
    );

    final Widget unitSelector = AppSegmentedControl<MeasurementUnit>(
      selectedValue: selectedUnit,
      onSelectionChanged: onUnitChanged,
      segments: [
        SegmentOption(value: MeasurementUnit.mm, label: Text(l10n.unitMM)),
        SegmentOption(value: MeasurementUnit.inch, label: Text(l10n.unitIn)),
      ],
    );

    return LayoutBuilder(
      builder: (final context, final constraints) {
        // Adjust breakpoint based on text scale factor
        final double adjustedBreakpoint = 350 * textScaleFactor;

        if (constraints.maxWidth < adjustedBreakpoint) {
          // Use Column for narrow layouts or large text
          return Column(
            children: [amountField, const SizedBox(height: 12), unitSelector],
          );
        } else {
          // Use Row for wider layouts
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: amountField),
              const SizedBox(width: 8),
              Flexible(
                flex: 0,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 120,
                    maxWidth: constraints.maxWidth * 0.4,
                  ),
                  child: unitSelector,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
