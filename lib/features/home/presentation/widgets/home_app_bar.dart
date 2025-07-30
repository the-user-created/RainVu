import "package:flutter/material.dart";
import "package:rain_wise/flutter_flow/flutter_flow_theme.dart";
import "package:rain_wise/shared/widgets/buttons/app_icon_button.dart";

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    required this.onAddPressed,
    super.key,
  });

  final VoidCallback onAddPressed;

  @override
  Widget build(final BuildContext context) {
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);
    return AppBar(
      backgroundColor: theme.primaryBackground,
      automaticallyImplyLeading: false,
      title: Text(
        "RainWise",
        style: theme.headlineMedium,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: AppIconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: theme.secondary,
            ),
            iconSize: 36,
            onPressed: onAddPressed,
            tooltip: "Log Rainfall",
          ),
        ),
      ],
      centerTitle: false,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
