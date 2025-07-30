import "package:flutter/material.dart";

extension ListDivideExt<T extends Widget> on Iterable<T> {
  Iterable<MapEntry<int, Widget>> get enumerate => toList().asMap().entries;

  List<Widget> divide(final Widget t, {final bool Function(int)? filterFn}) =>
      isEmpty
          ? []
          : (enumerate
              .map(
                (final e) =>
                    [e.value, if (filterFn == null || filterFn(e.key)) t],
              )
              .expand((final i) => i)
              .toList()
            ..removeLast());

  List<Widget> around(final Widget t) => addToStart(t).addToEnd(t);

  List<Widget> addToStart(final Widget t) =>
      enumerate.map((final e) => e.value).toList()..insert(0, t);

  List<Widget> addToEnd(final Widget t) =>
      enumerate.map((final e) => e.value).toList()..add(t);

  List<Padding> paddingTopEach(final double val) =>
      map((final w) => Padding(padding: EdgeInsets.only(top: val), child: w))
          .toList();
}

extension ListUniqueExt<T> on Iterable<T> {
  List<T> unique(final dynamic Function(T) getKey) {
    final distinctSet = <dynamic>{};
    final distinctList = <T>[];
    for (final item in this) {
      if (distinctSet.add(getKey(item))) {
        distinctList.add(item);
      }
    }
    return distinctList;
  }
}
