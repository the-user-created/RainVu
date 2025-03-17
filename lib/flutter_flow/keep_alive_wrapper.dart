import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class KeepAliveWidgetWrapper extends StatefulWidget {
  const KeepAliveWidgetWrapper({
    required this.builder,
    super.key,
  });

  final WidgetBuilder builder;

  @override
  State<KeepAliveWidgetWrapper> createState() => _KeepAliveWidgetWrapperState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<WidgetBuilder>.has("builder", builder));
  }
}

class _KeepAliveWidgetWrapperState extends State<KeepAliveWidgetWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return widget.builder(context);
  }
}
