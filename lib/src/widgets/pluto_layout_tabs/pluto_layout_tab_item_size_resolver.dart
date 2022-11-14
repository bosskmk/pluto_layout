part of pluto_layout_tabs;

/// {@template pluto_layout_tab_item_size_resolver}
/// Abstract class for setting individual tabview sizes of tab items.
///
/// Implemented classes.
/// [PlutoLayoutTabItemSizeFlexible]
/// {@macro pluto_layout_tab_item_size_flexible}
///
/// [PlutoLayoutTabItemSizeInitial]
/// {@macro pluto_layout_tab_item_size_initial}
/// {@endtemplate}
abstract class PlutoLayoutTabItemSizeResolver {
  double resolve({
    required double maxSize,
    required double minSize,
  });

  static void _update({
    required double maxSize,
    required double minSize,
    required Iterable<PlutoLayoutTabItem> items,
  }) {
    if (items.isEmpty) return;

    final groupByResolverType = items.groupListsBy(
      (e) => e.sizeResolver.runtimeType,
    );

    final double minimumMaxSize = items.length * minSize;

    int countSizedItem = 0;
    double remaining = maxSize;
    double remainingMinimum = minimumMaxSize;
    bool narrowing = maxSize <= minimumMaxSize;

    if (groupByResolverType.containsKey(PlutoLayoutTabItemSizeInitial)) {
      if (!narrowing) {
        for (final item
            in groupByResolverType[PlutoLayoutTabItemSizeInitial]!) {
          item._size = min(
            item.sizeResolver.resolve(maxSize: maxSize, minSize: minSize),
            remaining,
          );

          ++countSizedItem;
          remaining -= item._size;
          remainingMinimum -= minSize;

          if (remaining <= remainingMinimum) {
            item._size -= remainingMinimum;
            narrowing = true;
            break;
          }
        }
      }

      groupByResolverType.remove(PlutoLayoutTabItemSizeInitial);
    }

    if (groupByResolverType.isEmpty) return;

    assert(groupByResolverType[PlutoLayoutTabItemSizeFlexible] != null);
    assert(groupByResolverType.length == 1);

    final flexibleItems = groupByResolverType[PlutoLayoutTabItemSizeFlexible]!;

    final sizing = narrowing
        ? AutoSizeHelper.items(
            maxSize: remaining,
            length: items.length - countSizedItem,
            itemMinSize: PlutoLayoutData.minTabSize,
            mode: AutoSizeMode.equal,
          )
        : AutoSizeHelper.items(
            maxSize: remaining,
            length: items.length - countSizedItem,
            itemMinSize: PlutoLayoutData.minTabSize,
            mode: AutoSizeMode.scale,
            scale: remaining /
                flexibleItems.fold(
                    0,
                    (p, e) =>
                        p +
                        e.sizeResolver.resolve(
                          maxSize: maxSize,
                          minSize: minSize,
                        )),
          );

    setSize(e) => e._size = sizing.getItemSize(e.sizeResolver.resolve(
          maxSize: maxSize,
          minSize: minSize,
        ));

    flexibleItems.forEach(setSize);
  }
}

/// {@template pluto_layout_tab_item_size_flexible}
/// Set the size of each tab view according to the number of other activated tab views.
///
/// You can pass a double value, otherwise it will be set to 1.
/// Double values must be between 0 and 1.
///
/// Assuming that there are two active tab views,
/// if each double value is equal to 1, the size is set in a ratio of 1:1.
/// {@endtemplate}
class PlutoLayoutTabItemSizeFlexible implements PlutoLayoutTabItemSizeResolver {
  const PlutoLayoutTabItemSizeFlexible([double? flex])
      : assert(
          flex == null || (0 <= flex && flex <= 1),
          'The flex value must be in the range 0 and 1.',
        ),
        _flex = flex ?? 1;

  final double _flex;

  @override
  double resolve({
    required double maxSize,
    required double minSize,
  }) {
    return _flex;
  }
}

/// {@template pluto_layout_tab_item_size_initial}
/// Set the initial size of the tab view.
///
/// Applied when the tab view is activated or the size of the parent widget is changed.
/// {@endtemplate}
class PlutoLayoutTabItemSizeInitial implements PlutoLayoutTabItemSizeResolver {
  const PlutoLayoutTabItemSizeInitial(this._size)
      : assert(_size > 0, 'Size must be greater than 0.');

  final double _size;

  @override
  double resolve({
    required double maxSize,
    required double minSize,
  }) {
    return _size;
  }
}
