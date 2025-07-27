import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:provider/provider.dart";

Widget wrapWithModel<T extends FlutterFlowModel>({
  required final T model,
  required final Widget child,
  required final VoidCallback updateCallback,
  final bool updateOnChange = false,
}) {
  // Set the component to optionally update the page on updates.
  model
    ..setOnUpdate(
      onUpdate: updateCallback,
      updateOnChange: updateOnChange,
    )
    // Models for components within a page will be disposed by the page's model,
    // so we don't want the component widget to dispose them until the page is
    // itself disposed.
    ..disposeOnWidgetDisposal = false;
  // Wrap in a Provider so that the model can be accessed by the component.
  return Provider<T>.value(
    value: model,
    child: child,
  );
}

T createModel<T extends FlutterFlowModel>(
  final BuildContext context,
  final T Function() defaultBuilder,
) {
  final dynamic model = context.read<T?>() ?? defaultBuilder()
    .._init(context);
  return model;
}

abstract class FlutterFlowModel<W extends Widget> {
  // Initialization methods
  bool _isInitialized = false;

  void initState(final BuildContext context);

  void _init(final BuildContext context) {
    if (!_isInitialized) {
      initState(context);
      _isInitialized = true;
    }
    if (context.widget is W) {
      _widget = context.widget as W;
    }
    _context = context;
  }

  // The widget associated with this model. This is useful for accessing the
  // parameters of the widget, for example.
  W? _widget;

  W? get widget => _widget;

  // The context associated with this model.
  BuildContext? _context;

  BuildContext? get context => _context;

  // Dispose methods
  // Whether to dispose this model when the corresponding widget is
  // disposed. By default this is true for pages and false for components,
  // as page/component models handle the disposal of their children.
  bool disposeOnWidgetDisposal = true;

  void dispose();

  void maybeDispose() {
    if (disposeOnWidgetDisposal) {
      dispose();
    }
    // Remove reference to widget for garbage collection purposes.
    _widget = null;
  }

  // Whether to update the containing page / component on updates.
  bool updateOnChange = false;

  // Function to call when the model receives an update.
  VoidCallback _updateCallback = () {};

  void onUpdate() => updateOnChange ? _updateCallback() : () {};

  FlutterFlowModel setOnUpdate({
    required final VoidCallback onUpdate,
    final bool updateOnChange = false,
  }) =>
      this
        .._updateCallback = onUpdate
        ..updateOnChange = updateOnChange;

  // Update the containing page when this model received an update.
  void updatePage(final VoidCallback callback) {
    callback();
    _updateCallback();
  }
}

class FlutterFlowDynamicModels<T extends FlutterFlowModel> {
  FlutterFlowDynamicModels(this.defaultBuilder);

  final T Function() defaultBuilder;
  final Map<String, T> _childrenModels = {};
  final Map<String, int> _childrenIndexes = {};
  Set<String>? _activeKeys;

  T getModel(final String uniqueKey, final int index) {
    _updateActiveKeys(uniqueKey);
    _childrenIndexes[uniqueKey] = index;
    return _childrenModels[uniqueKey] ??= defaultBuilder();
  }

  List<S> getValues<S>(final S? Function(T) getValue) => _childrenIndexes
      .entries
      // Sort keys by index.
      .sorted((final a, final b) => a.value.compareTo(b.value))
      .where((final e) => _childrenModels[e.key] != null)
      // Map each model to the desired value and return as list. In order
      // to preserve index order, rather than removing null values we provide
      // default values (for types with reasonable defaults).
      .map(
        (final e) =>
            getValue(_childrenModels[e.key]!) ?? _getDefaultValue<S>()!,
      )
      .toList();

  S? getValueAtIndex<S>(final int index, final S? Function(T) getValue) {
    final String? uniqueKey = _childrenIndexes.entries
        .firstWhereOrNull((final e) => e.value == index)
        ?.key;
    return getValueForKey(uniqueKey, getValue);
  }

  S? getValueForKey<S>(final String? uniqueKey, final S? Function(T) getValue) {
    final dynamic model = _childrenModels[uniqueKey];
    return model != null ? getValue(model) : null;
  }

  void dispose() {
    for (final T model in _childrenModels.values) {
      model.dispose();
    }
  }

  void _updateActiveKeys(final String uniqueKey) {
    final shouldResetActiveKeys = _activeKeys == null;
    _activeKeys ??= {};
    _activeKeys!.add(uniqueKey);

    if (shouldResetActiveKeys) {
      // Add a post-frame callback to remove and dispose of unused models after
      // we're done building, then reset `_activeKeys` to null so we know to do
      // this again next build.
      SchedulerBinding.instance.addPostFrameCallback((final _) {
        _childrenIndexes
            .removeWhere((final k, final _) => !_activeKeys!.contains(k));
        _childrenModels.keys
            .toSet()
            .difference(_activeKeys!)
            // Remove and dispose of unused models since they are  not being used
            // elsewhere and would not otherwise be disposed.
            .forEach((final k) => _childrenModels.remove(k)?.maybeDispose());
        _activeKeys = null;
      });
    }
  }
}

T? _getDefaultValue<T>() {
  if (T == int) {
    return 0 as T;
  } else if (T == double) {
    return 0.0 as T;
  } else if (T == String) {
    return "" as T;
  } else if (T == bool) {
    return false as T;
  }
  return null;
}

extension TextValidationExtensions on String? Function(BuildContext, String?)? {
  String? Function(String?)? asValidator(final BuildContext context) =>
      this != null ? (final val) => this!(context, val) : null;
}
