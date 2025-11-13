import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rainvu/app_constants.dart";
import "package:rainvu/core/application/filter_provider.dart";
import "package:rainvu/core/data/providers/data_providers.dart";
import "package:rainvu/l10n/app_localizations.dart";
import "package:rainvu/shared/domain/rain_gauge.dart";
import "package:rainvu/shared/widgets/forms/app_dropdown.dart";

class GaugeFilterDropdown extends ConsumerWidget {
  const GaugeFilterDropdown({super.key, this.value, this.onChanged});

  /// The currently selected gauge ID. If null, this widget will manage
  /// the state via the global [selectedGaugeFilterProvider].
  final String? value;

  /// Callback when a new gauge is selected. If null, the global
  /// [selectedGaugeFilterProvider] will be updated.
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<RainGauge>> gaugesAsync = ref.watch(
      allGaugesFutureProvider,
    );

    final String selectedValue =
        value ?? ref.watch(selectedGaugeFilterProvider);
    final void Function(String?) effectiveOnChanged =
        onChanged ??
        (final value) {
          if (value != null) {
            ref.read(selectedGaugeFilterProvider.notifier).setGauge(value);
          }
        };

    return gaugesAsync.when(
      data: (final gauges) {
        if (gauges.length <= 1) {
          // Don't show filter if there's only the default gauge
          return const SizedBox.shrink();
        }

        return AppDropdown<String>(
          value: selectedValue,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          icon: Icon(
            Icons.filter_list,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          onChanged: effectiveOnChanged,
          items: [
            DropdownMenuItem(
              value: allGaugesFilterId,
              child: Text(l10n.allGaugesFilter),
            ),
            ...gauges.map((final gauge) {
              final String displayName = gauge.id == AppConstants.defaultGaugeId
                  ? l10n.defaultGaugeName
                  : gauge.name;
              return DropdownMenuItem(
                value: gauge.id,
                child: Text(displayName),
              );
            }),
          ],
        );
      },
      loading: () => const SizedBox(height: 48), // Match dropdown height
      error: (final _, final _) => const Icon(Icons.error_outline),
    );
  }
}
