import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/home/application/home_providers.dart";
import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
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
  String _selectedUnit = "mm"; // TODO: Load from user preferences
  DateTime _selectedDateTime = DateTime.now();

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
      builder: (final context, final child) => wrapInMaterialDatePickerTheme(
        context,
        child!,
        headerBackgroundColor: FlutterFlowTheme.of(context).accent1,
        headerForegroundColor: Colors.white,
        headerTextStyle: FlutterFlowTheme.of(context).headlineLarge.override(
              fontFamily: "Readex Pro",
              fontSize: 32,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
            ),
        pickerBackgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        pickerForegroundColor: FlutterFlowTheme.of(context).primaryText,
        selectedDateTimeBackgroundColor: FlutterFlowTheme.of(context).accent1,
        selectedDateTimeForegroundColor: Colors.white,
        actionButtonForegroundColor: FlutterFlowTheme.of(context).primaryText,
        iconSize: 24,
      ),
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (final context, final child) => wrapInMaterialTimePickerTheme(
        context,
        child!,
        headerBackgroundColor: FlutterFlowTheme.of(context).accent1,
        headerForegroundColor: Colors.white,
        headerTextStyle: FlutterFlowTheme.of(context).headlineLarge.override(
              fontFamily: "Readex Pro",
              fontSize: 32,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
            ),
        pickerBackgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        pickerForegroundColor: FlutterFlowTheme.of(context).primaryText,
        selectedDateTimeBackgroundColor: FlutterFlowTheme.of(context).accent1,
        selectedDateTimeForegroundColor: Colors.white,
        actionButtonForegroundColor: FlutterFlowTheme.of(context).primaryText,
        iconSize: 24,
      ),
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

  Future<void> _saveRainfallData() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false) ||
        _selectedGaugeId == null) {
      return;
    }

    final bool success =
        await ref.read(logRainControllerProvider.notifier).saveEntry(
              gaugeId: _selectedGaugeId!,
              amount: double.parse(_amountController.text),
              unit: _selectedUnit,
              date: _selectedDateTime,
            );

    if (mounted && success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final AsyncValue<List<RainGauge>> gaugesAsync =
        ref.watch(userGaugesProvider);
    final AsyncValue<void> logRainState = ref.watch(logRainControllerProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
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
                  "Log Rainfall",
                  style: FlutterFlowTheme.of(context).headlineSmall,
                ),
                const SizedBox(height: 16),
                _buildSectionHeader("Select Rain Gauge"),
                gaugesAsync.when(
                  loading: () => const AppLoader(),
                  error: (final err, final st) =>
                      Text("Error loading gauges: $err"),
                  data: (final gauges) => AppDropdownFormField<String>(
                    value: _selectedGaugeId,
                    hintText: "Select...",
                    onChanged: (final newValue) {
                      setState(() {
                        _selectedGaugeId = newValue;
                      });
                    },
                    items: gauges
                        .map(
                          (final gauge) => DropdownMenuItem(
                            value: gauge.id,
                            child: Text(gauge.name),
                          ),
                        )
                        .toList(),
                    validator: (final value) =>
                        value == null ? "Please select a gauge" : null,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionHeader("Rainfall Amount"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          hintText: "Enter amount",
                          hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (final val) {
                          if (val == null || val.isEmpty) {
                            return "Amount cannot be empty";
                          }
                          if (double.tryParse(val) == null) {
                            return "Please enter a valid number";
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
                      child: AppSegmentedControl<String>(
                        selectedValue: _selectedUnit,
                        onSelectionChanged: (final value) {
                          setState(() {
                            _selectedUnit = value;
                          });
                        },
                        segments: const [
                          SegmentOption(
                            value: "mm",
                            label: Text("mm"),
                          ),
                          SegmentOption(
                            value: "in",
                            label: Text("in"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionHeader("Date & Time"),
                InkWell(
                  onTap: _selectDateTime,
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat.yMMMd()
                                .add_jm()
                                .format(_selectedDateTime),
                            style: FlutterFlowTheme.of(context).bodyLarge,
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: FlutterFlowTheme.of(context).primaryText,
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
                  label: "Save Rainfall Data",
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
          child: Text(
            title,
            style: FlutterFlowTheme.of(context).titleLarge,
          ),
        ),
      );
}
