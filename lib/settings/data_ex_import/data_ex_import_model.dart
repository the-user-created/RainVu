import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/flutter_flow/form_field_controller.dart";
import "package:rain_wise/settings/data_ex_import/data_ex_import_widget.dart"
    show DataExImportWidget;

class DataExImportModel extends FlutterFlowModel<DataExImportWidget> {
  ///  State fields for stateful widgets in this page.

  DateTime? datePicked;

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;

  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;

  set choiceChipsValue(final String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  // State field(s) for Checkbox widget.
  bool? checkboxValue;
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  @override
  void initState(final BuildContext context) {}

  @override
  void dispose() {}
}
