import '/components/rain_gauge/rain_gauge_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'manage_guages_widget.dart' show ManageGuagesWidget;
import 'package:flutter/material.dart';

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
