import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/add_gauge/add_gauge_widget.dart';
import '/components/rain_gauge/rain_gauge_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'manage_guages_widget.dart' show ManageGuagesWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ManageGuagesModel extends FlutterFlowModel<ManageGuagesWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for rainGauge component.
  late RainGaugeModel rainGaugeModel;

  @override
  void initState(BuildContext context) {
    rainGaugeModel = createModel(context, () => RainGaugeModel());
  }

  @override
  void dispose() {
    rainGaugeModel.dispose();
  }
}
