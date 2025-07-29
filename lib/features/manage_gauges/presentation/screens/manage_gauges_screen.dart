import "package:flutter/material.dart";
import "package:rain_wise/app_constants.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/add_gauge_sheet.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/gauge_list.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class ManageGaugesScreen extends StatelessWidget {
  const ManageGaugesScreen({super.key});

  void _showAddSheet(final BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final _) => const AddGaugeSheet(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.secondaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        iconTheme: IconThemeData(color: theme.primaryText),
        title: Text("Rain Gauges", style: theme.headlineLarge),
        elevation: 2,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.horiEdgePadding)
            .copyWith(top: 16),
        child: Column(
          children: [
            const GaugeList(),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 20),
              label: const Text("Add New Rain Gauge"),
              onPressed: () => _showAddSheet(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: theme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                textStyle: theme.titleSmall.override(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
