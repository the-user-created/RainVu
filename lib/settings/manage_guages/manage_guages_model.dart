import "package:flutter/material.dart";
import "package:rain_wise/components/rain_gauge/rain_gauge_widget.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/settings/manage_guages/manage_guages_widget.dart" show ManageGuagesWidget;

class ManageGuagesModel extends FlutterFlowModel<ManageGuagesWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for rainGauge component.
  late RainGaugeModel rainGaugeModel;

  @override
  void initState(final BuildContext context) {
    rainGaugeModel = createModel(context, RainGaugeModel.new);
  }

  @override
  void dispose() {
    rainGaugeModel.dispose();
  }
}
