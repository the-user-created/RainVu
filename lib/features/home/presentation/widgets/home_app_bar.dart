import "package:flutter/material.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    required this.onAddPressed,
    super.key,
  });

  final VoidCallback onAddPressed;

  @override
  Widget build(final BuildContext context) => AppBar(
        automaticallyImplyLeading: false,
        title: const Text("RainWise"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AppIconButton(
              icon: const Icon(
                Icons.add_circle_outline,
              ),
              iconSize: 36,
              onPressed: onAddPressed,
              tooltip: "Log Rainfall",
            ),
          ),
        ],
        centerTitle: false,
      );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
