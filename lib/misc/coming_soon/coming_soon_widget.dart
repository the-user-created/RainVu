import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/misc/coming_soon/coming_soon_model.dart";

export "coming_soon_model.dart";

class ComingSoonWidget extends StatefulWidget {
  const ComingSoonWidget({super.key});

  static String routeName = "coming_soon";
  static String routePath = "/comingSoon";

  @override
  State<ComingSoonWidget> createState() => _ComingSoonWidgetState();
}

class _ComingSoonWidgetState extends State<ComingSoonWidget> {
  late ComingSoonModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, ComingSoonModel.new);

    unawaited(logFirebaseEvent("screen_view", parameters: {"screen_name": "coming_soon"}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

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
            actions: const [],
            centerTitle: false,
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                  valueOrDefault<double>(
                    FFAppConstants.horiEdgePadding.toDouble(),
                    0,
                  ),
                  24,
                  valueOrDefault<double>(
                    FFAppConstants.horiEdgePadding.toDouble(),
                    0,
                  ),
                  24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Coming Soon!",
                    style: FlutterFlowTheme.of(context).displaySmall.override(
                          fontFamily: "Readex Pro",
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0,
                        ),
                  ),
                  Text(
                    "We're working hard to bring you something amazing. Check back later!",
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: "Inter",
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0,
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
