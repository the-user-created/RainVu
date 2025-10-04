import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/manage_gauges/application/gauges_provider.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/gauge_form.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart";
import "package:rain_wise/shared/widgets/sheets/interactive_sheet.dart";

class AddGaugeSheet extends ConsumerWidget {
  const AddGaugeSheet({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return InteractiveSheet(
      title: Text(l10n.addGaugeSheetTitle),
      child: GaugeForm(
        onSave: (final name) async {
          final RainGauge newGauge = await ref
              .read(gaugesProvider.notifier)
              .addGauge(name: name);
          if (context.mounted) {
            Navigator.pop(context, newGauge);
          }
        },
      ),
    );
  }
}
