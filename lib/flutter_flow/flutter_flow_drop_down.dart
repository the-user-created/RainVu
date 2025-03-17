import "package:dropdown_button2/dropdown_button2.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/form_field_controller.dart";

class FlutterFlowDropDown<T> extends StatefulWidget {
  const FlutterFlowDropDown({
    required this.options,
    required this.textStyle,
    required this.elevation,
    required this.borderWidth,
    required this.borderRadius,
    required this.borderColor,
    required this.margin,
    super.key,
    this.controller,
    this.multiSelectController,
    this.hintText,
    this.searchHintText,
    this.optionLabels,
    this.onChanged,
    this.onMultiSelectChanged,
    this.icon,
    this.width,
    this.height,
    this.maxHeight,
    this.fillColor,
    this.searchHintTextStyle,
    this.searchTextStyle,
    this.searchCursorColor,
    this.hidesUnderline = false,
    this.disabled = false,
    this.isOverButton = false,
    this.menuOffset,
    this.isSearchable = false,
    this.isMultiSelect = false,
    this.labelText,
    this.labelTextStyle,
    this.optionsHasValueKeys = false,
  }) : assert(
          isMultiSelect
              ? (controller == null &&
                  onChanged == null &&
                  multiSelectController != null &&
                  onMultiSelectChanged != null)
              : (controller != null &&
                  onChanged != null &&
                  multiSelectController == null &&
                  onMultiSelectChanged == null),
        );

  final FormFieldController<T?>? controller;
  final FormFieldController<List<T>?>? multiSelectController;
  final String? hintText;
  final String? searchHintText;
  final List<T> options;
  final List<String>? optionLabels;
  final Function(T?)? onChanged;
  final Function(List<T>?)? onMultiSelectChanged;
  final Widget? icon;
  final double? width;
  final double? height;
  final double? maxHeight;
  final Color? fillColor;
  final TextStyle? searchHintTextStyle;
  final TextStyle? searchTextStyle;
  final Color? searchCursorColor;
  final TextStyle textStyle;
  final double elevation;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;
  final EdgeInsetsGeometry margin;
  final bool hidesUnderline;
  final bool disabled;
  final bool isOverButton;
  final Offset? menuOffset;
  final bool isSearchable;
  final bool isMultiSelect;
  final String? labelText;
  final TextStyle? labelTextStyle;
  final bool optionsHasValueKeys;

  @override
  State<FlutterFlowDropDown<T>> createState() => _FlutterFlowDropDownState<T>();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<FormFieldController<T?>?>(
          "controller", controller))
      ..add(DiagnosticsProperty<FormFieldController<List<T>?>?>(
          "multiSelectController", multiSelectController))
      ..add(StringProperty("hintText", hintText))
      ..add(StringProperty("searchHintText", searchHintText))
      ..add(IterableProperty<T>("options", options))
      ..add(IterableProperty<String>("optionLabels", optionLabels))
      ..add(ObjectFlagProperty<Function(T? p1)?>.has("onChanged", onChanged))
      ..add(ObjectFlagProperty<Function(List<T>? p1)?>.has(
          "onMultiSelectChanged", onMultiSelectChanged))
      ..add(DoubleProperty("width", width))
      ..add(DoubleProperty("height", height))
      ..add(DoubleProperty("maxHeight", maxHeight))
      ..add(ColorProperty("fillColor", fillColor))
      ..add(DiagnosticsProperty<TextStyle?>(
          "searchHintTextStyle", searchHintTextStyle))
      ..add(DiagnosticsProperty<TextStyle?>("searchTextStyle", searchTextStyle))
      ..add(ColorProperty("searchCursorColor", searchCursorColor))
      ..add(DiagnosticsProperty<TextStyle>("textStyle", textStyle))
      ..add(DoubleProperty("elevation", elevation))
      ..add(DoubleProperty("borderWidth", borderWidth))
      ..add(DoubleProperty("borderRadius", borderRadius))
      ..add(ColorProperty("borderColor", borderColor))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>("margin", margin))
      ..add(DiagnosticsProperty<bool>("hidesUnderline", hidesUnderline))
      ..add(DiagnosticsProperty<bool>("disabled", disabled))
      ..add(DiagnosticsProperty<bool>("isOverButton", isOverButton))
      ..add(DiagnosticsProperty<Offset?>("menuOffset", menuOffset))
      ..add(DiagnosticsProperty<bool>("isSearchable", isSearchable))
      ..add(DiagnosticsProperty<bool>("isMultiSelect", isMultiSelect))
      ..add(StringProperty("labelText", labelText))
      ..add(DiagnosticsProperty<TextStyle?>("labelTextStyle", labelTextStyle))
      ..add(DiagnosticsProperty<bool>(
          "optionsHasValueKeys", optionsHasValueKeys));
  }
}

