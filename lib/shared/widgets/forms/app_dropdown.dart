import "package:flutter/material.dart";

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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    final TextStyle effectiveStyle = style ?? textTheme.bodyMedium!;
    final BorderRadius effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(8);
    final Color effectiveFillColor = fillColor ?? colorScheme.surface;
    final EdgeInsetsGeometry effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 4);

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveFillColor,
        borderRadius: effectiveBorderRadius,
        border: Border.all(
          color: borderColor ?? colorScheme.outline,
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
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
              : null,
          icon: icon ?? Icon(Icons.expand_more, color: colorScheme.secondary),
          style: effectiveStyle,
          dropdownColor: dropdownColor ?? colorScheme.surface,
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
            final ThemeData theme = Theme.of(state.context);
            final ColorScheme colorScheme = theme.colorScheme;
            final TextTheme textTheme = theme.textTheme;
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
                  fillColor: colorScheme.surface,
                  borderColor:
                      hasError ? colorScheme.error : colorScheme.outline,
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
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
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
