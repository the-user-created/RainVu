import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_widgets.dart";

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
              Text("Manage Subscription", style: theme.headlineSmall),
              const SizedBox(height: 16),
              FFButtonWidget(
                onPressed: onManagePlan,
                text: "Manage Plan",
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 50,
                  color: theme.accent1,
                  textStyle: theme.titleSmall.override(color: Colors.white),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              const SizedBox(height: 16),
              FFButtonWidget(
                onPressed: onCancel,
                text: "Cancel Subscription",
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 50,
                  color: const Color(0x00FFFFFF),
                  textStyle: theme.titleSmall.override(color: theme.error),
                  elevation: 0,
                  borderSide: BorderSide(color: theme.error),
                  borderRadius: BorderRadius.circular(25),
                  hoverColor: const Color(0x21D93C4D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
