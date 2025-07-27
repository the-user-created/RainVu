import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:rain_wise/components/add_gauge/add_gauge_widget.dart";
import "package:rain_wise/components/rain_gauge/rain_gauge_widget.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/flutter_flow/flutter_flow_widgets.dart";

class ManageGuagesWidget extends StatefulWidget {
  const ManageGuagesWidget({super.key});

  static String routeName = "manage_guages";
  static String routePath = "/manageGuages";

  @override
  State<ManageGuagesWidget> createState() => _ManageGuagesWidgetState();
}

class _ManageGuagesWidgetState extends State<ManageGuagesWidget> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  // TODO: Null check operator used on a null value

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
              "Rain Gauges",
              style: FlutterFlowTheme.of(context).headlineLarge.override(
                    fontFamily: "Readex Pro",
                    fontSize: 28,
                    letterSpacing: 0,
                  ),
            ),
            actions: const [],
            centerTitle: false,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
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
                          0,
                          valueOrDefault<double>(
                            FFAppConstants.horiEdgePadding.toDouble(),
                            0,
                          ),
                          0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(
                                0,
                                2,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 16, 16, 16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "My Rain Gauges",
                                    style: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .override(
                                          fontFamily: "Readex Pro",
                                          letterSpacing: 0,
                                        ),
                                  ),
                                  Text(
                                    "0 Active",
                                    // TODO: Update this to show the number of active gauges
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: "Inter",
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0,
                                        ),
                                  ),
                                ],
                              ),
                              ListView(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                children: [
                                  // TODO: Update this to show the list of rain gauges
                                  const RainGaugeWidget(
                                    gaugeName: "Backyard, Gauge",
                                    location: LatLng(0, 0),
                                    gaugeID: "1234567890abcdef",
                                  ),
                                ].divide(const SizedBox(height: 12)),
                              ),
                            ].divide(const SizedBox(height: 16)),
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
                          0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          await showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            useSafeArea: true,
                            context: context,
                            builder: (final context) => GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.6,
                                  child: const AddGaugeWidget(),
                                ),
                              ),
                            ),
                          ).then((final value) => safeSetState(() {}));
                        },
                        text: "Add New Rain Gauge",
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 15,
                        ),
                        options: FFButtonOptions(
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          height: 50,
                          padding: const EdgeInsets.all(8),
                          iconPadding: EdgeInsetsDirectional.zero,
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: "Readex Pro",
                                    color: Colors.white,
                                    letterSpacing: 0,
                                  ),
                          elevation: 0,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ].divide(const SizedBox(height: 16)),
                ),
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
