import "package:flutter/material.dart";
import "package:rain_wise/features/map/domain/rainfall_map_entry.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/flutter_flow/flutter_flow_util.dart";

class RainfallListItem extends StatelessWidget {
  const RainfallListItem({
    required this.entry,
    super.key,
  });

  final RainfallMapEntry entry;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateTimeFormat("relative", entry.dateTime),
                      style: theme.bodyMedium.override(
                        fontFamily: "Inter",
                        color: theme.secondaryText,
                        letterSpacing: 0,
                      ),
                    ),
                    Text(
                      entry.locationName,
                      style: theme.bodyLarge.override(
                        fontFamily: "Inter",
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          entry.amount.toStringAsFixed(0),
                          style: theme.titleLarge.override(
                            fontFamily: "Readex Pro",
                            color: theme.primary,
                            letterSpacing: 0,
                          ),
                        ),
                        Text(
                          entry.unit,
                          style: theme.bodySmall.override(
                            fontFamily: "Inter",
                            color: theme.primary,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: theme.secondaryText,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  entry.coordinates,
                  style: theme.bodySmall.override(
                    fontFamily: "Inter",
                    color: theme.secondaryText,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ].divide(const SizedBox(height: 12)),
        ),
      ),
    );
  }
}
