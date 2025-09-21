import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/app_constants.dart";
import "package:rain_wise/features/manage_gauges/application/gauges_provider.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/gauge_form.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart";

class AddGaugeSheet extends ConsumerWidget {
  const AddGaugeSheet({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppConstants.horiEdgePadding,
          16,
          AppConstants.horiEdgePadding,
          16,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.addGaugeSheetTitle, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 24),
            GaugeForm(
              onSave: (final name) async {
                final RainGauge newGauge = await ref
                    .read(gaugesProvider.notifier)
                    .addGauge(name: name);
                if (context.mounted) {
                  Navigator.pop(context, newGauge);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
