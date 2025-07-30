import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/utils/extensions.dart";
import "package:rain_wise/features/home/domain/rain_gauge.dart";
import "package:rain_wise/features/manage_gauges/application/gauges_provider.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/edit_gauge_sheet.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";

class GaugeListTile extends ConsumerWidget {
  const GaugeListTile({required this.gauge, super.key});

  final RainGauge gauge;

  void _showEditSheet(final BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final _) => EditGaugeSheet(gauge: gauge),
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
            child: const Text("Confirm"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(gaugesProvider.notifier).deleteGauge(gauge.id);
    }
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.alternate,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(gauge.name, style: theme.bodyLarge),
              // TODO: Display location if available
              Text("No location set", style: theme.bodySmall),
            ],
          ),
          Row(
            children: [
              AppIconButton(
                icon: Icon(Icons.edit, color: theme.primaryText, size: 20),
                backgroundColor: theme.primaryBackground,
                borderRadius: BorderRadius.circular(30),
                onPressed: () => _showEditSheet(context),
                tooltip: "Edit Gauge",
              ),
              AppIconButton(
                icon: Icon(Icons.delete_outline, color: theme.error, size: 20),
                backgroundColor: theme.primaryBackground,
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
