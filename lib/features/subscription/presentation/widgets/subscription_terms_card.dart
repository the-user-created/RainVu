import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class SubscriptionTermsCard extends StatelessWidget {
  const SubscriptionTermsCard({
    required this.onViewBillingHelp,
    super.key,
  });

  final VoidCallback onViewBillingHelp;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: theme.primaryBackground,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Subscription Terms", style: theme.headlineSmall),
              const SizedBox(height: 16),
              Text(
                "Your subscription will automatically renew unless auto-renewal is turned off at least 24 hours before the end of the current period. You can manage your subscription and turn off auto-renewal by tapping Manage Plan above.",
                style: theme.bodyMedium.override(color: theme.secondaryText),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: onViewBillingHelp,
                child: Text(
                  "For billing support, please visit our Help Center",
                  style: theme.bodyMedium.override(
                    color: theme.primary,
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
