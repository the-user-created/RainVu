import "package:flutter/material.dart";
import "package:rain_wise/components/manage_plan/manage_plan_model.dart";
import "package:rain_wise/flutter_flow/flutter_flow_icon_button.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/flutter_flow/flutter_flow_widgets.dart";
import "package:rain_wise/index.dart";

export "manage_plan_model.dart";

class ManagePlanWidget extends StatefulWidget {
  const ManagePlanWidget({super.key});

  @override
  State<ManagePlanWidget> createState() => _ManagePlanWidgetState();
}

class _ManagePlanWidgetState extends State<ManagePlanWidget> {
  late ManagePlanModel _model;

  @override
  void setState(final VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, ManagePlanModel.new);
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  // TODO: Make dynamic
  // TODO: Payment gateway integration?

  @override
  Widget build(final BuildContext context) => Material(
        color: Colors.transparent,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 48),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Manage Plan",
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: "Readex Pro",
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 28,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                        FlutterFlowIconButton(
                          borderRadius: 20,
                          buttonSize: 40,
                          icon: Icon(
                            Icons.close,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
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
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0x4F507583),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.workspace_premium,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 24,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Current Plan: Pro",
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: "Inter",
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 18,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Text(
                                  "Valid until May 2024",
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: "Inter",
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 12,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              ],
                            ),
                          ].divide(const SizedBox(width: 12)),
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
                    child: Material(
                      color: Colors.transparent,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Free",
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              fontFamily: "Readex Pro",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 24,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                      Text(
                                        "Forever Free",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ListView(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 20,
                                      ),
                                      Text(
                                        "Unlimited rainfall entries",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 20,
                                      ),
                                      Text(
                                        "2 rain gauges",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 20,
                                      ),
                                      Text(
                                        "Basic graphs and maps",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.remove_circle,
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        size: 20,
                                      ),
                                      Text(
                                        "Local data storage",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.remove_circle,
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        size: 20,
                                      ),
                                      Text(
                                        "30-day historical data limit",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.remove_circle,
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        size: 20,
                                      ),
                                      Text(
                                        "No data export",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.remove_circle,
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        size: 20,
                                      ),
                                      Text(
                                        "No forecasts or analytics",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                ].divide(const SizedBox(height: 8)),
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
                        0),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pro",
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              fontFamily: "Readex Pro",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 24,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                      Text(
                                        "R100/year",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 80,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    alignment: AlignmentDirectional.center,
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4, 0, 4, 0),
                                      child: Text(
                                        "Current",
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 12,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 20,
                                      ),
                                      Text(
                                        "Unlimited rain guages",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 20,
                                      ),
                                      Text(
                                        "Cloud sync",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 20,
                                      ),
                                      Text(
                                        "Data export and import",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 20,
                                      ),
                                      Text(
                                        "Full historical data",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 20,
                                      ),
                                      Text(
                                        "Detailed graphs",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 20,
                                      ),
                                      Text(
                                        "Weather forecasts & alerts",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 20,
                                      ),
                                      Text(
                                        "Advanced analytics",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                ].divide(const SizedBox(height: 8)),
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
                        0),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pro+",
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              fontFamily: "Readex Pro",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 24,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                      Text(
                                        "R300/year",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 20,
                                      ),
                                      Text(
                                        "Everything in Pro",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 20,
                                      ),
                                      Text(
                                        "Multi-user access",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 20,
                                      ),
                                      Text(
                                        "AI-powered insights",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 20,
                                      ),
                                      Text(
                                        "API access",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: "Inter",
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                ].divide(const SizedBox(height: 8)),
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
                        0),
                    child: FFButtonWidget(
                      onPressed: () {
                        debugPrint("Button pressed ...");
                      },
                      text: "Upgrade to Pro+",
                      options: FFButtonOptions(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 50,
                        padding: const EdgeInsets.all(8),
                        iconPadding: EdgeInsetsDirectional.zero,
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleMedium
                            .override(
                              fontFamily: "Inter",
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 18,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                        elevation: 0,
                        borderRadius: BorderRadius.circular(25),
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
                      onPressed: () {
                        debugPrint("Button pressed ...");
                      },
                      text: "Downgrade to Free",
                      options: FFButtonOptions(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 50,
                        padding: const EdgeInsets.all(8),
                        iconPadding: EdgeInsetsDirectional.zero,
                        color: const Color(0x17D93C4D),
                        textStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: "Inter",
                                  color: FlutterFlowTheme.of(context).error,
                                  fontSize: 18,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                ),
                        elevation: 0,
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                        ),
                        borderRadius: BorderRadius.circular(25),
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
                    child: Column(
                      children: [
                        Text(
                          "Subscriptions automatically renew unless canceled. Manage billing through Google Play, App Store or Stripe.",
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: "Inter",
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 12,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await context.pushNamed(HelpWidget.routeName);
                          },
                          child: Text(
                            "Need help with billing?",
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: "Inter",
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                      ].divide(const SizedBox(height: 8)),
                    ),
                  ),
                ].divide(const SizedBox(height: 24)),
              ),
            ),
          ),
        ),
      );
}
