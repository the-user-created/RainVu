import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/features/rainfall_entry/application/rainfall_entry_provider.dart";
import "package:rain_wise/features/rainfall_entry/domain/rainfall_entry.dart";
import "package:rain_wise/features/rainfall_entry/presentation/widgets/edit_entry_sheet.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";

class RainfallEntryListItem extends ConsumerWidget {
  const RainfallEntryListItem({required this.entry, super.key});

  final RainfallEntry entry;

  void _showEditSheet(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final _) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: EditEntrySheet(entry: entry),
      ),
    );
  }

  Future<void> _deleteEntry(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text("Delete Entry?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true && entry.id != null) {
      ref.read(rainfallEntryNotifierProvider.notifier).deleteEntry(entry.id!);
    }
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    final String gaugeName = entry.gauge?.name ?? "Loading...";

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: theme.secondaryBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMd().format(entry.date),
                    style: theme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${entry.amount} ${entry.unit} - $gaugeName",
                    style:
                        theme.bodyMedium.override(color: theme.secondaryText),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                AppIconButton(
                  backgroundColor: theme.alternate,
                  icon: Icon(
                    Icons.edit_outlined,
                    color: theme.primary,
                    size: 24,
                  ),
                  tooltip: "Edit Entry",
                  onPressed: () => _showEditSheet(context),
                ),
                const SizedBox(width: 8),
                AppIconButton(
                  backgroundColor: theme.alternate,
                  icon: Icon(
                    Icons.delete_outline,
                    color: theme.error,
                    size: 24,
                  ),
                  tooltip: "Delete Entry",
                  onPressed: () => _deleteEntry(context, ref),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
