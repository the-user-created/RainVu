import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/add_gauge/add_gauge_widget.dart';
import '/components/rain_gauge/rain_gauge_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'manage_guages_model.dart';
export 'manage_guages_model.dart';

class ManageGuagesWidget extends StatefulWidget {
  const ManageGuagesWidget({super.key});

  static String routeName = 'manage_guages';
  static String routePath = '/manageGuages';

  @override
  State<ManageGuagesWidget> createState() => _ManageGuagesWidgetState();
}

class _ManageGuagesWidgetState extends State<ManageGuagesWidget> {
  late ManageGuagesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ManageGuagesModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'manage_guages'});
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
          automaticallyImplyLeading: true,
          title: Text(
            'Rain Gauges',
            style: FlutterFlowTheme.of(context).headlineLarge.override(
                  fontFamily: 'Readex Pro',
                  fontSize: 28.0,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
          centerTitle: false,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        valueOrDefault<double>(
                          FFAppConstants.horiEdgePadding.toDouble(),
                          0.0,
                        ),
                        0.0,
                        valueOrDefault<double>(
                          FFAppConstants.horiEdgePadding.toDouble(),
                          0.0,
                        ),
                        0.0),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4.0,
                            color: Color(0x33000000),
                            offset: Offset(
                              0.0,
                              2.0,
                            ),
                            spreadRadius: 0.0,
                          )
                        ],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'My Rain Gauges',
                                  style: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                FutureBuilder<int>(
                                  future: queryGaugesRecordCount(
                                    queryBuilder: (gaugesRecord) =>
                                        gaugesRecord.where(
                                      'userID',
                                      isEqualTo: currentUserUid,
                                    ),
                                  ),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SizedBox(
                                          width: 50.0,
                                          height: 50.0,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    int textCount = snapshot.data!;

                                    return Text(
                                      '${textCount.toString()} Active',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                          ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            ListView(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: [
                                StreamBuilder<List<GaugesRecord>>(
                                  stream: queryGaugesRecord(
                                    queryBuilder: (gaugesRecord) => gaugesRecord
                                        .where(
                                          'userID',
                                          isEqualTo: currentUserUid,
                                        )
                                        .orderBy('gaugeName'),
                                  ),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SizedBox(
                                          width: 50.0,
                                          height: 50.0,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    List<GaugesRecord>
                                        rainGaugeGaugesRecordList =
                                        snapshot.data!;

                                    return wrapWithModel(
                                      model: _model.rainGaugeModel,
                                      updateCallback: () => safeSetState(() {}),
                                      child: RainGaugeWidget(
                                        gaugeName: rainGaugeGaugesRecordList
                                            .firstOrNull!.gaugeName,
                                        gaugeID: rainGaugeGaugesRecordList
                                            .firstOrNull!.rainGaugeID,
                                        location: rainGaugeGaugesRecordList
                                            .firstOrNull!.location!,
                                      ),
                                    );
                                  },
                                ),
                              ].divide(SizedBox(height: 12.0)),
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        valueOrDefault<double>(
                          FFAppConstants.horiEdgePadding.toDouble(),
                          0.0,
                        ),
                        0.0,
                        valueOrDefault<double>(
                          FFAppConstants.horiEdgePadding.toDouble(),
                          0.0,
                        ),
                        0.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          useSafeArea: true,
                          context: context,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: Container(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.6,
                                  child: AddGaugeWidget(),
                                ),
                              ),
                            );
                          },
                        ).then((value) => safeSetState(() {}));
                      },
                      text: 'Add New Rain Gauge',
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 15.0,
                      ),
                      options: FFButtonOptions(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 50.0,
                        padding: EdgeInsets.all(8.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ].divide(SizedBox(height: 16.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
