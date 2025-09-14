import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";

class GaugeForm extends StatefulWidget {
  const GaugeForm({super.key, this.gauge, this.onSave});

  final RainGauge? gauge;
  final Function(String name, double? lat, double? lng)? onSave;

  @override
  State<GaugeForm> createState() => _GaugeFormState();
}

class _GaugeFormState extends State<GaugeForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _latController;
  late final TextEditingController _lngController;

  bool get isEditing => widget.gauge != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.gauge?.name);
    _latController =
        TextEditingController(text: widget.gauge?.latitude?.toString() ?? "");
    _lngController =
        TextEditingController(text: widget.gauge?.longitude?.toString() ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _submit() {
    // TODO: Should implement validation of lat long
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave?.call(
        _nameController.text,
        double.tryParse(_latController.text),
        double.tryParse(_lngController.text),
      );
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
          const SizedBox(height: 16),

          // Location Fields
          Text(
            l10n.gaugeFormLocationLabel,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _latController,
                  decoration: const InputDecoration(hintText: "Latitude"),
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"^-?\d+\.?\d*")),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _lngController,
                  decoration: const InputDecoration(hintText: "Longitude"),
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"^-?\d+\.?\d*")),
                  ],
                ),
              ),
            ],
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
