import "dart:async";

import "package:flutter/material.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";

class GaugeForm extends StatefulWidget {
  const GaugeForm({super.key, this.gauge, this.onSave});

  final RainGauge? gauge;
  final FutureOr<void> Function(String name)? onSave;

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
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.gaugeFormNameLabel,
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
              hintText: l10n.gaugeFormNameHint,
              filled: true,
              fillColor: theme.colorScheme.surface,
            ),
            validator: (final val) {
              if (val == null || val.trim().isEmpty) {
                return l10n.gaugeFormNameValidation;
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                label: l10n.gaugeFormButtonCancel,
                onPressed: () => Navigator.pop(context),
                style: AppButtonStyle.outline,
                size: AppButtonSize.small,
              ),
              const SizedBox(width: 12),
              AppButton(
                label: l10n.gaugeFormButtonSave,
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
