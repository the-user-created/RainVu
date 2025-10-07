import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rain_wise/core/application/preferences_provider.dart";
import "package:rain_wise/l10n/app_localizations.dart";
import "package:rain_wise/shared/domain/seasons.dart";
import "package:rain_wise/shared/domain/user_preferences.dart";
import "package:rain_wise/shared/widgets/forms/app_segmented_control.dart";
import "package:rain_wise/shared/widgets/sheets/interactive_sheet.dart";

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
        error: (final err, final stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Error: $err"),
          ),
        ),
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
                control: SizedBox(
                  width: 150,
                  child: AppSegmentedControl<MeasurementUnit>(
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
                ),
              ),
              const SizedBox(height: 24),
              _SettingRow(
                label: l10n.settingsPreferencesHemisphere,
                control: SizedBox(
                  width: 220,
                  child: AppSegmentedControl<Hemisphere>(
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
                ),
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
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _currentThreshold!,
                      min: 10,
                      max: 200,
                      divisions: 19,
                      label: _currentThreshold!.round().toString(),
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
                  const SizedBox(width: 16),
                  Text(
                    l10n.anomalyDeviationThresholdValue(
                      _currentThreshold!.toStringAsFixed(0),
                    ),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.label, required this.control});

  final String label;
  final Widget control;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: theme.textTheme.titleMedium)),
        control,
      ],
    );
  }
}
