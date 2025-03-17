import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_choice_chips.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/flutter_flow/flutter_flow_widgets.dart";
import "package:rain_wise/flutter_flow/form_field_controller.dart";
import "package:rain_wise/settings/data_ex_import/data_ex_import_model.dart";

export "data_ex_import_model.dart";

class DataExImportWidget extends StatefulWidget {
  const DataExImportWidget({super.key});

  static String routeName = "data_ex_import";
  static String routePath = "/dataExImport";

  @override
  State<DataExImportWidget> createState() => _DataExImportWidgetState();
}

class _DataExImportWidgetState extends State<DataExImportWidget> {
  late DataExImportModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, DataExImportModel.new);

    unawaited(logFirebaseEvent("screen_view",
        parameters: {"screen_name": "data_ex_import"}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
            title: Text(
              "Export & Import",
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: "Readex Pro",
                    fontSize: 28,
                    letterSpacing: 0,
                  ),
            ),
            actions: const [],
            centerTitle: false,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        valueOrDefault<double>(
                          FFAppConstants.horiEdgePadding.toDouble(),
                          0,
                        ),
                        24,
                        valueOrDefault<double>(
                          FFAppConstants.horiEdgePadding.toDouble(),
                          0,
                        ),
                        0),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 20, 20, 20),
                          child: Column(
                            children: [
                              Text(
                                "Export Your Data",
                                style: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                      fontFamily: "Readex Pro",
                                      letterSpacing: 0,
                                    ),
                              ),
                              Text(
                                "Select date range and format to export your rainfall data",
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: "Inter",
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0,
                                    ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  final DateTime? datePickedDate =
                                      await showDatePicker(
                                    context: context,
                                    initialDate: getCurrentTimestamp,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2050),
                                    builder: (final context, final child) =>
                                        wrapInMaterialDatePickerTheme(
                                      context,
                                      child!,
                                      headerBackgroundColor:
                                          FlutterFlowTheme.of(context).accent1,
                                      headerForegroundColor:
                                          const Color(0xFFECE7E0),
                                      headerTextStyle:
                                          FlutterFlowTheme.of(context)
                                              .headlineLarge
                                              .override(
                                                fontFamily: "Readex Pro",
                                                fontSize: 32,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                      pickerBackgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      pickerForegroundColor:
                                          FlutterFlowTheme.of(context)
                                              .primaryText,
                                      selectedDateTimeBackgroundColor:
                                          FlutterFlowTheme.of(context).accent1,
                                      selectedDateTimeForegroundColor:
                                          const Color(0xFFECE7E0),
                                      actionButtonForegroundColor:
                                          FlutterFlowTheme.of(context).primary,
                                      iconSize: 24,
                                    ),
                                  );

                                  if (datePickedDate != null) {
                                    safeSetState(() {
                                      _model.datePicked = DateTime(
                                        datePickedDate.year,
                                        datePickedDate.month,
                                        datePickedDate.day,
                                      );
                                    });
                                  } else if (_model.datePicked != null) {
                                    safeSetState(() {
                                      _model.datePicked = getCurrentTimestamp;
                                    });
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  decoration: BoxDecoration(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 16, 16, 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Date Range: All Time",
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: "Inter",
                                                letterSpacing: 0,
                                              ),
                                        ),
                                        Icon(
                                          Icons.calendar_today,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "Export Format",
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: "Inter",
                                      fontSize: 16,
                                      letterSpacing: 0,
                                    ),
                              ),
                              FlutterFlowChoiceChips(
                                options: const [
                                  ChipData("CSV"),
                                  ChipData("PDF"),
                                  ChipData("JSON")
                                ],
                                onChanged: (final val) => safeSetState(() =>
                                    _model.choiceChipsValue = val?.firstOrNull),
                                selectedChipStyle: ChipStyle(
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: "Inter",
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        letterSpacing: 0,
                                      ),
                                  iconColor: const Color(0x00000000),
                                  iconSize: 16,
                                  labelPadding: const EdgeInsets.all(8),
                                  elevation: 0,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                unselectedChipStyle: ChipStyle(
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).alternate,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: "Inter",
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        letterSpacing: 0,
                                      ),
                                  iconColor: const Color(0x00000000),
                                  iconSize: 16,
                                  labelPadding: const EdgeInsets.all(8),
                                  elevation: 0,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                chipSpacing: 8,
                                rowSpacing: 8,
                                multiselect: false,
                                controller:
                                    _model.choiceChipsValueController ??=
                                        FormFieldController<List<String>>(
                                  [],
                                ),
                              ),
                              Row(
                                children: [
                                  Theme(
                                    data: ThemeData(
                                      checkboxTheme: const CheckboxThemeData(
                                        shape: RoundedRectangleBorder(),
                                      ),
                                      unselectedWidgetColor:
                                          FlutterFlowTheme.of(context).accent2,
                                    ),
                                    child: Checkbox(
                                      value: _model.checkboxValue ??= false,
                                      onChanged: (final newValue) {
                                        safeSetState(() =>
                                            _model.checkboxValue = newValue);
                                      },
                                      side: BorderSide(
                                        width: 2,
                                        color: FlutterFlowTheme.of(context)
                                            .accent2,
                                      ),
                                      activeColor:
                                          FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                  Text(
                                    "Include Notes",
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: "Inter",
                                          letterSpacing: 0,
                                        ),
                                  ),
                                ].divide(const SizedBox(width: 12)),
                              ),
                              FFButtonWidget(
                                onPressed: () {
                                  debugPrint("Button pressed ...");
                                },
                                text: "Download File",
                                icon: Icon(
                                  Icons.download,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  size: 15,
                                ),
                                options: FFButtonOptions(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  height: 50,
                                  padding: const EdgeInsets.all(8),
                                  iconPadding: EdgeInsetsDirectional.zero,
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: "Readex Pro",
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        letterSpacing: 0,
                                      ),
                                  elevation: 0,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ].divide(const SizedBox(height: 16)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        valueOrDefault<double>(
                          FFAppConstants.horiEdgePadding.toDouble(),
                          0,
                        ),
                        0,
                        valueOrDefault<double>(
                          FFAppConstants.horiEdgePadding.toDouble(),
                          0,
                        ),
                        32),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 20, 20, 20),
                          child: Column(
                            children: [
                              Text(
                                "Import Your Data",
                                style: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                      fontFamily: "Readex Pro",
                                      letterSpacing: 0,
                                    ),
                              ),
                              Text(
                                "Import your previously exported rainfall data",
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: "Inter",
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0,
                                    ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  // TODO(david): Implement file picker
                                },
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8, 0, 8, 0),
                                          child: Icon(
                                            Icons.upload_file,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 32,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8, 0, 8, 0),
                                          child: Text(
                                            "Select File to Import",
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: "Inter",
                                                  letterSpacing: 0,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8, 0, 8, 0),
                                          child: Text(
                                            "CSV or JSON files only",
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: "Inter",
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  letterSpacing: 0,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 16, 16, 16),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Preview",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      Text(
                                        "No file selected",
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              letterSpacing: 0,
                                            ),
                                      ),
                                    ].divide(const SizedBox(height: 8)),
                                  ),
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () {
                                  debugPrint("Button pressed ...");
                                },
                                text: "Import Data",
                                icon: Icon(
                                  Icons.cloud_upload,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  size: 15,
                                ),
                                options: FFButtonOptions(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  height: 50,
                                  padding: const EdgeInsets.all(8),
                                  iconPadding: EdgeInsetsDirectional.zero,
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: "Readex Pro",
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        letterSpacing: 0,
                                      ),
                                  elevation: 0,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ].divide(const SizedBox(height: 16)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ].divide(const SizedBox(height: 24)),
              ),
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GlobalKey<ScaffoldState>>(
        "scaffoldKey", scaffoldKey));
  }
}
