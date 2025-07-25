import "package:flutter/material.dart";
import "package:rain_wise/components/modify_gauge/modify_gauge_model.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/flutter_flow/flutter_flow_widgets.dart";

export "modify_gauge_model.dart";

class ModifyGaugeWidget extends StatefulWidget {
  const ModifyGaugeWidget({super.key});

  @override
  State<ModifyGaugeWidget> createState() => _ModifyGaugeWidgetState();
}

class _ModifyGaugeWidgetState extends State<ModifyGaugeWidget> {
  late ModifyGaugeModel _model;

  @override
  void setState(final VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, ModifyGaugeModel.new);

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit Rain Gauge",
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: "Readex Pro",
                      letterSpacing: 0,
                    ),
              ),
              Form(
                key: _model.formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                          child: Text(
                            "Rain Gauge Name",
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: "Inter",
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),

                        // TODO(david): get gauge name
                        TextFormField(
                          controller: _model.textController,
                          focusNode: _model.textFieldFocusNode,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: "E.g., Garden Gauge #1",
                            hintStyle:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: "Inter",
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0,
                                    ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0x00000000),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0x00000000),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0x00000000),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: "Inter",
                                    letterSpacing: 0,
                                  ),
                          minLines: 1,
                          validator: _model.textControllerValidator
                              .asValidator(context),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                          child: Text(
                            "Location (Optional)",
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: "Inter",
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),

                        // TODO(david): get gauge location
                        /*FlutterFlowPlacePicker(
                        iOSGoogleMapsApiKey: '',
                        androidGoogleMapsApiKey: '',
                        webGoogleMapsApiKey: '',
                        onSelect: (place) async {
                          safeSetState(() => _model.placePickerValue = place);
                        },
                        defaultText: 'Select Location',
                        icon: Icon(
                          Icons.place,
                          color: FlutterFlowTheme.of(context).accent1,
                          size: 20.0,
                        ),
                        buttonOptions: FFButtonOptions(
                          width: double.infinity,
                          height: 50.0,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          textStyle: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Inter',
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                              ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),*/
                      ],
                    ),
                  ].divide(const SizedBox(height: 16)),
                ),
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
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0,
                              ),
                      elevation: 0,
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  FFButtonWidget(
                    onPressed: () async {
                      // TODO: Implement gauge modification logic

                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
                    text: "Save",
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
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ].divide(const SizedBox(width: 12)),
              ),
            ].divide(const SizedBox(height: 24)),
          ),
        ),
      );
}
