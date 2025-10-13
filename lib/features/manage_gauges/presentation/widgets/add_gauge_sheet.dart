import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/utils/snackbar_service.dart";
import "package:rain_wise/features/manage_gauges/application/gauges_provider.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/gauge_form.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";
import "package:rain_wise/shared/widgets/sheets/interactive_sheet.dart";

class AddGaugeSheet extends ConsumerWidget {
  const AddGaugeSheet({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return InteractiveSheet(
      title: Text(l10n.addGaugeSheetTitle),
      child:
          GaugeForm(
                onSave: (final name) async {
                  try {
                    final RainGauge newGauge = await ref
                        .read(gaugesProvider.notifier)
                        .addGauge(name: name);
                    showSnackbar(
                      l10n.gaugeAddedSuccess(newGauge.name),
                      type: MessageType.success,
                    );
                    if (context.mounted) {
                      Navigator.pop(context, newGauge);
                    }
                  } catch (e, s) {
                    FirebaseCrashlytics.instance.recordError(
                      e,
                      s,
                      reason: "Failed to add gauge from sheet",
                    );
                    showSnackbar(l10n.gaugeAddedError, type: MessageType.error);
                  }
                },
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 100.ms)
              .slideY(begin: 0.1, curve: Curves.easeOutCubic),
    );
  }
}
