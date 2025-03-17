import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/flutter_flow/form_field_controller.dart";
import "package:rain_wise/insights/comparative_analysis/comparative_analysis_widget.dart"
    show ComparativeAnalysisWidget;

class ComparativeAnalysisModel
    extends FlutterFlowModel<ComparativeAnalysisWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;

  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;

  set choiceChipsValue(final String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  @override
  void initState(final BuildContext context) {}

  @override
  void dispose() {}
}
