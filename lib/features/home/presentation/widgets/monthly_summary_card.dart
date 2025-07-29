import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:rain_wise/core/navigation/app_route_names.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";

class RecentEntry {
  const RecentEntry({required this.dateLabel, required this.amount});

  final String dateLabel;
  final String amount;
}

class MonthlySummaryCard extends StatelessWidget {
  const MonthlySummaryCard({
    required this.currentMonth,
    required this.monthlyTotal,
    required this.recentEntries,
    super.key,
  });

  final String currentMonth;
  final String monthlyTotal;
  final List<RecentEntry> recentEntries;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x33000000),
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, theme),
            const SizedBox(height: 8),
            _buildTotal(theme),
            const Divider(height: 24, thickness: 1),
            _buildRecentEntriesHeader(theme),
            const SizedBox(height: 4),
            ...recentEntries
                .map((final entry) => _buildRecentEntryRow(entry, theme)),
            const SizedBox(height: 8),
            _buildViewHistoryButton(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    final BuildContext context,
    final FlutterFlowTheme theme,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Monthly Rainfall",
            style: theme.titleMedium.override(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            currentMonth,
            style: theme.bodyMedium.override(
              color: theme.secondaryText,
            ),
          ),
        ],
      );

  Widget _buildTotal(final FlutterFlowTheme theme) => Row(
        children: [
          Icon(Icons.water_drop, color: theme.primary, size: 36),
          const SizedBox(width: 8),
          Text(
            monthlyTotal,
            style: theme.displaySmall.override(
              color: theme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget _buildRecentEntriesHeader(final FlutterFlowTheme theme) => Text(
        "Recent Entries",
        style: theme.labelMedium.override(
          fontWeight: FontWeight.w600,
        ),
      );

  Widget _buildRecentEntryRow(
    final RecentEntry entry,
    final FlutterFlowTheme theme,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              entry.dateLabel,
              style: theme.bodyMedium.override(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              entry.amount,
              style: theme.bodyMedium.override(
                color: theme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  Widget _buildViewHistoryButton(
    final BuildContext context,
    final FlutterFlowTheme theme,
  ) =>
      Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            // TODO: Take user to monthly breakdown for the *current* month
            context.pushNamed(AppRouteNames.monthlyBreakdownName);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "View Full History",
                style: theme.bodyMedium.override(
                  color: theme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_rounded, color: theme.primary, size: 20),
            ],
          ),
        ),
      );
}
