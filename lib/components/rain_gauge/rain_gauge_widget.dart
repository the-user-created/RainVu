import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:rain_wise/components/modify_gauge/modify_gauge_widget.dart";
import "package:rain_wise/components/rain_gauge/rain_gauge_model.dart";
import "package:rain_wise/flutter_flow/flutter_flow_icon_button.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";

export "rain_gauge_model.dart";

class RainGaugeWidget extends StatefulWidget {
  const RainGaugeWidget({
    required this.gaugeName,
    required this.location,
    required this.gaugeID,
    super.key,
  });

  final String? gaugeName;
  final LatLng? location;
  final String? gaugeID;

  @override
  State<RainGaugeWidget> createState() => _RainGaugeWidgetState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("gaugeName", gaugeName))
      ..add(DiagnosticsProperty<LatLng?>("location", location))
      ..add(StringProperty("gaugeID", gaugeID));
  }
}

class _RainGaugeWidgetState extends State<RainGaugeWidget> {
  late RainGaugeModel _model;

  @override
  void setState(final VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, RainGaugeModel.new);
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Container(
        width: MediaQuery.sizeOf(context).width * 1.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).alternate,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Backyard Gauge",
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: "Inter",
                          letterSpacing: 0,
                        ),
                  ),
                  Text(
                    "123 Garden Street",
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: "Inter",
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0,
                        ),
                  ),
                ],
              ),
              Row(
                children: [
                  FlutterFlowIconButton(
                    borderRadius: 20,
                    buttonSize: 40,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    icon: Icon(
                      Icons.edit,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 20,
                    ),
                    onPressed: () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (final context) => Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.6,
                            child: const ModifyGaugeWidget(),
                          ),
                        ),
                      ).then((final value) => safeSetState(() {}));
                    },
                  ),
                  FlutterFlowIconButton(
                    borderRadius: 20,
                    buttonSize: 40,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    icon: Icon(
                      Icons.delete_outline,
                      color: FlutterFlowTheme.of(context).error,
                      size: 20,
                    ),
                    onPressed: () async {
                      bool confirmDialogResponse = await showDialog<bool>(
                            context: context,
                            builder: (final alertDialogContext) => AlertDialog(
                              title: const Text("Confirm Deletion"),
                              content: const Text(
                                  "Are you sure you want to delete this rain guage?"),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext, true),
                                  child: const Text("Confirm"),
                                ),
                              ],
                            ),
                          ) ??
                          false;

                      debugPrint("User deletion: $confirmDialogResponse");
                    },
                  ),
                ].divide(const SizedBox(width: 8)),
              ),
            ],
          ),
        ),
      );
}
