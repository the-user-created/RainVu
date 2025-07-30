import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:rain_wise/features/rainfall_entry/application/rainfall_entry_provider.dart";
import "package:rain_wise/features/rainfall_entry/domain/rainfall_entry.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";
import "package:rain_wise/shared/widgets/forms/app_dropdown.dart";

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
  late String _selectedUnit;
  String? _selectedGaugeId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final RainfallEntry entry = widget.entry;
    _amountController = TextEditingController(text: entry.amount.toString());
    _selectedDate = entry.date;
    _selectedUnit = entry.unit;
    _selectedGaugeId = entry.gaugeId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _onSaveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    final RainfallEntry updatedEntry = widget.entry.copyWith(
      amount: double.tryParse(_amountController.text) ?? 0.0,
      date: _selectedDate,
      unit: _selectedUnit,
      gaugeId: _selectedGaugeId!,
    );
    await ref
        .read(rainfallEntryNotifierProvider.notifier)
        .updateEntry(updatedEntry);

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    }
  }

  Future<void> _onDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text("Delete Entry?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.entry.id != null) {
      setState(() => _isLoading = true);
      await ref
          .read(rainfallEntryNotifierProvider.notifier)
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
    final AsyncValue<List<RainGauge>> gaugesAsync =
        ref.watch(rainGaugesProvider);

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
              Text("Edit Rainfall Entry", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 24),
              Text("Rain Gauge", style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              gaugesAsync.when(
                loading: () => const AppLoader(),
                error: (final err, final stack) => Text("Error: $err"),
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
                      value == null ? "Please select a gauge" : null,
                ),
              ),
              const SizedBox(height: 16),
              Text("Rainfall Amount", style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d*")),
                ],
                decoration: InputDecoration(
                  hintText: "Enter amount",
                  fillColor: theme.colorScheme.background,
                  filled: true,
                ),
                validator: (final value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an amount";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text("Date & Time", style: theme.textTheme.titleMedium),
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
                        label: "Save Changes",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppButton(
                        onPressed: _onDelete,
                        label: "Delete",
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
