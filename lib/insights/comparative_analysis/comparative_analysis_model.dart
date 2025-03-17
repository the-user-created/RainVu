import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'comparative_analysis_widget.dart' show ComparativeAnalysisWidget;
import 'package:flutter/material.dart';

class ComparativeAnalysisModel
    extends FlutterFlowModel<ComparativeAnalysisWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;

  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;

  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
