import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/app_constants.dart";
import "package:rain_wise/features/manage_gauges/application/gauges_provider.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/gauge_form.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class AddGaugeSheet extends ConsumerWidget {
  const AddGaugeSheet({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppConstants.horiEdgePadding,
          16,
          AppConstants.horiEdgePadding,
          16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add New Rain Gauge", style: theme.headlineSmall),
            const SizedBox(height: 24),
            GaugeForm(
              onSave: (final name) {
                ref.read(gaugesProvider.notifier).addGauge(name: name);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
