import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/home/application/home_providers.dart";
import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:rain_wise/flutter_flow/flutter_flow_choice_chips.dart";
import "package:rain_wise/flutter_flow/flutter_flow_drop_down.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/flutter_flow/flutter_flow_widgets.dart";
import "package:rain_wise/flutter_flow/form_field_controller.dart";
import "package:rain_wise/shared/widgets/app_loader.dart";

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
  late FormFieldController<String> _gaugeController;

  String _selectedUnit = "mm"; // TODO: Load from user preferences
  late FormFieldController<List<String>> _unitController;

  DateTime _selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _gaugeController = FormFieldController<String>(null);
    _unitController = FormFieldController<List<String>>([_selectedUnit]);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _gaugeController.dispose();
    _unitController.dispose();
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

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_selectedGaugeId == null) {
      // Show a snackbar or some feedback to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a rain gauge.")),
      );
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
    // Error state is handled by the provider/listener if needed
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
                  data: (final gauges) => FlutterFlowDropDown<String>(
                    controller: _gaugeController,
                    options: gauges.map((final g) => g.id).toList(),
                    optionLabels: gauges.map((final g) => g.name).toList(),
                    onChanged: (final val) =>
                        setState(() => _selectedGaugeId = val),
                    width: double.infinity,
                    height: 60,
                    textStyle: FlutterFlowTheme.of(context).bodyMedium,
                    hintText: "Select...",
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    elevation: 2,
                    borderColor: FlutterFlowTheme.of(context).alternate,
                    borderWidth: 1,
                    borderRadius: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    hidesUnderline: true,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionHeader("Rainfall Amount"),
                TextFormField(
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                    FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d*")),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "Unit:",
                      style: FlutterFlowTheme.of(context).bodyLarge,
                    ),
                    const SizedBox(width: 8),
                    FlutterFlowChoiceChips(
                      options: const [ChipData("mm"), ChipData("in")],
                      onChanged: (final val) => setState(
                        () => _selectedUnit = val?.firstOrNull ?? "mm",
                      ),
                      selectedChipStyle: ChipStyle(
                        backgroundColor: FlutterFlowTheme.of(context).accent1,
                        textStyle: const TextStyle(color: Colors.white),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      unselectedChipStyle: ChipStyle(
                        backgroundColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        textStyle: TextStyle(
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      chipSpacing: 8,
                      multiselect: false,
                      controller: _unitController,
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
                FFButtonWidget(
                  onPressed: _saveRainfallData,
                  text: "Save Rainfall Data",
                  showLoadingIndicator: logRainState.isLoading,
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50,
                    color: FlutterFlowTheme.of(context).accent1,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: "Readex Pro",
                          color: Colors.white,
                        ),
                    borderRadius: BorderRadius.circular(25),
                    hoverColor: FlutterFlowTheme.of(context).primary,
                  ),
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
