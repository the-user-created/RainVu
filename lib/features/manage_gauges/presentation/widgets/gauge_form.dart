import "package:flutter/material.dart";
import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";

class GaugeForm extends StatefulWidget {
  const GaugeForm({super.key, this.gauge, this.onSave});

  final RainGauge? gauge;
  final Function(String name)? onSave;

  @override
  State<GaugeForm> createState() => _GaugeFormState();
}

class _GaugeFormState extends State<GaugeForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  bool get isEditing => widget.gauge != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.gauge?.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave?.call(_nameController.text);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rain Gauge Name",
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "E.g., Garden Gauge #1",
              filled: true,
              fillColor: theme.colorScheme.surface,
            ),
            validator: (final val) {
              if (val == null || val.trim().isEmpty) {
                return "Name cannot be empty";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Location Field
          Text(
            "Location (Optional)",
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          // TODO: Implement a real Place Picker widget
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Place picker coming soon!")),
              );
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Icons.place, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 12),
                  Text("Select Location", style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                label: "Cancel",
                onPressed: () => Navigator.pop(context),
                style: AppButtonStyle.outline,
                size: AppButtonSize.small,
              ),
              const SizedBox(width: 12),
              AppButton(
                label: "Save",
                onPressed: _submit,
                size: AppButtonSize.small,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
