import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/core/navigation/app_route_names.dart";
import "package:rain_wise/flutter_flow/flutter_flow_animations.dart";
import "package:rain_wise/flutter_flow/flutter_flow_icon_button.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/flutter_flow/flutter_flow_widgets.dart";
import "package:rain_wise/tabs/map/map_model.dart";

export "map_model.dart";

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  late MapModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, MapModel.new);

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    animationsMap.addAll({
      "containerOnPageLoadAnimation": AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0, 100),
            end: Offset.zero,
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  // TODO: Keyboard pushes up the screen when focused on TextField
  // TODO: Make dynamic with rainfall entries
  // TODO: Use actual interactive map
  // TODO: Keep "Recent Rainfall"??
  // TODO: Make the interaction buttons work
  // TODO: Location search - center text and icon + make it work

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: PopScope(
          child: Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomInset: false,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: Stack(
              children: [
                SizedBox.expand(
                  child: Image.network(
                    "https://miro.medium.com/v2/resize:fit:1400/0*yPSQlTHRvLaIVBcG.jpg",
                    fit: BoxFit.cover,
                  ),
                ),

                // Location Search
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
                  child: SafeArea(
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
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
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          12,
                          16,
                          12,
                          16,
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              12,
                              8,
                              12,
                              8,
                            ),
                            child: Expanded(
                              child: TextFormField(
                                controller: _model.textController,
                                focusNode: _model.textFieldFocusNode,
                                decoration: InputDecoration(
                                  hintText: "Search a location...",
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: "Inter",
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0,
                                      ),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24,
                                  ),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: "Inter",
                                      letterSpacing: 0,
                                    ),
                                minLines: 1,
                                validator: _model.textControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Map Controls
                Align(
                  alignment: const AlignmentDirectional(0.95, -0.2),
                  child: Container(
                    width: 60,
                    height: 250,
                    decoration: const BoxDecoration(),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // TODO: Add modal/dialog for setting date range to display
                          FlutterFlowIconButton(
                            borderRadius: 20,
                            buttonSize: 40,
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            hoverColor: FlutterFlowTheme.of(context).alternate,
                            icon: Icon(
                              Icons.filter_list,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24,
                            ),
                            onPressed: () {
                              debugPrint("IconButton pressed ...");
                            },
                          ),

                          // Switches between heatmap and pin mode
                          //
                          // TODO: Add bar with 2 options that pop out when tapped
                          FlutterFlowIconButton(
                            borderRadius: 500,
                            buttonSize: 40,
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            hoverColor: FlutterFlowTheme.of(context).alternate,
                            icon: Icon(
                              Icons.layers,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24,
                            ),
                            onPressed: () {
                              debugPrint("IconButton pressed ...");
                            },
                          ),
                          FlutterFlowIconButton(
                            borderRadius: 20,
                            buttonSize: 40,
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            hoverColor: FlutterFlowTheme.of(context).alternate,
                            icon: Icon(
                              Icons.my_location,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24,
                            ),
                            onPressed: () {
                              debugPrint("IconButton pressed ...");
                            },
                          ),
                          FlutterFlowIconButton(
                            borderRadius: 20,
                            buttonSize: 40,
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            hoverColor: FlutterFlowTheme.of(context).alternate,
                            icon: Icon(
                              Icons.add,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24,
                            ),
                            onPressed: () {
                              debugPrint("IconButton pressed ...");
                            },
                          ),
                          FlutterFlowIconButton(
                            borderRadius: 20,
                            buttonSize: 40,
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            hoverColor: FlutterFlowTheme.of(context).alternate,
                            icon: Icon(
                              Icons.remove,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24,
                            ),
                            onPressed: () {
                              debugPrint("IconButton pressed ...");
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Recent Rainfall
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Material(
                    color: Colors.transparent,
                    elevation: 8,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      height: 300,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
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
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          24,
                          24,
                          24,
                          24,
                        ),
                        child: SingleChildScrollView(
                          primary: false,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Recent Rainfall",
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: "Readex Pro",
                                          letterSpacing: 0,
                                        ),
                                  ),
                                  FFButtonWidget(
                                    onPressed: () {
                                      context
                                          .goNamed(AppRouteNames.insightsName);
                                    },
                                    text: "View Graph",
                                    options: FFButtonOptions(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                        8,
                                        16,
                                        8,
                                        16,
                                      ),
                                      iconPadding: EdgeInsetsDirectional.zero,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: "Inter",
                                            color: Colors.white,
                                            fontSize: 12,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                      elevation: 0,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Today, 3:30 PM",
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: "Inter",
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0,
                                                        ),
                                              ),
                                              Text(
                                                "Farm Location A",
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily: "Inter",
                                                          letterSpacing: 0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE3F2FD),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "25",
                                                    style: FlutterFlowTheme.of(
                                                      context,
                                                    ).titleLarge.override(
                                                          fontFamily:
                                                              "Readex Pro",
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          letterSpacing: 0,
                                                        ),
                                                  ),
                                                  Text(
                                                    "mm",
                                                    style: FlutterFlowTheme.of(
                                                      context,
                                                    ).bodySmall.override(
                                                          fontFamily: "Inter",
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          letterSpacing: 0,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 20,
                                          ),
                                          Text(
                                            "-33.8688, 151.2093",
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
                                    ].divide(const SizedBox(height: 12)),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Yesterday, 4:15 PM",
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: "Inter",
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0,
                                                        ),
                                              ),
                                              Text(
                                                "Farm Location B",
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily: "Inter",
                                                          letterSpacing: 0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE3F2FD),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "12",
                                                    style: FlutterFlowTheme.of(
                                                      context,
                                                    ).titleLarge.override(
                                                          fontFamily:
                                                              "Readex Pro",
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          letterSpacing: 0,
                                                        ),
                                                  ),
                                                  Text(
                                                    "mm",
                                                    style: FlutterFlowTheme.of(
                                                      context,
                                                    ).bodySmall.override(
                                                          fontFamily: "Inter",
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          letterSpacing: 0,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 20,
                                          ),
                                          Text(
                                            "-33.8712, 151.2045",
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
                                    ].divide(const SizedBox(height: 12)),
                                  ),
                                ),
                              ),
                            ].divide(const SizedBox(height: 16)),
                          ),
                        ),
                      ),
                    ),
                  ).animateOnPageLoad(
                    animationsMap["containerOnPageLoadAnimation"]!,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
