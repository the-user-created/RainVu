import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/insights/anomaly_explore/anomaly_explore_model.dart";

export "anomaly_explore_model.dart";

class AnomalyExploreWidget extends StatefulWidget {
  const AnomalyExploreWidget({super.key});

  static String routeName = "anomaly_explore";
  static String routePath = "/anomalyExplore";

  @override
  State<AnomalyExploreWidget> createState() => _AnomalyExploreWidgetState();
}

class _AnomalyExploreWidgetState extends State<AnomalyExploreWidget> {
  late AnomalyExploreModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, AnomalyExploreModel.new);

    unawaited(logFirebaseEvent("screen_view",
        parameters: {"screen_name": "anomaly_explore"}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  // TODO: Make dynamic with rainfall data
  // TODO: Date range picker for filtering and severity selection

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
              "Anomaly Exploration",
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: "Readex Pro",
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
                  Container(
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
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                      child: Column(
                        children: [
                          Text(
                            "Filter Options",
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: "Readex Pro",
                                  letterSpacing: 0,
                                ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // TODO(david): Add date range picker
                              Expanded(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 16, 12, 16),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 20,
                                        ),
                                        Text(
                                          "Date Range",
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: "Inter",
                                                letterSpacing: 0,
                                              ),
                                        ),
                                      ].divide(const SizedBox(width: 8)),
                                    ),
                                  ),
                                ),
                              ),

                              // TODO(david): Add severity selection
                              Expanded(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 16, 12, 16),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.warning,
                                          color: Color(0xFFF9CF58),
                                          size: 20,
                                        ),
                                        Text(
                                          "Severity",
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: "Inter",
                                                letterSpacing: 0,
                                              ),
                                        ),
                                      ].divide(const SizedBox(width: 8)),
                                    ),
                                  ),
                                ),
                              ),
                            ].divide(const SizedBox(width: 12)),
                          ),
                        ].divide(const SizedBox(height: 16)),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: 300,
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
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rainfall Trends",
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: "Readex Pro",
                                      letterSpacing: 0,
                                    ),
                              ),
                              Row(
                                children: [
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE3F2FD),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4, 8, 4, 8),
                                      child: Text(
                                        "Normal",
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              fontFamily: "Inter",
                                              color: const Color(0xFF1565C0),
                                              letterSpacing: 0,
                                            ),
                                      ),
                                    ),
                                  ),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF3E0),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4, 8, 4, 8),
                                      child: Text(
                                        "Anomaly",
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              fontFamily: "Inter",
                                              color: const Color(0xFFEF6C00),
                                              letterSpacing: 0,
                                            ),
                                      ),
                                    ),
                                  ),
                                ].divide(const SizedBox(width: 8)),
                              ),
                            ],
                          ),

                          // TODO(david): Add interactive timeline/linechart that presents rainfall data over time, with anomalies clearly highlighted using markers
                          Image.network(
                            "",
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            height: 240,
                            fit: BoxFit.contain,
                          ),
                        ].divide(const SizedBox(height: 8)),
                      ),
                    ),
                  ),
                  Text(
                    "Detected Anomalies",
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: "Readex Pro",
                          letterSpacing: 0,
                        ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 32),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      children: [
                        // TODO(david): Upon tapping  a card, lead the user to a dedicated detail view that offers a deeper dive into that specific anomaly, including historical comparisons, contextual weather data, and graphical breakdowns.
                        Container(
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
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
                                      "May 15, 2023",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily: "Inter",
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFEBEE),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4, 8, 4, 8),
                                        child: Text(
                                          "+245% Above Average",
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontFamily: "Inter",
                                                color: const Color(0xFFC62828),
                                                letterSpacing: 0,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Significant rainfall spike detected, exceeding historical averages for this period",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: "Inter",
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0,
                                      ),
                                ),
                              ].divide(const SizedBox(height: 8)),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
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
                                      "April 3, 2023",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily: "Inter",
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F5E9),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4, 8, 4, 8),
                                        child: Text(
                                          "-75% Below Average",
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontFamily: "Inter",
                                                color: const Color(0xFF2E7D32),
                                                letterSpacing: 0,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Extended dry period observed, indicating potential drought conditions",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: "Inter",
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0,
                                      ),
                                ),
                              ].divide(const SizedBox(height: 8)),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
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
                                      "March 21, 2023",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily: "Inter",
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFEBEE),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4, 8, 4, 8),
                                        child: Text(
                                          "+180% Above Average",
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontFamily: "Inter",
                                                color: const Color(0xFFC62828),
                                                letterSpacing: 0,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Unusual precipitation pattern detected during typically dry season",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: "Inter",
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0,
                                      ),
                                ),
                              ].divide(const SizedBox(height: 8)),
                            ),
                          ),
                        ),
                      ].divide(const SizedBox(height: 12)),
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
