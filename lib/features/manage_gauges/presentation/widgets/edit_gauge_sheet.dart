import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/app_constants.dart";
import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:rain_wise/features/manage_gauges/application/gauges_provider.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/gauge_form.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class EditGaugeSheet extends ConsumerWidget {
  const EditGaugeSheet({required this.gauge, super.key});

  final RainGauge gauge;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppConstants.horiEdgePadding,
          16,
          AppConstants.horiEdgePadding,
          16 + MediaQuery.of(context).viewInsets.bottom,
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
            Text(
              l10n.editGaugeSheetTitle,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            GaugeForm(
              gauge: gauge,
              onSave: (final name, final lat, final lng) {
                final RainGauge updatedGauge = gauge.copyWith(
                  name: name,
                  latitude: lat,
                  longitude: lng,
                );
                ref.read(gaugesProvider.notifier).updateGauge(updatedGauge);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
