import "dart:ui";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:rain_wise/components/log_rain/log_rain_widget.dart";
import "package:rain_wise/flutter_flow/flutter_flow_icon_button.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/insights/monthly_breakdown/monthly_breakdown_widget.dart";
import "package:rain_wise/tabs/insights/insights_widget.dart";

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  static String routeName = "home";
  static String routePath = "/home";

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // TODO: Make widgets dynamic with rainfall entries
  // TODO: Rainfall Trends widget - make 30 days and 7 days selectable

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: PopScope(
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "RainTracker",
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: "Readex Pro",
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0,
                        ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: FlutterFlowIconButton(
                      borderRadius: 50,
                      buttonSize: 52,
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: FlutterFlowTheme.of(context).secondary,
                        size: 36,
                      ),
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
                                height: MediaQuery.sizeOf(context).height * 0.8,
                                child: const LogRainWidget(),
                              ),
                            ),
                          ),
                        ).then((final value) => safeSetState(() {}));
                      },
                    ),
                  ),
                ],
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
                        0,
                        valueOrDefault<double>(
                          FFAppConstants.horiEdgePadding.toDouble(),
                          0,
                        ),
                        0,
                      ),
                      child: Container(
                        width: double.infinity,
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
                            ),
                          ],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Monthly Rainfall",
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: "Readex Pro",
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    "March 2025",
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
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.water_drop,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 36,
                                  ),
                                  Text(
                                    "78.5 mm",
                                    style: FlutterFlowTheme.of(context)
                                        .displaySmall
                                        .override(
                                          fontFamily: "Readex Pro",
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                  0,
                                  8,
                                  0,
                                  8,
                                ),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                  0,
                                  4,
                                  0,
                                  8,
                                ),
                                child: Text(
                                  "Recent Entries",
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: "Inter",
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                  0,
                                  4,
                                  0,
                                  4,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Today, 9:15 AM",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: "Inter",
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    Text(
                                      "12.5 mm",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: "Inter",
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                  0,
                                  4,
                                  0,
                                  4,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Yesterday, 8:30 AM",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: "Inter",
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    Text(
                                      "8.2 mm",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: "Inter",
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                  0,
                                  4,
                                  0,
                                  4,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "June 12, 7:45 AM",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: "Inter",
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    Text(
                                      "15.3 mm",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: "Inter",
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await context.pushNamed(
                                    MonthlyBreakdownWidget.routeName,
                                  );
                                },
                                child: DecoratedBox(
                                  decoration: const BoxDecoration(),
                                  child:
                                      // TODO: Take user to monthly breakdown for current month
                                      Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                      0,
                                      8,
                                      0,
                                      0,
                                    ),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        await context.pushNamed(
                                          MonthlyBreakdownWidget.routeName,
                                        );
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "View Full History",
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: "Inter",
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primary,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(4, 0, 4, 0),
                                            child: Icon(
                                              Icons.arrow_forward_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // TODO: Only shown for Pro users
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
                        0,
                      ),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(
                                0,
                                2,
                              ),
                            ),
                          ],
                          gradient: LinearGradient(
                            colors: [
                              FlutterFlowTheme.of(context).primaryBackground,
                              FlutterFlowTheme.of(context).alternate,
                            ],
                            stops: const [0.0, 1.0],
                            begin: AlignmentDirectional.topCenter,
                            end: AlignmentDirectional.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            16,
                            16,
                            16,
                            16,
                          ),
                          child: Column(
                            children: [
                              Text(
                                "7-Day Forecast",
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: "Readex Pro",
                                      letterSpacing: 0,
                                    ),
                              ),
                              Container(
                                height: 140,
                                decoration: const BoxDecoration(),
                                child:
                                    // TODO: Remove blur for Pro users
                                    ClipRect(
                                  child: ImageFiltered(
                                    imageFilter: ImageFilter.blur(
                                      sigmaX: 3,
                                      sigmaY: 3,
                                    ),
                                    child: ListView(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Container(
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12, 12, 12, 12),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Today",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodySmall.override(
                                                        fontFamily: "Inter",
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).secondaryText,
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                                const Icon(
                                                  Icons.wb_sunny,
                                                  color: Color(0xFFFFC107),
                                                  size: 32,
                                                ),
                                                Text(
                                                  "24°C",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                        fontFamily: "Inter",
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                                Text(
                                                  "10%",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodySmall.override(
                                                        fontFamily: "Inter",
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).tertiary,
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                              ].divide(
                                                const SizedBox(height: 8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12, 12, 12, 12),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Tue",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodySmall.override(
                                                        fontFamily: "Inter",
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).secondaryText,
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                                const Icon(
                                                  Icons.cloud,
                                                  color: Color(0xFF90A4AE),
                                                  size: 32,
                                                ),
                                                Text(
                                                  "22°C",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                        fontFamily: "Inter",
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                                Text(
                                                  "30%",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodySmall.override(
                                                        fontFamily: "Inter",
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).tertiary,
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                              ].divide(
                                                const SizedBox(height: 8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12, 12, 12, 12),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Wed",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodySmall.override(
                                                        fontFamily: "Inter",
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).secondaryText,
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                                Icon(
                                                  Icons.grain,
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primary,
                                                  size: 32,
                                                ),
                                                Text(
                                                  "20°C",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                        fontFamily: "Inter",
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                                Text(
                                                  "80%",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodySmall.override(
                                                        fontFamily: "Inter",
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).tertiary,
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                              ].divide(
                                                const SizedBox(height: 8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12, 12, 12, 12),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Thu",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodySmall.override(
                                                        fontFamily: "Inter",
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).secondaryText,
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                                const Icon(
                                                  Icons.wb_cloudy,
                                                  color: Color(0xFF90A4AE),
                                                  size: 32,
                                                ),
                                                Text(
                                                  "23°C",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                        fontFamily: "Inter",
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                                Text(
                                                  "20%",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodySmall.override(
                                                        fontFamily: "Inter",
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).tertiary,
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                              ].divide(
                                                const SizedBox(height: 8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12, 12, 12, 12),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Thu",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodySmall.override(
                                                        fontFamily: "Inter",
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).secondaryText,
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                                const Icon(
                                                  Icons.wb_cloudy,
                                                  color: Color(0xFF90A4AE),
                                                  size: 32,
                                                ),
                                                Text(
                                                  "23°C",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                        fontFamily: "Inter",
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                                Text(
                                                  "20%",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodySmall.override(
                                                        fontFamily: "Inter",
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).tertiary,
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                              ].divide(
                                                const SizedBox(height: 8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12, 12, 12, 12),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Thu",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodySmall.override(
                                                        fontFamily: "Inter",
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).secondaryText,
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                                const Icon(
                                                  Icons.wb_cloudy,
                                                  color: Color(0xFF90A4AE),
                                                  size: 32,
                                                ),
                                                Text(
                                                  "23°C",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                        fontFamily: "Inter",
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                                Text(
                                                  "20%",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodySmall.override(
                                                        fontFamily: "Inter",
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).tertiary,
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                              ].divide(
                                                const SizedBox(height: 8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12, 12, 12, 12),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Thu",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodySmall.override(
                                                        fontFamily: "Inter",
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).secondaryText,
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                                const Icon(
                                                  Icons.wb_cloudy,
                                                  color: Color(0xFF90A4AE),
                                                  size: 32,
                                                ),
                                                Text(
                                                  "23°C",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                        fontFamily: "Inter",
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                                Text(
                                                  "20%",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodySmall.override(
                                                        fontFamily: "Inter",
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).tertiary,
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                              ].divide(
                                                const SizedBox(height: 8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ].divide(const SizedBox(width: 16)),
                                    ),
                                  ),
                                ),
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
                        0,
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x1A000000),
                              offset: Offset(
                                0,
                                2,
                              ),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Rainfall Trends",
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: "Readex Pro",
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),

                                  // TODO: Add switching logic
                                  DecoratedBox(
                                    decoration: const BoxDecoration(),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "7 days",
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: "Inter",
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Text(
                                          " | ",
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: "Inter",
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0,
                                              ),
                                        ),
                                        Text(
                                          "30 days",
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: "Inter",
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                  0,
                                  16,
                                  0,
                                  0,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8, 0, 8, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: 30,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primary,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              Container(
                                                width: 30,
                                                height: 65,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primary,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primary,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              Container(
                                                width: 30,
                                                height: 90,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primary,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              Container(
                                                width: 30,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primary,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              Container(
                                                width: 30,
                                                height: 75,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primary,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              Container(
                                                width: 30,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primary,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional.bottomCenter,
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8, 0, 8, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "8 May",
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .override(
                                                          fontFamily: "Inter",
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0,
                                                        ),
                                              ),
                                              Text(
                                                "9 May",
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .override(
                                                          fontFamily: "Inter",
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0,
                                                        ),
                                              ),
                                              Text(
                                                "10 May",
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .override(
                                                          fontFamily: "Inter",
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0,
                                                        ),
                                              ),
                                              Text(
                                                "11 May",
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .override(
                                                          fontFamily: "Inter",
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0,
                                                        ),
                                              ),
                                              Text(
                                                "12 May",
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .override(
                                                          fontFamily: "Inter",
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0,
                                                        ),
                                              ),
                                              Text(
                                                "13 May",
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .override(
                                                          fontFamily: "Inter",
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0,
                                                        ),
                                              ),
                                              Text(
                                                "Today",
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .override(
                                                          fontFamily: "Inter",
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                  0,
                                  12,
                                  0,
                                  0,
                                ),
                                child: DecoratedBox(
                                  decoration: const BoxDecoration(),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await context
                                          .pushNamed(InsightsWidget.routeName);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "View detailed insights",
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: "Inter",
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(4, 0, 4, 0),
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                        0,
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x1A000000),
                              offset: Offset(
                                0,
                                2,
                              ),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                "Quick Stats",
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: "Readex Pro",
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                  0,
                                  16,
                                  0,
                                  0,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "36.2",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).titleLarge.override(
                                                        fontFamily:
                                                            "Readex Pro",
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).primary,
                                                        letterSpacing: 0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                Text(
                                                  "mm this week",
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).labelMedium.override(
                                                        fontFamily: "Inter",
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "78.5",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).titleLarge.override(
                                                        fontFamily:
                                                            "Readex Pro",
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).primary,
                                                        letterSpacing: 0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                Text(
                                                  "mm this month",
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).labelMedium.override(
                                                        fontFamily: "Inter",
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "5.6",
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).titleLarge.override(
                                                        fontFamily:
                                                            "Readex Pro",
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).primary,
                                                        letterSpacing: 0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                Text(
                                                  "mm daily avg",
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).labelMedium.override(
                                                        fontFamily: "Inter",
                                                        letterSpacing: 0,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]
                      .divide(const SizedBox(height: 24))
                      .addToStart(const SizedBox(height: 16))
                      .addToEnd(const SizedBox(height: 32)),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<GlobalKey<ScaffoldState>>(
        "scaffoldKey",
        scaffoldKey,
      ),
    );
  }
}
