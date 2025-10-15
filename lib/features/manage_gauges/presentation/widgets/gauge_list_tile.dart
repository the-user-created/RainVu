import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:rainvu/app_constants.dart";
import "package:rainvu/core/application/preferences_provider.dart";
import "package:rainvu/core/data/repositories/rainfall_repository.dart";
import "package:rainvu/core/navigation/app_router.dart";
import "package:rainvu/core/utils/snackbar_service.dart";
import "package:rainvu/features/manage_gauges/application/gauges_provider.dart";
import "package:rainvu/features/manage_gauges/presentation/widgets/edit_gauge_sheet.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/domain/rain_gauge.dart";
import "package:rainvu/shared/utils/adaptive_ui_helpers.dart";
import "package:rainvu/shared/utils/ui_helpers.dart";
import "package:rainvu/shared/widgets/buttons/app_button.dart";
import "package:rainvu/shared/widgets/buttons/app_icon_button.dart";
import "package:rainvu/shared/widgets/sheets/interactive_sheet.dart";

class GaugeListTile extends ConsumerStatefulWidget {
  const GaugeListTile({required this.gauge, super.key});

  final RainGauge gauge;

  @override
  ConsumerState<GaugeListTile> createState() => _GaugeListTileState();
}

enum _DeleteConfirmationResult { cancel, deleteReassign, deleteWithEntries }

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

  Future<void> _showDeleteSheet(
    final BuildContext context,
    final WidgetRef ref,
    final AppLocalizations l10n,
    final String displayName,
  ) async {
    final int entryCount = await ref
        .read(rainfallRepositoryProvider)
        .countEntriesForGauge(widget.gauge.id);

    final _DeleteConfirmationResult? result =
        await showAdaptiveSheet<_DeleteConfirmationResult>(
          context: context,
          builder: (final _) =>
              _DeleteGaugeSheet(entryCount: entryCount, gaugeName: displayName),
        );

    if (result == null || result == _DeleteConfirmationResult.cancel) {
      return;
    }

    final DeleteGaugeAction action =
        result == _DeleteConfirmationResult.deleteWithEntries
        ? DeleteGaugeAction.deleteEntries
        : DeleteGaugeAction.reassign;

    try {
      if (context.mounted) {
        await ref
            .read(gaugesProvider.notifier)
            .deleteGauge(widget.gauge.id, action: action);
        showSnackbar(
          l10n.gaugeDeletedSuccess(widget.gauge.name),
          type: MessageType.success,
        );
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Failed to delete gauge",
      );
      showSnackbar(l10n.gaugeDeletedError, type: MessageType.error);
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
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 8,
                spacing: 16,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        l10n.gaugeEntryCount(widget.gauge.entryCount),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
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
                          try {
                            await ref
                                .read(userPreferencesProvider.notifier)
                                .setFavoriteGauge(newFavoriteId);
                            final String message = isFavorite
                                ? l10n.gaugeUnsetAsFavorite(displayName)
                                : l10n.gaugeSetAsFavorite(displayName);
                            showSnackbar(message, type: MessageType.success);
                          } catch (e, s) {
                            FirebaseCrashlytics.instance.recordError(
                              e,
                              s,
                              reason: "Failed to set favorite gauge",
                            );
                            showSnackbar(
                              l10n.genericError,
                              type: MessageType.error,
                            );
                          }
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
                              _showDeleteSheet(context, ref, l10n, displayName),
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

class _DeleteGaugeSheet extends StatefulWidget {
  const _DeleteGaugeSheet({required this.entryCount, required this.gaugeName});

  final int entryCount;
  final String gaugeName;

  @override
  State<_DeleteGaugeSheet> createState() => _DeleteGaugeSheetState();
}

class _DeleteGaugeSheetState extends State<_DeleteGaugeSheet> {
  bool _deleteEntries = false;

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    final Widget content;
    if (widget.entryCount == 0) {
      content = Text(l10n.deleteGaugeDialogContent);
    } else {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.deleteGaugeWithEntriesWarning(
              widget.entryCount,
              l10n.defaultGaugeName,
            ),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: Text(l10n.deleteGaugeAndEntriesOption(widget.entryCount)),
            value: _deleteEntries,
            onChanged: (final val) =>
                setState(() => _deleteEntries = val ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      );
    }

    return InteractiveSheet(
      title: Text(l10n.deleteGaugeDialogTitle),
      actions: [
        AppButton(
          label: l10n.deleteGaugeDialogActionDelete,
          onPressed: () {
            if (widget.entryCount > 0 && _deleteEntries) {
              Navigator.pop(
                context,
                _DeleteConfirmationResult.deleteWithEntries,
              );
            } else {
              Navigator.pop(context, _DeleteConfirmationResult.deleteReassign);
            }
          },
          style: AppButtonStyle.destructive,
        ),
      ],
      child: content,
    );
  }
}
