import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'mtd_breakdown_model.dart';
export 'mtd_breakdown_model.dart';

class MtdBreakdownWidget extends StatefulWidget {
  const MtdBreakdownWidget({
    super.key,
    String? month,
    int? mtdTotal,
    int? twoYrAvg,
    int? fiveYrAvg,
  })  : this.month = month ?? 'err',
        this.mtdTotal = mtdTotal ?? -1,
        this.twoYrAvg = twoYrAvg ?? -1,
        this.fiveYrAvg = fiveYrAvg ?? -1;

  final String month;
  final int mtdTotal;
  final int twoYrAvg;
  final int fiveYrAvg;

  @override
  State<MtdBreakdownWidget> createState() => _MtdBreakdownWidgetState();
}

class _MtdBreakdownWidgetState extends State<MtdBreakdownWidget> {
  late MtdBreakdownModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MtdBreakdownModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
      child: Material(
        color: Colors.transparent,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).alternate,
            boxShadow: [
              BoxShadow(
                blurRadius: 4.0,
                color: Color(0x33000000),
                offset: Offset(
                  0.0,
                  2.0,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  widget!.month,
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0.0,
                      ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                    Text(
                      '${widget!.mtdTotal.toString()}mm',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '2yr avg',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Builder(
                          builder: (context) {
                            if (widget!.twoYrAvg > widget!.mtdTotal) {
                              return Icon(
                                Icons.arrow_upward,
                                color: FlutterFlowTheme.of(context).success,
                                size: 16.0,
                              );
                            } else if (widget!.twoYrAvg < widget!.mtdTotal) {
                              return Icon(
                                Icons.arrow_downward,
                                color: FlutterFlowTheme.of(context).error,
                                size: 16.0,
                              );
                            } else {
                              return Icon(
                                Icons.horizontal_rule,
                                color: FlutterFlowTheme.of(context).info,
                                size: 16.0,
                              );
                            }
                          },
                        ),
                        Text(
                          '${widget!.twoYrAvg.toString()}mm',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ].divide(SizedBox(width: 4.0)),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '5yr avg',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Builder(
                          builder: (context) {
                            if (widget!.fiveYrAvg > widget!.mtdTotal) {
                              return Icon(
                                Icons.arrow_upward,
                                color: FlutterFlowTheme.of(context).success,
                                size: 16.0,
                              );
                            } else if (widget!.fiveYrAvg < widget!.mtdTotal) {
                              return Icon(
                                Icons.arrow_downward,
                                color: FlutterFlowTheme.of(context).error,
                                size: 16.0,
                              );
                            } else {
                              return Icon(
                                Icons.horizontal_rule,
                                color: FlutterFlowTheme.of(context).info,
                                size: 16.0,
                              );
                            }
                          },
                        ),
                        Text(
                          '${widget!.fiveYrAvg.toString()}mm',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ].divide(SizedBox(width: 4.0)),
                    ),
                  ],
                ),
              ].divide(SizedBox(height: 8.0)),
            ),
          ),
        ),
      ),
    );
  }
}
