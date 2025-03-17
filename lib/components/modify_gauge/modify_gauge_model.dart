import "package:flutter/material.dart";
import "package:rain_wise/components/modify_gauge/modify_gauge_widget.dart"
    show ModifyGaugeWidget;
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";

class ModifyGaugeModel extends FlutterFlowModel<ModifyGaugeWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  // State field(s) for PlacePicker widget.
  FFPlace placePickerValue = const FFPlace();

  @override
  void initState(final BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
