import "package:flutter/material.dart";
import "package:rain_wise/components/ticket/ticket_model.dart";
import "package:rain_wise/flutter_flow/flutter_flow_drop_down.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/flutter_flow/flutter_flow_widgets.dart";
import "package:rain_wise/flutter_flow/form_field_controller.dart";

export "ticket_model.dart";

class TicketWidget extends StatefulWidget {
  const TicketWidget({super.key});

  @override
  State<TicketWidget> createState() => _TicketWidgetState();
}

class _TicketWidgetState extends State<TicketWidget> {
  late TicketModel _model;

  @override
  void setState(final VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, TicketModel.new);

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  // TODO(david): Make description textfield scrollable when the number of lines of text exceeds the original height of the textfield.
  // TODO(david): Hide email input if logged in
  // TODO: Fix keyboard

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Report a Problem / Send Feedback",
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: "Readex Pro",
                      letterSpacing: 0,
                    ),
              ),
              Text(
                "Please describe the issue you are facing or share your feedback. Our team will review your submission and get back to you if needed.",
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: "Inter",
                      letterSpacing: 0,
                    ),
              ),
              FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController ??=
                    FormFieldController<String>(
                  _model.dropDownValue ??= "",
                ),
                options: List<String>.from(["1", "2", "3", "4", "5"]),
                optionLabels: const [
                  "Bug Report",
                  "Feature Request",
                  "General Feedback",
                  "Billing Issue",
                  "Other"
                ],
                onChanged: (final val) =>
                    safeSetState(() => _model.dropDownValue = val),
                width: double.infinity,
                height: 60,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: "Inter",
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0,
                    ),
                hintText: "Select Category",
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24,
                ),
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                elevation: 2,
                borderColor: FlutterFlowTheme.of(context).alternate,
                borderWidth: 1,
                borderRadius: 8,
                margin: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                hidesUnderline: true,
              ),

              TextFormField(
                controller: _model.textController1,
                focusNode: _model.textFieldFocusNode1,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Describe your issue or feedback here...",
                  hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: "Inter",
                        color: FlutterFlowTheme.of(context).secondaryText,
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
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: "Inter",
                      letterSpacing: 0,
                    ),
                maxLines: null,
                minLines: 3,
                validator: _model.textController1Validator.asValidator(context),
              ),

              TextFormField(
                controller: _model.textController2,
                focusNode: _model.textFieldFocusNode2,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Email (optional)",
                  labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: "Inter",
                        color: FlutterFlowTheme.of(context).secondaryText,
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
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: "Inter",
                      letterSpacing: 0,
                    ),
                keyboardType: TextInputType.emailAddress,
                validator: _model.textController2Validator.asValidator(context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FFButtonWidget(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: "Cancel",
                    options: FFButtonOptions(
                      width: 100,
                      height: 40,
                      padding: const EdgeInsets.all(8),
                      iconPadding: EdgeInsetsDirectional.zero,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      textStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: "Inter",
                                letterSpacing: 0,
                              ),
                      elevation: 0,
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      hoverColor:
                          FlutterFlowTheme.of(context).primaryBackground,
                    ),
                  ),
                  FFButtonWidget(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: "Submit",
                    options: FFButtonOptions(
                      width: 100,
                      height: 40,
                      padding: const EdgeInsets.all(8),
                      iconPadding: EdgeInsetsDirectional.zero,
                      color: FlutterFlowTheme.of(context).accent1,
                      textStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: "Inter",
                                color: Colors.white,
                                letterSpacing: 0,
                              ),
                      elevation: 0,
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      hoverColor: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ].divide(const SizedBox(width: 12)),
              ),
            ].divide(const SizedBox(height: 16)),
          ),
        ),
      );
}
