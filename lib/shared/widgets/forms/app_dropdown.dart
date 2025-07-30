import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

/// A custom, modern dropdown button with consistent app styling.
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    required this.items,
    required this.onChanged,
    super.key,
    this.value,
    this.hintText,
    this.isExpanded = true,
    this.icon,
    this.style,
    this.dropdownColor,
    this.borderRadius,
    this.borderColor,
    this.fillColor,
    this.padding,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? hintText;
  final bool isExpanded;
  final Widget? icon;
  final TextStyle? style;
  final Color? dropdownColor;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? fillColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);

    final TextStyle effectiveStyle = style ?? theme.bodyMedium;
    final BorderRadius effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(8);
    final Color effectiveFillColor = fillColor ?? theme.secondaryBackground;
    final EdgeInsetsGeometry effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 4);

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveFillColor,
        borderRadius: effectiveBorderRadius,
        border: Border.all(
          color: borderColor ?? theme.alternate,
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: isExpanded,
          hint: hintText != null
              ? Text(
                  hintText!,
                  style: theme.bodyLarge.override(
                    color: theme.secondaryText,
                    fontFamily: theme.bodyLargeFamily,
                  ),
                )
              : null,
          icon: icon ?? Icon(Icons.expand_more, color: theme.primary),
          style: effectiveStyle,
          dropdownColor: dropdownColor ?? theme.secondaryBackground,
        ),
      ),
    );
  }
}

/// A form field variant of [AppDropdown].
///
/// Integrates with a [Form] to provide validation and state management.
class AppDropdownFormField<T> extends FormField<T> {
  AppDropdownFormField({
    required final List<DropdownMenuItem<T>> items,
    required final ValueChanged<T?> onChanged,
    final T? value,
    final String? hintText,
    final bool isExpanded = true,
    super.onSaved,
    super.validator,
    super.key,
  }) : super(
          initialValue: value,
          builder: (final field) {
            final _AppDropdownFormFieldState<T> state =
                field as _AppDropdownFormFieldState<T>;
            final FlutterFlowTheme theme = FlutterFlowTheme.of(state.context);
            final bool hasError = field.hasError;

            void handleChanged(final T? newValue) {
              state.didChange(newValue);
              onChanged(newValue);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppDropdown<T>(
                  items: items,
                  onChanged: handleChanged,
                  value: state.value,
                  hintText: hintText,
                  isExpanded: isExpanded,
                  fillColor: theme.secondaryBackground,
                  borderColor: hasError ? theme.error : theme.alternate,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                if (hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 5),
                    child: Text(
                      field.errorText!,
                      style: theme.bodySmall.override(
                        fontFamily: theme.bodySmallFamily,
                        color: theme.error,
                      ),
                    ),
                  ),
              ],
            );
          },
        );

  @override
  FormFieldState<T> createState() => _AppDropdownFormFieldState<T>();
}

class _AppDropdownFormFieldState<T> extends FormFieldState<T> {}
