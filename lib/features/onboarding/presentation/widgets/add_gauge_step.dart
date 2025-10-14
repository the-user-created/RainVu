// lib/features/onboarding/presentation/widgets/add_gauge_step.dart
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/utils/snackbar_service.dart";
import "package:rain_wise/features/manage_gauges/application/gauges_provider.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";

class AddGaugeStep extends ConsumerStatefulWidget {
  const AddGaugeStep({required this.onNext, required this.onSkip, super.key});

  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  ConsumerState<AddGaugeStep> createState() => _AddGaugeStepState();
}

class _AddGaugeStepState extends ConsumerState<AddGaugeStep> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveGauge() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isLoading = true);
    final AppLocalizations l10n = AppLocalizations.of(context);

    try {
      final String name = _nameController.text.trim();
      await ref.read(gaugesProvider.notifier).addGauge(name: name);
      showSnackbar(l10n.gaugeAddedSuccess(name), type: MessageType.success);
      widget.onNext();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to add gauge during onboarding",
      );
      showSnackbar(l10n.gaugeAddedError, type: MessageType.error);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<RainGauge>> gaugesAsync = ref.watch(gaugesProvider);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  Text(
                    l10n.onboardingGaugeTitle,
                    style: theme.textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.onboardingGaugeSubtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.gaugeFormNameLabel,
                        hintText: l10n.onboardingGaugeHint,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                      ),
                      validator: (final val) {
                        final String trimmedVal = val?.trim() ?? "";
                        if (trimmedVal.isEmpty) {
                          return l10n.gaugeFormNameValidation;
                        }
                        if (gaugesAsync is AsyncData<List<RainGauge>>) {
                          final List<RainGauge> gauges = gaugesAsync.value;
                          final bool isDuplicate = gauges.any(
                            (final g) =>
                                g.name.toLowerCase() ==
                                trimmedVal.toLowerCase(),
                          );
                          if (isDuplicate) {
                            return l10n.gaugeFormNameValidationDuplicate;
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppButton(
                    onPressed: _saveGauge,
                    label: l10n.onboardingButtonSaveAndContinue,
                    isLoading: _isLoading,
                    isExpanded: true,
                    style: AppButtonStyle.secondary,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    onPressed: widget.onSkip,
                    label: l10n.skipButtonLabel,
                    style: AppButtonStyle.outlineDestructive,
                    isExpanded: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
