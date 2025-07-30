import "package:flutter/material.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";

class SubscriptionActionsCard extends StatelessWidget {
  const SubscriptionActionsCard({
    required this.onManagePlan,
    required this.onCancel,
    super.key,
  });

  final VoidCallback onManagePlan;
  final VoidCallback onCancel;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
              Text("Manage Subscription", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              AppButton(
                onPressed: onManagePlan,
                label: "Manage Plan",
                isExpanded: true,
              ),
              const SizedBox(height: 16),
              AppButton(
                onPressed: onCancel,
                label: "Cancel Subscription",
                isExpanded: true,
                style: AppButtonStyle.outlineDestructive,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
