import "package:flutter/material.dart";

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
              Text("Subscription Terms", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text(
                "Your subscription will automatically renew unless auto-renewal is turned off at least 24 hours before the end of the current period. You can manage your subscription and turn off auto-renewal by tapping Manage Plan above.",
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: onViewBillingHelp,
                child: Text(
                  "For billing support, please visit our Help Center",
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
