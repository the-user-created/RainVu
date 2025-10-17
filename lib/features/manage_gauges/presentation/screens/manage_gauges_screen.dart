import "package:flutter/material.dart";
import "package:rainvu/app_constants.dart";
import "package:rainvu/features/manage_gauges/presentation/widgets/add_gauge_sheet.dart";
import "package:rainvu/features/manage_gauges/presentation/widgets/gauge_list.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/utils/adaptive_ui_helpers.dart";

class ManageGaugesScreen extends StatelessWidget {
  const ManageGaugesScreen({super.key});

  void _showAddSheet(final BuildContext context) {
    showAdaptiveSheet<void>(
      context: context,
      builder: (final context) => const AddGaugeSheet(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.manageGaugesTitle,
          style: theme.textTheme.headlineMedium,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context),
        tooltip: l10n.addGaugeTooltip,
        shape: const CircleBorder(),
        heroTag: null,
        child: const Icon(Icons.add),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppConstants.horiEdgePadding,
            16,
            AppConstants.horiEdgePadding,
            88,
          ),
          child: GaugeList(),
        ),
      ),
    );
  }
}
