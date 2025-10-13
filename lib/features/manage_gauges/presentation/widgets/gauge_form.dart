import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/manage_gauges/application/gauges_provider.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";

class GaugeForm extends ConsumerStatefulWidget {
  const GaugeForm({super.key, this.gauge, this.onSave});

  final RainGauge? gauge;
  final FutureOr<void> Function(String name)? onSave;

  @override
  ConsumerState<GaugeForm> createState() => _GaugeFormState();
}

class _GaugeFormState extends ConsumerState<GaugeForm> {
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
      widget.onSave?.call(_nameController.text.trim());
    }
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<RainGauge>> gaugesAsync = ref.watch(gaugesProvider);

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
              final String trimmedVal = val?.trim() ?? "";
              if (trimmedVal.isEmpty) {
                return l10n.gaugeFormNameValidation;
              }

              if (gaugesAsync is AsyncData<List<RainGauge>>) {
                final List<RainGauge> gauges = gaugesAsync.value;
                final bool isDuplicate = gauges.any((final g) {
                  // When editing, allow saving with the original name.
                  if (isEditing && g.id == widget.gauge!.id) {
                    return false;
                  }
                  return g.name.toLowerCase() == trimmedVal.toLowerCase();
                });

                if (isDuplicate) {
                  return l10n.gaugeFormNameValidationDuplicate;
                }
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
                style: AppButtonStyle.outlineDestructive,
                size: AppButtonSize.small,
              ),
              const SizedBox(width: 12),
              AppButton(
                label: l10n.gaugeFormButtonSave,
                onPressed: _submit,
                size: AppButtonSize.small,
                borderRadius: BorderRadius.circular(8),
                style: AppButtonStyle.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
