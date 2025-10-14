import "package:flutter/material.dart";
import "package:rainly/app_constants.dart";
import "package:rainly/features/manage_gauges/presentation/widgets/add_gauge_sheet.dart";
import "package:rainly/features/manage_gauges/presentation/widgets/gauge_list.dart";
import "package:rainly/l10n/app_localizations.dart";
import "package:rainly/shared/utils/adaptive_ui_helpers.dart";
import "package:rainly/shared/widgets/buttons/app_icon_button.dart";

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AppIconButton(
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 30,
              onPressed: () => _showAddSheet(context),
              tooltip: l10n.addGaugeTooltip,
            ),
          ),
        ],
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.horiEdgePadding,
            vertical: 16,
          ),
          child: GaugeList(),
        ),
      ),
    );
  }
}
