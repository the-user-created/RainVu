import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:keyboard_actions/keyboard_actions.dart";
import "package:rainvu/app_constants.dart";
import "package:rainvu/core/application/preferences_provider.dart";
import "package:rainvu/core/data/providers/data_providers.dart";
import "package:rainvu/core/utils/extensions.dart";
import "package:rainvu/core/utils/snackbar_service.dart";
import "package:rainvu/features/rainfall_entry/application/rainfall_entry_provider.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/domain/rain_gauge.dart";
import "package:rainvu/shared/domain/rainfall_entry.dart";
import "package:rainvu/shared/domain/user_preferences.dart";
import "package:rainvu/shared/utils/ui_helpers.dart";
import "package:rainvu/shared/widgets/buttons/app_button.dart";
import "package:rainvu/shared/widgets/forms/app_dropdown.dart";
import "package:rainvu/shared/widgets/forms/app_segmented_control.dart";
import "package:rainvu/shared/widgets/sheets/interactive_sheet.dart";

class EditEntrySheet extends ConsumerStatefulWidget {
  const EditEntrySheet({required this.entry, super.key});

  final RainfallEntry entry;

  @override
  ConsumerState<EditEntrySheet> createState() => _EditEntrySheetState();
}

class _EditEntrySheetState extends ConsumerState<EditEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late FocusNode _amountFocusNode;
  late DateTime _selectedDate;
  late MeasurementUnit _displayUnit;
  String? _selectedGaugeId;
  bool _isLoading = false;
  bool _isUnitInitialized = false;

  @override
  void initState() {
    super.initState();
    final RainfallEntry entry = widget.entry;
    _amountController = TextEditingController();
    _amountFocusNode = FocusNode();
    _selectedDate = entry.date;
    _selectedGaugeId = entry.gaugeId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isUnitInitialized) {
      final MeasurementUnit unit =
          ref.read(userPreferencesProvider).value?.measurementUnit ??
          MeasurementUnit.mm;
      _displayUnit = unit;
      double displayAmount = widget.entry.amount;
      if (unit == MeasurementUnit.inch) {
        displayAmount = displayAmount.toInches();
      }
      _amountController.text = displayAmount.toStringAsFixed(2);
      _isUnitInitialized = true;
    }
  }

  Future<void> _onSaveChanges() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    try {
      final double amount =
          double.tryParse(_amountController.text.replaceAll(",", ".")) ?? 0.0;
      double amountInMm = amount;
      if (_displayUnit == MeasurementUnit.inch) {
        amountInMm = amount.toMillimeters();
      }

      final RainfallEntry updatedEntry = widget.entry.copyWith(
        amount: amountInMm,
        date: _selectedDate,
        unit: "mm", // Always save as mm
        gaugeId: _selectedGaugeId!,
      );
      await ref.read(rainfallEntryProvider.notifier).updateEntry(updatedEntry);

      if (mounted) {
        showSnackbar(
          l10n.rainfallEntryUpdatedSuccess,
          type: MessageType.success,
        );
        Navigator.of(context).pop();
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to update rainfall entry",
      );
      if (mounted) {
        showSnackbar(l10n.rainfallEntryUpdatedError, type: MessageType.error);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickDateTime() async {
    final DateTime? picked = await showAppDateTimePicker(
      context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
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

  KeyboardActionsConfig get _keyboardActionsConfig => KeyboardActionsConfig(
    keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
    keyboardBarColor: context.iOSKeyboardBgColor,
    actions: [
      KeyboardActionsItem(
        focusNode: _amountFocusNode,
        toolbarButtons: [
          (final node) => GestureDetector(
            onTap: node.unfocus,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Text(
                AppLocalizations.of(context).doneButtonLabel,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<RainGauge>> gaugesAsync = ref.watch(
      allGaugesFutureProvider,
    );

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: InteractiveSheet(
        title: Text(l10n.editEntrySheetTitle),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSectionHeader(l10n.editEntryGaugeHeader),
              gaugesAsync.when(
                loading: () => TextFormField(
                  enabled: false,
                  decoration: InputDecoration(hintText: l10n.loading),
                ),
                error: (final err, final stack) =>
                    Text(l10n.rainfallEntriesError),
                data: (final gauges) => AppDropdownFormField<String>(
                  value: _selectedGaugeId,
                  items: gauges.map((final gauge) {
                    final String displayName =
                        gauge.id == AppConstants.defaultGaugeId
                        ? l10n.defaultGaugeName
                        : gauge.name;
                    return DropdownMenuItem(
                      value: gauge.id,
                      child: Text(displayName),
                    );
                  }).toList(),
                  onChanged: (final value) =>
                      setState(() => _selectedGaugeId = value),
                  validator: (final value) =>
                      value == null ? l10n.editEntryGaugeValidation : null,
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionHeader(l10n.editEntryAmountHeader),
              _AmountInputRow(
                amountController: _amountController,
                amountFocusNode: _amountFocusNode,
                keyboardActionsConfig: _keyboardActionsConfig,
                selectedUnit: _displayUnit,
                onUnitChanged: (final value) {
                  setState(() {
                    _displayUnit = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildSectionHeader(l10n.editEntryDateTimeHeader),
              InkWell(
                onTap: _pickDateTime,
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
                            DateFormat.yMMMd().add_jm().format(_selectedDate),
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
              const SizedBox(height: 32),
              AppButton(
                onPressed: _onSaveChanges,
                label: l10n.saveChangesButton,
                isLoading: _isLoading,
                isExpanded: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A responsive widget for the amount input field and unit selector.
class _AmountInputRow extends StatelessWidget {
  const _AmountInputRow({
    required this.amountController,
    required this.amountFocusNode,
    required this.keyboardActionsConfig,
    required this.selectedUnit,
    required this.onUnitChanged,
  });

  final TextEditingController amountController;
  final KeyboardActionsConfig keyboardActionsConfig;
  final MeasurementUnit selectedUnit;
  final ValueChanged<MeasurementUnit> onUnitChanged;
  final FocusNode? amountFocusNode;

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double textScaleFactor = MediaQuery.textScalerOf(context).scale(1);

    final Widget amountField = KeyboardActions(
      config: keyboardActionsConfig,
      disableScroll: true,
      child: TextFormField(
        controller: amountController,
        focusNode: amountFocusNode,
        decoration: InputDecoration(hintText: l10n.editEntryAmountHint),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (final val) {
          if (val == null || val.isEmpty) {
            return l10n.editEntryAmountValidationEmpty;
          }
          final String normalizedVal = val.replaceAll(",", ".");
          if (double.tryParse(normalizedVal) == null) {
            return l10n.editEntryAmountValidationInvalid;
          }
          if (double.parse(normalizedVal).isNegative) {
            return l10n.editEntryAmountValidationNegative;
          }
          return null;
        },
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"^\d*[,.]?\d*")),
        ],
      ),
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
        final double adjustedBreakpoint = 350 * textScaleFactor;

        if (constraints.maxWidth < adjustedBreakpoint) {
          return Column(
            children: [amountField, const SizedBox(height: 12), unitSelector],
          );
        } else {
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
