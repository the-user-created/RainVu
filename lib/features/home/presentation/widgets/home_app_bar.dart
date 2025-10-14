import "package:flutter/material.dart";
import "package:rainly/l10n/app_localizations.dart";
import "package:rainly/shared/widgets/buttons/app_icon_button.dart";

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({required this.onAddPressed, super.key});

  final VoidCallback onAddPressed;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(l10n.appName, style: theme.textTheme.headlineLarge),
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: AppIconButton(
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 30,
            onPressed: onAddPressed,
            tooltip: l10n.logRainfallTooltip,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
