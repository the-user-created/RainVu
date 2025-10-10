import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:rain_wise/app_constants.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/add_gauge_sheet.dart";
import "package:rain_wise/features/manage_gauges/presentation/widgets/gauge_list.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/utils/adaptive_ui_helpers.dart";

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
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.horiEdgePadding,
            vertical: 16,
          ),
          child: GaugeList(),
        ),
      ),
      floatingActionButton:
          FloatingActionButton(
                onPressed: () => _showAddSheet(context),
                tooltip: l10n.addGaugeTooltip,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.add),
              )
              .animate()
              .slide(
                begin: const Offset(0, 1.5),
                duration: 500.ms,
                curve: Curves.easeOutCubic,
              )
              .fade(duration: 500.ms),
    );
  }
}
