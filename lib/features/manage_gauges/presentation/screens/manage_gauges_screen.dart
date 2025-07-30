import "package:flutter/material.dart";
import "package:rain_wise/app_constants.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/add_gauge_sheet.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/gauge_list.dart";
import "package:rain_wise/shared/widgets/buttons/app_button.dart";

class ManageGaugesScreen extends StatelessWidget {
  const ManageGaugesScreen({super.key});

  void _showAddSheet(final BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (final context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const AddGaugeSheet(),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Rain Gauges", style: theme.textTheme.headlineLarge),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.horiEdgePadding)
            .copyWith(top: 16),
        child: Column(
          children: [
            const GaugeList(),
            const SizedBox(height: 16),
            AppButton(
              label: "Add New Rain Gauge",
              onPressed: () => _showAddSheet(context),
              icon: Icon(
                Icons.add,
                size: 20,
                color: theme.colorScheme.onSecondary,
              ),
              isExpanded: true,
              style: AppButtonStyle.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
