import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";

class MtdBreakdownWidget extends StatefulWidget {
  const MtdBreakdownWidget({
    super.key,
    final String? month,
    final int? mtdTotal,
    final int? twoYrAvg,
    final int? fiveYrAvg,
  })  : month = month ?? "err",
        mtdTotal = mtdTotal ?? -1,
        twoYrAvg = twoYrAvg ?? -1,
        fiveYrAvg = fiveYrAvg ?? -1;

  final String month;
  final int mtdTotal;
  final int twoYrAvg;
  final int fiveYrAvg;

  @override
  State<MtdBreakdownWidget> createState() => _MtdBreakdownWidgetState();
}

class _MtdBreakdownWidgetState extends State<MtdBreakdownWidget> {
  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
        child: Material(
          color: Colors.transparent,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).alternate,
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
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
              child: Column(
                children: [
                  Text(
                    widget.month,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: "Readex Pro",
                          letterSpacing: 0,
                        ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: "Inter",
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0,
                            ),
                      ),
                      Text(
                        "${widget.mtdTotal}mm",
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: "Inter",
                              letterSpacing: 0,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "2yr avg",
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: "Inter",
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0,
                            ),
                      ),
                      Row(
                        children: [
                          Builder(
                            builder: (final context) {
                              if (widget.twoYrAvg > widget.mtdTotal) {
                                return Icon(
                                  Icons.arrow_upward,
                                  color: FlutterFlowTheme.of(context).success,
                                  size: 16,
                                );
                              } else if (widget.twoYrAvg < widget.mtdTotal) {
                                return Icon(
                                  Icons.arrow_downward,
                                  color: FlutterFlowTheme.of(context).error,
                                  size: 16,
                                );
                              } else {
                                return Icon(
                                  Icons.horizontal_rule,
                                  color: FlutterFlowTheme.of(context).info,
                                  size: 16,
                                );
                              }
                            },
                          ),
                          Text(
                            "${widget.twoYrAvg}mm",
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: "Inter",
                                  letterSpacing: 0,
                                ),
                          ),
                        ].divide(const SizedBox(width: 4)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "5yr avg",
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: "Inter",
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0,
                            ),
                      ),
                      Row(
                        children: [
                          Builder(
                            builder: (final context) {
                              if (widget.fiveYrAvg > widget.mtdTotal) {
                                return Icon(
                                  Icons.arrow_upward,
                                  color: FlutterFlowTheme.of(context).success,
                                  size: 16,
                                );
                              } else if (widget.fiveYrAvg < widget.mtdTotal) {
                                return Icon(
                                  Icons.arrow_downward,
                                  color: FlutterFlowTheme.of(context).error,
                                  size: 16,
                                );
                              } else {
                                return Icon(
                                  Icons.horizontal_rule,
                                  color: FlutterFlowTheme.of(context).info,
                                  size: 16,
                                );
                              }
                            },
                          ),
                          Text(
                            "${widget.fiveYrAvg}mm",
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: "Inter",
                                  letterSpacing: 0,
                                ),
                          ),
                        ].divide(const SizedBox(width: 4)),
                      ),
                    ],
                  ),
                ].divide(const SizedBox(height: 8)),
              ),
            ),
          ),
        ),
      );
}
