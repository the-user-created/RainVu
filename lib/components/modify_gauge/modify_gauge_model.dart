import '/flutter_flow/flutter_flow_util.dart';
import 'modify_gauge_widget.dart' show ModifyGaugeWidget;
import 'package:flutter/material.dart';

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
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
