import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/features/manage_gauges/application/gauges_provider.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/gauge_form.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart";
import "package:rain_wise/shared/widgets/sheets/interactive_sheet.dart";

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
          final RainGauge updatedGauge = gauge.copyWith(name: name);
          await ref.read(gaugesProvider.notifier).updateGauge(updatedGauge);
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
