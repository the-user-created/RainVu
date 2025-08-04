import "package:flutter/material.dart";
import "package:rain_wise/l10n/app_localizations.dart";

class SubscriptionTermsCard extends StatelessWidget {
  const SubscriptionTermsCard({
    required this.onViewBillingHelp,
    super.key,
  });

  final VoidCallback onViewBillingHelp;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.subscriptionTermsCardTitle,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.subscriptionTermsContent,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: onViewBillingHelp,
                child: Text(
                  l10n.subscriptionBillingHelpLink,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.secondary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
