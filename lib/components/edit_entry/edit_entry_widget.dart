import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:rain_wise/auth/firebase_auth/auth_util.dart";
import "package:rain_wise/backend/backend.dart";
import "package:rain_wise/components/edit_entry/edit_entry_model.dart";
import "package:rain_wise/flutter_flow/flutter_flow_choice_chips.dart";
import "package:rain_wise/flutter_flow/flutter_flow_drop_down.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/flutter_flow/flutter_flow_widgets.dart";
import "package:rain_wise/flutter_flow/form_field_controller.dart";

export "edit_entry_model.dart";

class EditEntryWidget extends StatefulWidget {
  const EditEntryWidget({super.key});

  @override
  State<EditEntryWidget> createState() => _EditEntryWidgetState();
}

class _EditEntryWidgetState extends State<EditEntryWidget> {
  late EditEntryModel _model;

  @override
  void setState(final VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, EditEntryModel.new);

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
              valueOrDefault<double>(
                FFAppConstants.horiEdgePadding.toDouble(),
                0,
              ),
              16,
              valueOrDefault<double>(
                FFAppConstants.horiEdgePadding.toDouble(),
                0,
              ),
              16),
          child: SingleChildScrollView(
            primary: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Edit Rainfall Entry",
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: "Readex Pro",
                        letterSpacing: 0,
                      ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Rain Gauge",
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: "Readex Pro",
                            letterSpacing: 0,
                          ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate,
                        ),
                      ),
                      child: StreamBuilder<List<GaugesRecord>>(
                        stream: queryGaugesRecord(
                          queryBuilder: (final gaugesRecord) => gaugesRecord
                              .where(
                                "userID",
                                isEqualTo: currentUserUid,
                              )
                              .orderBy("gaugeName"),
                        ),
                        builder: (final context, final snapshot) {
                          // Customize what your widget looks like when it's loading.
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            );
                          }
                          List<GaugesRecord> dropDownGaugesRecordList =
                              snapshot.data!;

                          return FlutterFlowDropDown<String>(
                            controller: _model.dropDownValueController ??=
                                FormFieldController<String>(null),
                            options: dropDownGaugesRecordList
                                .map((final e) => e.gaugeName)
                                .toList(),
                            onChanged: (final val) =>
                                safeSetState(() => _model.dropDownValue = val),
                            width: 200,
                            height: 40,
                            searchHintTextStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: "Inter",
                                  letterSpacing: 0,
                                ),
                            searchTextStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: "Inter",
                                  letterSpacing: 0,
                                ),
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: "Inter",
                                  fontSize: 16,
                                  letterSpacing: 0,
                                ),
                            hintText: "Select...",
                            searchHintText: "Search...",
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24,
                            ),
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            elevation: 2,
                            borderColor: Colors.transparent,
                            borderWidth: 0,
                            borderRadius: 8,
                            margin: const EdgeInsetsDirectional.fromSTEB(
                                12, 0, 12, 0),
                            hidesUnderline: true,
                            isSearchable: true,
                          );
                        },
                      ),
                    ),
                  ].divide(const SizedBox(height: 8)),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rainfall Amount",
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: "Readex Pro",
                            letterSpacing: 0,
                          ),
                    ),
                    TextFormField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        isDense: false,
                        hintText: "Enter amount",
                        hintStyle:
                            FlutterFlowTheme.of(context).bodyLarge.override(
                                  fontFamily: "Inter",
                                  letterSpacing: 0,
                                ),
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
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: "Inter",
                            letterSpacing: 0,
                          ),
                      minLines: 1,
                      keyboardType: TextInputType.number,
                      validator:
                          _model.textControllerValidator.asValidator(context),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Unit:",
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: "Inter",
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0,
                              0,
                              valueOrDefault<double>(
                                FFAppConstants.horiEdgePadding.toDouble(),
                                0,
                              ),
                              0),
                          child: FlutterFlowChoiceChips(
                            options: const [ChipData("mm"), ChipData("inches")],
                            onChanged: (final val) => safeSetState(() =>
                                _model.choiceChipsValue = val?.firstOrNull),
                            selectedChipStyle: ChipStyle(
                              backgroundColor:
                                  FlutterFlowTheme.of(context).accent1,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: "Inter",
                                    color: Colors.white,
                                    fontSize: 12,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500,
                                  ),
                              iconColor: const Color(0x00000000),
                              iconSize: 18,
                              elevation: 0,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            unselectedChipStyle: ChipStyle(
                              backgroundColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: "Inter",
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 12,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500,
                                  ),
                              iconColor: const Color(0x00000000),
                              iconSize: 18,
                              elevation: 0,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            chipSpacing: 8,
                            rowSpacing: 8,
                            multiselect: false,
                            alignment: WrapAlignment.spaceAround,
                            controller: _model.choiceChipsValueController ??=
                                FormFieldController<List<String>>(
                              [],
                            ),
                          ),
                        ),
                      ].divide(const SizedBox(width: 8)),
                    ),
                  ].divide(const SizedBox(height: 8)),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date & Time",
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: "Readex Pro",
                            letterSpacing: 0,
                          ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        final DateTime? datePickedDate = await showDatePicker(
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
                            headerForegroundColor: Colors.white,
                            headerTextStyle: FlutterFlowTheme.of(context)
                                .headlineLarge
                                .override(
                                  fontFamily: "Readex Pro",
                                  fontSize: 32,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w600,
                                ),
                            pickerBackgroundColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            pickerForegroundColor:
                                FlutterFlowTheme.of(context).primaryText,
                            selectedDateTimeBackgroundColor:
                                FlutterFlowTheme.of(context).accent1,
                            selectedDateTimeForegroundColor: Colors.white,
                            actionButtonForegroundColor:
                                FlutterFlowTheme.of(context).primaryText,
                            iconSize: 24,
                          ),
                        );

                        TimeOfDay? datePickedTime;
                        if (datePickedDate != null) {
                          datePickedTime = await showTimePicker(
                            context: context,
                            initialTime:
                                TimeOfDay.fromDateTime(getCurrentTimestamp),
                            builder: (final context, final child) =>
                                wrapInMaterialTimePickerTheme(
                              context,
                              child!,
                              headerBackgroundColor:
                                  FlutterFlowTheme.of(context).accent1,
                              headerForegroundColor: Colors.white,
                              headerTextStyle: FlutterFlowTheme.of(context)
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
                                  FlutterFlowTheme.of(context).primaryText,
                              selectedDateTimeBackgroundColor:
                                  FlutterFlowTheme.of(context).accent1,
                              selectedDateTimeForegroundColor: Colors.white,
                              actionButtonForegroundColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              iconSize: 24,
                            ),
                          );
                        }

                        if (datePickedDate != null && datePickedTime != null) {
                          safeSetState(() {
                            _model.datePicked = DateTime(
                              datePickedDate.year,
                              datePickedDate.month,
                              datePickedDate.day,
                              datePickedTime!.hour,
                              datePickedTime.minute,
                            );
                          });
                        } else if (_model.datePicked != null) {
                          safeSetState(() {
                            _model.datePicked = getCurrentTimestamp;
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              12, 12, 12, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dateTimeFormat(
                                  "relative",
                                  _model.datePicked,
                                  locale: FFLocalizations.of(context)
                                          .languageShortCode ??
                                      FFLocalizations.of(context).languageCode,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: "Inter",
                                      letterSpacing: 0,
                                    ),
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
                  ].divide(const SizedBox(height: 8)),
                ),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FFButtonWidget(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: "Delete Entry",
                      options: FFButtonOptions(
                        width: 240,
                        height: 50,
                        padding: const EdgeInsets.all(8),
                        iconPadding: EdgeInsetsDirectional.zero,
                        color: FlutterFlowTheme.of(context).error,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: "Readex Pro",
                                  color: Colors.white,
                                  letterSpacing: 0,
                                ),
                        elevation: 0,
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        hoverColor: const Color(0xC4D93C4D),
                      ),
                    ),
                    FFButtonWidget(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: "Save Changes",
                      options: FFButtonOptions(
                        width: 240,
                        height: 50,
                        padding: const EdgeInsets.all(8),
                        iconPadding: EdgeInsetsDirectional.zero,
                        color: FlutterFlowTheme.of(context).accent1,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: "Readex Pro",
                                  color: Colors.white,
                                  letterSpacing: 0,
                                ),
                        elevation: 0,
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        hoverColor: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ],
                ),
              ].divide(const SizedBox(height: 16)),
            ),
          ),
        ),
      );
}
