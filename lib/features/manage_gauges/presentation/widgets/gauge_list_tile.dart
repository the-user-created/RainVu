import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:rain_wise/features/manage_gauges/application/gauges_provider.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/edit_gauge_sheet.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";

class GaugeListTile extends ConsumerWidget {
  const GaugeListTile({required this.gauge, super.key});

  final RainGauge gauge;

  void _showEditSheet(final BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (final context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: EditGaugeSheet(gauge: gauge),
      ),
    );
  }

  Future<void> _showDeleteDialog(
    final BuildContext context,
    final WidgetRef ref,
    final AppLocalizations l10n,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (final alertDialogContext) => AlertDialog(
        title: Text(l10n.deleteGaugeDialogTitle),
        content: Text(l10n.deleteGaugeDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(alertDialogContext, false),
            child: Text(l10n.deleteGaugeDialogActionCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(alertDialogContext, true),
            child: Text(
              l10n.deleteGaugeDialogActionDelete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      ref.read(gaugesProvider.notifier).deleteGauge(gauge.id);
    }
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(gauge.name, style: theme.textTheme.bodyLarge),
                // TODO: Display location if available
                Text(
                  l10n.gaugeTileNoLocation,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              AppIconButton(
                icon: Icon(
                  Icons.edit,
                  color: theme.colorScheme.onSurface,
                  size: 20,
                ),
                backgroundColor: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(30),
                onPressed: () => _showEditSheet(context),
                tooltip: l10n.gaugeTileEditTooltip,
              ),
              AppIconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                backgroundColor: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(30),
                onPressed: () => _showDeleteDialog(context, ref, l10n),
                tooltip: l10n.gaugeTileDeleteTooltip,
              ),
            ].divide(const SizedBox(width: 8)),
          ),
        ],
      ),
    );
  }
}
