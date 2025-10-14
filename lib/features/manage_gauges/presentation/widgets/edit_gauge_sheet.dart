import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainly/core/utils/snackbar_service.dart";
import "package:rainly/features/manage_gauges/application/gauges_provider.dart";
import "package:rainly/features/manage_gauges/presentation/widgets/gauge_form.dart";
import "package:rainly/l10n/app_localizations.dart";
import "package:rainly/shared/domain/rain_gauge.dart";
import "package:rainly/shared/utils/ui_helpers.dart";
import "package:rainly/shared/widgets/sheets/interactive_sheet.dart";

class EditGaugeSheet extends ConsumerWidget {
  const EditGaugeSheet({required this.gauge, super.key});

  final RainGauge gauge;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return InteractiveSheet(
      title: Text(l10n.editGaugeSheetTitle),
      child: GaugeForm(
        gauge: gauge,
        onSave: (final name) async {
          try {
            final RainGauge updatedGauge = gauge.copyWith(name: name);
            await ref.read(gaugesProvider.notifier).updateGauge(updatedGauge);
            showSnackbar(
              l10n.gaugeUpdatedSuccess(updatedGauge.name),
              type: MessageType.success,
            );
            if (context.mounted) {
              Navigator.pop(context);
            }
          } catch (e, s) {
            FirebaseCrashlytics.instance.recordError(
              e,
              s,
              reason: "Failed to update gauge from sheet",
            );
            showSnackbar(l10n.gaugeUpdatedError, type: MessageType.error);
          }
        },
      ),
    );
  }
}
