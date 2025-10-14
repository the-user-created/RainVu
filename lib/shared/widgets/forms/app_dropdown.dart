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

    final InputDecoration effectiveDecoration = const InputDecoration()
        .applyDefaults(theme.inputDecorationTheme)
        .copyWith(
          contentPadding: padding,
          fillColor: fillColor,
          enabledBorder: theme.inputDecorationTheme.enabledBorder?.copyWith(
            borderSide: borderColor != null
                ? BorderSide(color: borderColor!)
                : null,
          ),
        );

    final TextStyle effectiveStyle = style ?? textTheme.bodyLarge!;

    return InputDecorator(
      decoration: effectiveDecoration,
      isEmpty: value == null,
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
          dropdownColor: dropdownColor ?? colorScheme.surfaceContainer,
          isDense: true,
        ),
      ),
    );
  }
}

/// A form field variant of [AppDropdown].
///
/// Integrates with a [Form] to provide validation and state management.
/// Uses [InputDecorator] to ensure visual consistency with other form fields.
class AppDropdownFormField<T> extends FormField<T> {
  AppDropdownFormField({
    required final List<DropdownMenuItem<T>> items,
    required final ValueChanged<T?> onChanged,
    final T? value,
    final String? hintText,
    final bool isExpanded = true,
    final InputDecoration? decoration,
    super.onSaved,
    super.validator,
    super.key,
  }) : super(
         initialValue: value,
         builder: (final field) {
           final ThemeData theme = Theme.of(field.context);
           final ColorScheme colorScheme = theme.colorScheme;
           final TextTheme textTheme = theme.textTheme;

           final InputDecoration effectiveDecoration =
               (decoration ?? const InputDecoration())
                   .applyDefaults(theme.inputDecorationTheme)
                   .copyWith(hintText: hintText, errorText: field.errorText);

           void handleChanged(final T? newValue) {
             field.didChange(newValue);
             onChanged(newValue);
           }

           return InputDecorator(
             decoration: effectiveDecoration,
             isEmpty: field.value == null,
             child: DropdownButtonHideUnderline(
               child: DropdownButton<T>(
                 value: field.value,
                 items: items,
                 onChanged: handleChanged,
                 isExpanded: isExpanded,
                 icon: Icon(Icons.expand_more, color: colorScheme.secondary),
                 style: textTheme.bodyLarge,
                 dropdownColor: colorScheme.surfaceContainer,
                 isDense: true,
               ),
             ),
           );
         },
       );
}
