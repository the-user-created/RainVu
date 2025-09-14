import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/core/data/providers/data_providers.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/rainfall_entry/application/rainfall_entry_provider.dart";
import "package:rain_wise/features/settings/application/preferences_provider.dart";
import "package:rain_wise/features/settings/domain/user_preferences.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart";
import "package:rain_wise/shared/domain/rainfall_entry.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";
import "package:rain_wise/shared/widgets/forms/app_dropdown.dart";
import "package:rain_wise/shared/widgets/forms/app_segmented_control.dart";

class EditEntrySheet extends ConsumerStatefulWidget {
  const EditEntrySheet({required this.entry, super.key});

  final RainfallEntry entry;

  @override
  ConsumerState<EditEntrySheet> createState() => _EditEntrySheetState();
}

class _EditEntrySheetState extends ConsumerState<EditEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
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
    _selectedDate = entry.date;
    _selectedGaugeId = entry.gaugeId;
  }

  @override
  void dispose() {
    _amountController.dispose();
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
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    double amount = double.tryParse(_amountController.text) ?? 0.0;
    if (_displayUnit == MeasurementUnit.inch) {
      amount = amount.toMillimeters();
    }

    final RainfallEntry updatedEntry = widget.entry.copyWith(
      amount: amount,
      date: _selectedDate,
      unit: "mm", // Always save as mm
      gaugeId: _selectedGaugeId!,
    );
    await ref.read(rainfallEntryProvider.notifier).updateEntry(updatedEntry);

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    }
  }

  Future<void> _onDelete() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: Text(l10n.deleteEntryDialogTitle),
        content: Text(l10n.deleteDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.deleteButtonLabel),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.entry.id != null) {
      setState(() => _isLoading = true);
      await ref
          .read(rainfallEntryProvider.notifier)
          .deleteEntry(widget.entry.id!);
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<RainGauge>> gaugesAsync =
        ref.watch(allGaugesFutureProvider);

    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.editEntrySheetTitle,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.editEntryGaugeHeader,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              gaugesAsync.when(
                loading: () => const AppLoader(),
                error: (final err, final stack) =>
                    Text(l10n.rainfallEntriesError(err)),
                data: (final gauges) => AppDropdownFormField<String>(
                  value: _selectedGaugeId,
                  items: gauges
                      .map(
                        (final gauge) => DropdownMenuItem(
                          value: gauge.id,
                          child: Text(gauge.name),
                        ),
                      )
                      .toList(),
                  onChanged: (final value) =>
                      setState(() => _selectedGaugeId = value),
                  validator: (final value) =>
                      value == null ? l10n.editEntryGaugeValidation : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.editEntryAmountHeader,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r"^\d+\.?\d*"),
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: l10n.editEntryAmountHint,
                        fillColor: theme.colorScheme.surface,
                        filled: true,
                      ),
                      validator: (final value) {
                        if (value == null || value.isEmpty) {
                          return l10n.editEntryAmountValidationEmpty;
                        }
                        if (double.tryParse(value) == null) {
                          return l10n.editEntryAmountValidationInvalid;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: AppSegmentedControl<MeasurementUnit>(
                      selectedValue: _displayUnit,
                      onSelectionChanged: (final value) {
                        setState(() {
                          _displayUnit = value;
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
              Text(
                l10n.editEntryDateTimeHeader,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDateTime,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat.yMMMd().add_jm().format(_selectedDate),
                        style: theme.textTheme.bodyLarge,
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const Center(child: AppLoader())
              else
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        onPressed: _onSaveChanges,
                        label: l10n.saveChangesButton,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppButton(
                        onPressed: _onDelete,
                        label: l10n.deleteButtonLabel,
                        style: AppButtonStyle.destructive,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) {
      return;
    }
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (time == null) {
      return;
    }
    setState(() {
      _selectedDate =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }
}
