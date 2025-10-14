import "package:flutter/material.dart";
import "package:rainly/app_constants.dart";
import "package:rainly/l10n/app_localizations.dart";
import "package:rainly/shared/widgets/buttons/app_button.dart";

class DangerZoneCard extends StatelessWidget {
  const DangerZoneCard({required this.onReset, super.key});

  final VoidCallback onReset;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horiEdgePadding,
      ),
      child: Card(
        color: theme.colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.colorScheme.error, width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        shadowColor: theme.cardTheme.shadowColor,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.settingsDangerZoneResetApp,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.settingsDangerZoneDescription,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: AppButton(
                  onPressed: onReset,
                  label: l10n.settingsResetButton,
                  style: AppButtonStyle.destructive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
