import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:rain_wise/features/manage_gauges/application/gauges_provider.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/edit_gauge_sheet.dart";
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
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (final alertDialogContext) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: const Text("Are you sure you want to delete this rain gauge?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(alertDialogContext, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(alertDialogContext, true),
            child: Text(
              "Delete",
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
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
                  "No location set",
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
                tooltip: "Edit Gauge",
              ),
              AppIconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                backgroundColor: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(30),
                onPressed: () => _showDeleteDialog(context, ref),
                tooltip: "Delete Gauge",
              ),
            ].divide(const SizedBox(width: 8)),
          ),
        ],
      ),
    );
  }
}