class _FlutterFlowDropDownState<T> extends State<FlutterFlowDropDown<T>> {
  bool get isMultiSelect => widget.isMultiSelect;

  FormFieldController<T?> get controller => widget.controller!;

  FormFieldController<List<T>?> get multiSelectController =>
      widget.multiSelectController!;

  T? get currentValue {
    final value = isMultiSelect
        ? multiSelectController.value?.firstOrNull
        : controller.value;
    return widget.options.contains(value) ? value : null;
  }

  Set<T> get currentValues {
    if (!isMultiSelect || multiSelectController.value == null) {
      return {};
    }
    return widget.options
        .toSet()
        .intersection(multiSelectController.value!.toSet());
  }

  Map<T, String> get optionLabels => Map.fromEntries(
        widget.options.asMap().entries.map(
              (final option) => MapEntry(
                option.value,
                widget.optionLabels == null ||
                        widget.optionLabels!.length < option.key + 1
                    ? option.value.toString()
                    : widget.optionLabels![option.key],
              ),
            ),
      );

  EdgeInsetsGeometry get horizontalMargin => widget.margin.clamp(
        EdgeInsetsDirectional.zero,
        const EdgeInsetsDirectional.symmetric(horizontal: double.infinity),
      );

  late void Function() _listener;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (isMultiSelect) {
      _listener =
          () => widget.onMultiSelectChanged!(multiSelectController.value);
      multiSelectController.addListener(_listener);
    } else {
      _listener = () => widget.onChanged!(controller.value);
      controller.addListener(_listener);
    }
  }

  @override
  void dispose() {
    if (isMultiSelect) {
      multiSelectController.removeListener(_listener);
    } else {
      controller.removeListener(_listener);
    }
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final Widget dropdownWidget = _buildDropdownWidget();
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
          color: widget.fillColor,
        ),
        child: Padding(
          padding: _useDropdown2() ? EdgeInsets.zero : widget.margin,
          child: widget.hidesUnderline
              ? DropdownButtonHideUnderline(child: dropdownWidget)
              : dropdownWidget,
        ),
      ),
    );
  }

  bool _useDropdown2() =>
      widget.isMultiSelect ||
      widget.isSearchable ||
      !widget.isOverButton ||
      widget.maxHeight != null;

  Widget _buildDropdownWidget() =>
      _useDropdown2() ? _buildDropdown() : _buildLegacyDropdown();

  Widget _buildLegacyDropdown() => DropdownButtonFormField<T>(
        value: currentValue,
        hint: _createHintText(),
        items: _createMenuItems(),
        elevation: widget.elevation.toInt(),
        onChanged:
            widget.disabled ? null : (final value) => controller.value = value,
        icon: widget.icon,
        isExpanded: true,
        dropdownColor: widget.fillColor,
        focusColor: Colors.transparent,
        decoration: InputDecoration(
          labelText: widget.labelText == null || widget.labelText!.isEmpty
              ? null
              : widget.labelText,
          labelStyle: widget.labelTextStyle,
          border: widget.hidesUnderline
              ? InputBorder.none
              : const UnderlineInputBorder(),
        ),
      );

  Text? _createHintText() => widget.hintText != null
      ? Text(widget.hintText!, style: widget.textStyle)
      : null;

  ValueKey _getItemKey(final T option) {
    final widgetKey = (widget.key! as ValueKey).value;
    return ValueKey("$widgetKey ${widget.options.indexOf(option)}");
  }

  List<DropdownMenuItem<T>> _createMenuItems() => widget.options
      .map(
        (final option) => DropdownMenuItem<T>(
            key: widget.optionsHasValueKeys ? _getItemKey(option) : null,
            value: option,
            child: Padding(
              padding: _useDropdown2() ? horizontalMargin : EdgeInsets.zero,
              child: Text(optionLabels[option] ?? "", style: widget.textStyle),
            )),
      )
      .toList();

  List<DropdownMenuItem<T>> _createMultiselectMenuItems() => widget.options
      .map(
        (final item) => DropdownMenuItem<T>(
          key: widget.optionsHasValueKeys ? _getItemKey(item) : null,
          value: item,
          // Disable default onTap to avoid closing menu when selecting an item
          enabled: false,
          child: StatefulBuilder(
            builder: (final context, final menuSetState) {
              final bool isSelected =
                  multiSelectController.value?.contains(item) ?? false;
              return InkWell(
                  onTap: () {
                    multiSelectController.value ??= [];
                    isSelected
                        ? multiSelectController.value!.remove(item)
                        : multiSelectController.value!.add(item);
                    multiSelectController.update();
                    // This rebuilds the StatefulWidget to update the button's text.
                    setState(() {});
                    // This rebuilds the dropdownMenu Widget to update the check mark.
                    menuSetState(() {});
                  },
                  child: Container(
                    height: double.infinity,
                    padding: horizontalMargin,
                    child: Row(
                      children: [
                        if (isSelected)
                          const Icon(Icons.check_box_outlined)
                        else
                          const Icon(Icons.check_box_outline_blank),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            optionLabels[item]!,
                            style: widget.textStyle,
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ),
      )
      .toList();

  Widget _buildDropdown() {
    final WidgetStateProperty<Color?> overlayColor =
        WidgetStateProperty.resolveWith<Color?>((final states) =>
            states.contains(WidgetState.focused) ? Colors.transparent : null);
    final iconStyleData = widget.icon != null
        ? IconStyleData(icon: widget.icon!)
        : const IconStyleData();
    return DropdownButton2<T>(
      value: currentValue,
      hint: _createHintText(),
      items: isMultiSelect ? _createMultiselectMenuItems() : _createMenuItems(),
      iconStyleData: iconStyleData,
      buttonStyleData: ButtonStyleData(
        elevation: widget.elevation.toInt(),
        overlayColor: overlayColor,
        padding: widget.margin,
      ),
      menuItemStyleData: MenuItemStyleData(
        overlayColor: overlayColor,
        padding: EdgeInsets.zero,
      ),
      dropdownStyleData: DropdownStyleData(
        elevation: widget.elevation.toInt(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: widget.fillColor,
        ),
        isOverButton: widget.isOverButton,
        offset: widget.menuOffset ?? Offset.zero,
        maxHeight: widget.maxHeight,
        padding: EdgeInsets.zero,
      ),
      onChanged: widget.disabled
          ? null
          : (isMultiSelect
              ? (final _) {}
              : (final val) => widget.controller!.value = val),
      isExpanded: true,
      selectedItemBuilder: (final context) => widget.options
          .map(
            (final item) => Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  isMultiSelect
                      ? currentValues
                          .where((final v) => optionLabels.containsKey(v))
                          .map((final v) => optionLabels[v])
                          .join(", ")
                      : optionLabels[item]!,
                  style: widget.textStyle,
                  maxLines: 1,
                )),
          )
          .toList(),
      dropdownSearchData: widget.isSearchable
          ? DropdownSearchData<T>(
              searchController: _textEditingController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Container(
                height: 50,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  controller: _textEditingController,
                  cursorColor: widget.searchCursorColor,
                  style: widget.searchTextStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: widget.searchHintText,
                    hintStyle: widget.searchHintTextStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (final item, final searchValue) =>
                  (optionLabels[item.value] ?? "")
                      .toLowerCase()
                      .contains(searchValue.toLowerCase()),
            )
          : null,
      // This is to clear the search value when you close the menu
      onMenuStateChange: widget.isSearchable
          ? (final isOpen) {
              if (!isOpen) {
                _textEditingController.clear();
              }
            }
          : null,
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>("isMultiSelect", isMultiSelect))
      ..add(DiagnosticsProperty<FormFieldController<T?>>(
          "controller", controller))
      ..add(DiagnosticsProperty<FormFieldController<List<T>?>>(
          "multiSelectController", multiSelectController))
      ..add(DiagnosticsProperty<T?>("currentValue", currentValue))
      ..add(IterableProperty<T>("currentValues", currentValues))
      ..add(DiagnosticsProperty<Map<T, String>>("optionLabels", optionLabels))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>(
          "horizontalMargin", horizontalMargin));
  }
}
