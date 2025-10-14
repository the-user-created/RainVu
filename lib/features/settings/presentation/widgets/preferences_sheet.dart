import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainly/core/application/preferences_provider.dart";
import "package:rainly/l10n/app_localizations.dart";
import "package:rainly/shared/domain/seasons.dart";
import "package:rainly/shared/domain/user_preferences.dart";
import "package:rainly/shared/widgets/forms/app_segmented_control.dart";
import "package:rainly/shared/widgets/sheets/interactive_sheet.dart";

class PreferencesSheet extends ConsumerStatefulWidget {
  const PreferencesSheet({super.key});

  @override
  ConsumerState<PreferencesSheet> createState() => _PreferencesSheetState();
}

class _PreferencesSheetState extends ConsumerState<PreferencesSheet> {
  double? _currentThreshold;

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AsyncValue<UserPreferences> userPreferencesAsync = ref.watch(
      userPreferencesProvider,
    );

    return InteractiveSheet(
      title: Text(l10n.preferencesSheetTitle),
      child: userPreferencesAsync.when(
        loading: () => const SizedBox(
          height: 300,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (final err, final stack) {
          FirebaseCrashlytics.instance.recordError(
            err,
            stack,
            reason: "Failed to load preferences in sheet",
          );
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.genericError),
            ),
          );
        },
        data: (final userPreferences) {
          // Initialize the local state for the slider only when the widget
          // first builds with data. This prevents the slider from resetting
          // if the parent rebuilds.
          _currentThreshold ??= userPreferences.anomalyDeviationThreshold;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SettingRow(
                label: l10n.settingsPreferencesMeasurementUnit,
                control: AppSegmentedControl<MeasurementUnit>(
                  selectedValue: userPreferences.measurementUnit,
                  onSelectionChanged: (final value) {
                    ref
                        .read(userPreferencesProvider.notifier)
                        .setMeasurementUnit(value);
                  },
                  segments: [
                    SegmentOption(
                      value: MeasurementUnit.mm,
                      label: Text(l10n.unitMM),
                    ),
                    SegmentOption(
                      value: MeasurementUnit.inch,
                      label: Text(l10n.unitIn),
                    ),
                  ],
                ),
                controlWidth: 150,
              ),
              const SizedBox(height: 24),
              _SettingRow(
                label: l10n.settingsPreferencesHemisphere,
                control: AppSegmentedControl<Hemisphere>(
                  selectedValue: userPreferences.hemisphere,
                  onSelectionChanged: (final value) {
                    ref
                        .read(userPreferencesProvider.notifier)
                        .setHemisphere(value);
                  },
                  segments: [
                    SegmentOption(
                      value: Hemisphere.northern,
                      label: Text(l10n.hemisphereNorthern),
                    ),
                    SegmentOption(
                      value: Hemisphere.southern,
                      label: Text(l10n.hemisphereSouthern),
                    ),
                  ],
                ),
                controlWidth: 220,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.anomalyDeviationThresholdLabel,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.anomalyDeviationThresholdDescription,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 20,
                  ),
                  activeTrackColor: theme.colorScheme.secondary,
                  inactiveTrackColor: theme.colorScheme.secondary.withValues(
                    alpha: 0.3,
                  ),
                  thumbColor: theme.colorScheme.secondary,
                  overlayColor: theme.colorScheme.secondary.withValues(
                    alpha: 0.2,
                  ),
                ),
                child: Slider(
                  value: _currentThreshold!,
                  min: 10,
                  max: 200,
                  onChanged: (final value) {
                    setState(() => _currentThreshold = value);
                  },
                  onChangeEnd: (final value) {
                    ref
                        .read(userPreferencesProvider.notifier)
                        .setAnomalyDeviationThreshold(value);
                  },
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n.anomalyDeviationThresholdValue(
                        _currentThreshold!.toStringAsFixed(0),
                      ),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.secondary,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    required this.control,
    this.controlWidth,
  });

  final String label;
  final Widget control;
  final double? controlWidth;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Widget labelWidget = Text(label, style: theme.textTheme.titleMedium);

    return LayoutBuilder(
      builder: (final context, final constraints) {
        const double breakpoint = 400;

        if (constraints.maxWidth < breakpoint) {
          // Use a Column for narrow screens or large text settings.
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [labelWidget, const SizedBox(height: 12), control],
          );
        } else {
          // Use a Row for wider screens.
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: labelWidget),
              const SizedBox(width: 16),
              SizedBox(width: controlWidth, child: control),
            ],
          );
        }
      },
    );
  }
}
