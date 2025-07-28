import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class MapView extends ConsumerWidget {
  const MapView({super.key});

  // TODO: Implement a real Map widget here.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) =>
      Image.network(
        "https://miro.medium.com/v2/resize:fit:1400/0*yPSQlTHRvLaIVBcG.jpg",
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
}
