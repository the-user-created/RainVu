import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'data_ex_import_widget.dart' show DataExImportWidget;
import 'package:flutter/material.dart';

class DataExImportModel extends FlutterFlowModel<DataExImportWidget> {
  ///  State fields for stateful widgets in this page.

  DateTime? datePicked;

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;

  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;

  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  // State field(s) for Checkbox widget.
  bool? checkboxValue;
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
