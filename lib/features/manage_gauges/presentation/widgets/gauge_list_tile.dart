import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rain_wise/app_constants.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/core/data/repositories/rainfall_repository.dart";
import "package:rain_wise/core/navigation/app_router.dart";
import "package:rain_wise/core/utils/snackbar_service.dart";
import "package:rain_wise/features/manage_gauges/application/gauges_provider.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/edit_gauge_sheet.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/rain_gauge.dart";
import "package:rain_wise/shared/utils/adaptive_ui_helpers.dart";
import "package:rain_wise/shared/utils/ui_helpers.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";
import "package:rain_wise/shared/widgets/dialogs/app_alert_dialog.dart";

class GaugeListTile extends ConsumerStatefulWidget {
  const GaugeListTile({required this.gauge, super.key});

  final RainGauge gauge;

  @override
  ConsumerState<GaugeListTile> createState() => _GaugeListTileState();
}

class _GaugeListTileState extends ConsumerState<GaugeListTile> {
  bool _isPressed = false;

  void _onTap() {
    final String month = DateFormat("yyyy-MM").format(DateTime.now());
    RainfallEntriesRoute(month: month, gaugeId: widget.gauge.id).push(context);
  }

  void _showEditSheet(final BuildContext context) {
    showAdaptiveSheet<void>(
      context: context,
      builder: (final context) => EditGaugeSheet(gauge: widget.gauge),
    );
  }

  Future<void> _showDeleteDialog(
    final BuildContext context,
    final WidgetRef ref,
    final AppLocalizations l10n,
  ) async {
    final int entryCount = await ref
        .read(rainfallRepositoryProvider)
        .countEntriesForGauge(widget.gauge.id);

    if (entryCount == 0) {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (final alertDialogContext) => AppAlertDialog(
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
        await ref.read(gaugesProvider.notifier).deleteGauge(widget.gauge.id);
        showSnackbar(
          l10n.gaugeDeletedSuccess(widget.gauge.name),
          type: MessageType.success,
        );
      }
      return;
    }

    bool deleteEntries = false;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => StatefulBuilder(
        builder: (final context, final setState) => AppAlertDialog(
          title: Text(l10n.deleteGaugeDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.deleteGaugeWithEntriesWarning(
                  entryCount,
                  l10n.defaultGaugeName,
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text(l10n.deleteGaugeAndEntriesOption(entryCount)),
                value: deleteEntries,
                onChanged: (final val) =>
                    setState(() => deleteEntries = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.deleteGaugeDialogActionCancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                l10n.deleteGaugeDialogActionDelete,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && context.mounted) {
      final DeleteGaugeAction action = deleteEntries
          ? DeleteGaugeAction.deleteEntries
          : DeleteGaugeAction.reassign;
      await ref
          .read(gaugesProvider.notifier)
          .deleteGauge(widget.gauge.id, action: action);
      showSnackbar(
        l10n.gaugeDeletedSuccess(widget.gauge.name),
        type: MessageType.success,
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String? favoriteGaugeId = ref
        .watch(userPreferencesProvider)
        .value
        ?.favoriteGaugeId;
    final bool isFavorite = widget.gauge.id == favoriteGaugeId;
    final bool isDefaultGauge = widget.gauge.id == AppConstants.defaultGaugeId;
    final String displayName = isDefaultGauge
        ? l10n.defaultGaugeName
        : widget.gauge.name;

    return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _onTap,
            onTapDown: (final _) => setState(() => _isPressed = true),
            onTapUp: (final _) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.gaugeEntryCount(widget.gauge.entryCount),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      AppIconButton(
                        icon: Icon(
                          isFavorite ? Icons.star : Icons.star_border_outlined,
                          size: 22,
                        ),
                        color: isFavorite
                            ? Colors.amber[600]
                            : theme.colorScheme.onSurfaceVariant,
                        tooltip: l10n.gaugeTileSetFavoriteTooltip,
                        onPressed: () async {
                          final String? newFavoriteId = isFavorite
                              ? null
                              : widget.gauge.id;
                          await ref
                              .read(userPreferencesProvider.notifier)
                              .setFavoriteGauge(newFavoriteId);
                          final String message = isFavorite
                              ? l10n.gaugeUnsetAsFavorite(displayName)
                              : l10n.gaugeSetAsFavorite(displayName);
                          showSnackbar(message, type: MessageType.success);
                        },
                      ),
                      if (!isDefaultGauge)
                        AppIconButton(
                          icon: const Icon(Icons.edit_outlined, size: 22),
                          tooltip: l10n.gaugeTileEditTooltip,
                          color: theme.colorScheme.onSurfaceVariant,
                          onPressed: () => _showEditSheet(context),
                        ),
                      if (!isDefaultGauge)
                        AppIconButton(
                          icon: const Icon(Icons.delete_outline, size: 22),
                          tooltip: l10n.gaugeTileDeleteTooltip,
                          color: theme.colorScheme.error,
                          onPressed: () =>
                              _showDeleteDialog(context, ref, l10n),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
        .animate(target: _isPressed ? 1 : 0)
        .scaleXY(end: 0.98, duration: 150.ms, curve: Curves.easeOut);
  }
}
