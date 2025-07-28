import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/core/navigation/app_route_names.dart";
import "package:rain_wise/flutter_flow/flutter_flow_icon_button.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";

class MonthlyBreakdownWidget extends StatefulWidget {
  const MonthlyBreakdownWidget({super.key});

  @override
  State<MonthlyBreakdownWidget> createState() => _MonthlyBreakdownWidgetState();
}

class _MonthlyBreakdownWidgetState extends State<MonthlyBreakdownWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime? datePicked;

  // TODO: Invalid argument(s): No host specified in URI file:/// for "Daily Rainfall" widget

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
              "Monthly Rainfall",
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: "Readex Pro",
                    letterSpacing: 0,
                  ),
            ),
            actions: [
              Align(
                alignment: AlignmentDirectional.center,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                  child: FlutterFlowIconButton(
                    borderRadius: 50,
                    buttonSize: 40,
                    fillColor: Colors.transparent,
                    icon: Icon(
                      Icons.calendar_today,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 24,
                    ),
                    onPressed: () async {
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
                          pickerBackgroundColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
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

                      if (datePickedDate != null) {
                        safeSetState(() {
                          datePicked = DateTime(
                            datePickedDate.year,
                            datePickedDate.month,
                            datePickedDate.day,
                          );
                        });
                      } else if (datePicked != null) {
                        safeSetState(() {
                          datePicked = getCurrentTimestamp;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
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
                        AppConstants.horiEdgePadding.toDouble(),
                        0,
                      ),
                      24,
                      valueOrDefault<double>(
                        AppConstants.horiEdgePadding.toDouble(),
                        0,
                      ),
                      0,
                    ),
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
                            20,
                            20,
                            20,
                            20,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "June 2023",
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              fontFamily: "Readex Pro",
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Text(
                                        "Total Rainfall: 127mm",
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              fontFamily: "Readex Pro",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              letterSpacing: 0,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional.center,
                                    child: FlutterFlowIconButton(
                                      borderRadius: 50,
                                      buttonSize: 48,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .alternate,
                                      icon: Icon(
                                        Icons.edit,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 28,
                                      ),
                                      onPressed: () async {
                                        await context.pushNamed(
                                          AppRouteNames.rainfallEntriesName,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "4.2mm",
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              fontFamily: "Readex Pro",
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Text(
                                        "Daily Average",
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
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "22mm",
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              fontFamily: "Readex Pro",
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Text(
                                        "Highest Day",
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
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "0.5mm",
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              fontFamily: "Readex Pro",
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Text(
                                        "Lowest Day",
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
                                    ],
                                  ),
                                ],
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
                        AppConstants.horiEdgePadding.toDouble(),
                        0,
                      ),
                      0,
                      valueOrDefault<double>(
                        AppConstants.horiEdgePadding.toDouble(),
                        0,
                      ),
                      0,
                    ),
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
                            20,
                            20,
                            20,
                            20,
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Historical Comparison",
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: "Readex Pro",
                                      letterSpacing: 0,
                                    ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "2 Year Average",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_upward,
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            size: 20,
                                          ),
                                          Text(
                                            "+15%",
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: "Inter",
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).tertiary,
                                                  letterSpacing: 0,
                                                ),
                                          ),
                                        ].divide(const SizedBox(width: 8)),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "108mm",
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: "Inter",
                                          letterSpacing: 0,
                                        ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "5 Year Average",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_upward,
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            size: 20,
                                          ),
                                          Text(
                                            "+22%",
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: "Inter",
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).tertiary,
                                                  letterSpacing: 0,
                                                ),
                                          ),
                                        ].divide(const SizedBox(width: 8)),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "104mm",
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: "Inter",
                                          letterSpacing: 0,
                                        ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "10 Year Average",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_downward,
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            size: 20,
                                          ),
                                          Text(
                                            "-8%",
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: "Inter",
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).error,
                                                  letterSpacing: 0,
                                                ),
                                          ),
                                        ].divide(const SizedBox(width: 8)),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "138mm",
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: "Inter",
                                          letterSpacing: 0,
                                        ),
                                  ),
                                ],
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
                        AppConstants.horiEdgePadding.toDouble(),
                        0,
                      ),
                      0,
                      valueOrDefault<double>(
                        AppConstants.horiEdgePadding.toDouble(),
                        0,
                      ),
                      0,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 300,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            20,
                            20,
                            20,
                            20,
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Daily Rainfall",
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: "Readex Pro",
                                      letterSpacing: 0,
                                    ),
                              ),

                              // TODO: interactive chart—either a line or bar chart—that visually represents daily rainfall totals for the month. Ensure that tapping or hovering on any data point reveals a tooltip with detailed information, including the exact rainfall amount and historical comparison for that day.
                              Image.network(
                                "",
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                height: 200,
                                fit: BoxFit.contain,
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
                        AppConstants.horiEdgePadding.toDouble(),
                        0,
                      ),
                      0,
                      valueOrDefault<double>(
                        AppConstants.horiEdgePadding.toDouble(),
                        0,
                      ),
                      48,
                    ),
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
                            20,
                            20,
                            20,
                            20,
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Daily Breakdown",
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: "Readex Pro",
                                      letterSpacing: 0,
                                    ),
                              ),

                              // TODO: scrollable table or list that provides a detailed day-by-day breakdown, with columns for the date, recorded rainfall, and the variance from historical averages.
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "June 30",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Text(
                                        "4.5mm",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_upward,
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            size: 16,
                                          ),
                                          Text(
                                            "+0.8mm",
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: "Inter",
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).tertiary,
                                                  letterSpacing: 0,
                                                ),
                                          ),
                                        ].divide(const SizedBox(width: 8)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "June 29",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Text(
                                        "3.2mm",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_downward,
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            size: 16,
                                          ),
                                          Text(
                                            "-1.1mm",
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: "Inter",
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).error,
                                                  letterSpacing: 0,
                                                ),
                                          ),
                                        ].divide(const SizedBox(width: 8)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "June 28",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Text(
                                        "5.7mm",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_upward,
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            size: 16,
                                          ),
                                          Text(
                                            "+1.2mm",
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: "Inter",
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).tertiary,
                                                  letterSpacing: 0,
                                                ),
                                          ),
                                        ].divide(const SizedBox(width: 8)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "June 27",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Text(
                                        "2.8mm",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.remove,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 16,
                                          ),
                                          Text(
                                            "0.0mm",
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: "Inter",
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).secondaryText,
                                                  letterSpacing: 0,
                                                ),
                                          ),
                                        ].divide(const SizedBox(width: 8)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "June 26",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Text(
                                        "6.1mm",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_upward,
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            size: 16,
                                          ),
                                          Text(
                                            "+2.3mm",
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: "Inter",
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).tertiary,
                                                  letterSpacing: 0,
                                                ),
                                          ),
                                        ].divide(const SizedBox(width: 8)),
                                      ),
                                    ],
                                  ),
                                ].divide(const SizedBox(height: 12)),
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
}
