import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

import "package:rain_wise/flutter_flow/flutter_flow_util.dart";
import "package:rain_wise/flutter_flow/form_field_controller.dart";

class ChipData {
  const ChipData(this.label, [this.iconData]);

  final String label;
  final IconData? iconData;
}

class ChipStyle {
  const ChipStyle({
    this.backgroundColor,
    this.textStyle,
    this.iconColor,
    this.iconSize,
    this.labelPadding,
    this.elevation,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
  });

  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsetsGeometry? labelPadding;
  final double? elevation;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
}

class FlutterFlowChoiceChips extends StatefulWidget {
  const FlutterFlowChoiceChips({
    required this.options,
    required this.onChanged,
    required this.controller,
    required this.selectedChipStyle,
    required this.unselectedChipStyle,
    required this.chipSpacing,
    required this.multiselect,
    super.key,
    this.rowSpacing = 0.0,
    this.initialized = true,
    this.alignment = WrapAlignment.start,
    this.disabledColor,
    this.wrapped = true,
  });

  final List<ChipData> options;
  final void Function(List<String>?)? onChanged;
  final FormFieldController<List<String>> controller;
  final ChipStyle selectedChipStyle;
  final ChipStyle unselectedChipStyle;
  final double chipSpacing;
  final double rowSpacing;
  final bool multiselect;
  final bool initialized;
  final WrapAlignment alignment;
  final Color? disabledColor;
  final bool wrapped;

  @override
  State<FlutterFlowChoiceChips> createState() => _FlutterFlowChoiceChipsState();
}

class _FlutterFlowChoiceChipsState extends State<FlutterFlowChoiceChips> {
  late List<String> choiceChipValues;

  List<String> get selectedValues => widget.controller.value ?? [];

  @override
  void initState() {
    super.initState();
    choiceChipValues = List.from(selectedValues);
    if (!widget.initialized && choiceChipValues.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback(
        (final _) {
          widget.onChanged?.call(choiceChipValues);
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final List<Widget> children = widget.options.map<Widget>(
      (final option) {
        final bool selected = selectedValues.contains(option.label);
        final ChipStyle style =
            selected ? widget.selectedChipStyle : widget.unselectedChipStyle;
        return Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: ChoiceChip(
            selected: selected,
            onSelected: widget.onChanged != null
                ? (final isSelected) {
                    choiceChipValues = List.from(selectedValues);
                    if (isSelected) {
                      widget.multiselect
                          ? choiceChipValues.add(option.label)
                          : choiceChipValues = [option.label];
                      widget.controller.value = List.from(choiceChipValues);
                      setState(() {});
                    } else {
                      if (widget.multiselect) {
                        choiceChipValues.remove(option.label);
                        widget.controller.value = List.from(choiceChipValues);
                        setState(() {});
                      }
                    }
                    widget.onChanged!(choiceChipValues);
                  }
                : null,
            label: Text(
              option.label,
              style: style.textStyle,
              overflow: TextOverflow.ellipsis,
            ),
            labelPadding: style.labelPadding,
            avatar: option.iconData != null
                ? FaIcon(
                    option.iconData,
                    size: style.iconSize,
                    color: style.iconColor,
                  )
                : null,
            elevation: style.elevation,
            disabledColor: widget.disabledColor,
            selectedColor:
                selected ? widget.selectedChipStyle.backgroundColor : null,
            backgroundColor:
                selected ? null : widget.unselectedChipStyle.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: style.borderRadius ?? BorderRadius.circular(16),
              side: BorderSide(
                color: style.borderColor ?? Colors.transparent,
                width: style.borderWidth ?? 0,
              ),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        );
      },
    ).toList();

    if (widget.wrapped) {
      return Wrap(
        spacing: widget.chipSpacing,
        runSpacing: widget.rowSpacing,
        alignment: widget.alignment,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: children,
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          children: children.divide(
            SizedBox(width: widget.chipSpacing),
          ),
        ),
      );
    }
  }
}
