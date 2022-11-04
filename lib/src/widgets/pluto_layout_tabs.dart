import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_layout/src/helper/resize_helper.dart';

import '../events/events.dart';

class _ItemsNotifier extends StateNotifier<List<PlutoLayoutTabItem>> {
  _ItemsNotifier(List<PlutoLayoutTabItem> items) : super(items);

  void setEnabled(Object id, bool flag, [bool disableOther = false]) {
    PlutoLayoutTabItem disableOrNot(PlutoLayoutTabItem item) {
      if (!disableOther) return item;
      return item.copyWith(enabled: false);
    }

    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(enabled: flag) else disableOrNot(item),
    ];
  }

  void toggleAll(bool flag) {
    state = [
      for (final item in state)
        if (item.enabled == flag) item else item.copyWith(enabled: flag),
    ];
  }
}

final _itemProvider =
    StateNotifierProvider<_ItemsNotifier, List<PlutoLayoutTabItem>>((ref) {
  return _ItemsNotifier([]);
});

/// You can configure the tab view by passing it as a child of [PlutoLayoutContainer].
///
/// {@macro pluto_layout_example}
class PlutoLayoutTabs extends ConsumerWidget {
  PlutoLayoutTabs({
    this.items = const [],
    this.mode = PlutoLayoutTabMode.showOne,
    this.tabViewSizeResolver,
    super.key,
  });

  /// Pass a list of [PlutoLayoutTabItem].
  ///
  /// ```dart
  /// PlutoLayoutTabItem(
  ///   id: 'Unique ID',
  ///   title: 'Tab Menu Title',
  ///   tabViewBuilder: (c) {
  ///     return Padding(
  ///       padding: EdgeInsets.all(15),
  ///       child: ListView(
  ///         children: const [
  ///           Text('Tab Menu contents'),
  ///           SizedBox(height: 15),
  ///           Text('Tab Menu contents'),
  ///           SizedBox(height: 10),
  ///           Text('Tab Menu contents'),
  ///         ],
  ///       ),
  ///     );
  ///   },
  /// ),
  /// ```
  final List<PlutoLayoutTabItem> items;

  /// {@template pluto_layout_tab_mode}
  /// [mode] determines the operation method of the tab menu.
  ///
  /// [PlutoLayoutTabMode.showOne] shows only one tab view of the menu selected from multiple menus.
  /// [PlutoLayoutTabMode.showSelected] shows the tab view of all selected menus in multiple menus.
  /// {@endtemplate}
  final PlutoLayoutTabMode mode;

  /// Set the size of the tab view.
  ///
  /// The size of the tab view is the width in case of left or right tab,
  /// Means the height if it's a top or bottom tab.
  ///
  /// If not set (default behavior), the width of the tab view is as follows.
  /// For left or right tab: width / 4
  /// For top or bottom tabs: height / 6
  ///
  /// Implemented classes.
  /// [PlutoLayoutTabViewSizeFixed]
  /// {@macro pluto_layout_tab_view_size_fixed}
  ///
  /// [PlutoLayoutTabViewSizeConstrains]
  /// {@macro pluto_layout_tab_view_size_constrains}
  ///
  /// [PlutoLayoutTabViewSizeRatio]
  /// {@macro pluto_layout_tab_view_size_ratio}
  final PlutoLayoutTabViewSizeResolver? tabViewSizeResolver;

  final GlobalKey<_MenusState> _menuKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    final containerDirection = ref.read(layoutContainerDirectionProvider);

    List<Widget> children = [
      _Menus(direction: containerDirection, mode: mode, menuKey: _menuKey),
      _TabView(
        direction: containerDirection,
        tabViewSizeResolver: tabViewSizeResolver,
        menuKey: _menuKey,
      ),
    ];

    Widget container = containerDirection.isHorizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: containerDirection.isLeft
                ? children
                : children.reversed.toList(),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: containerDirection.isTop
                ? children
                : children.reversed.toList(),
          );

    return ProviderScope(
      overrides: [
        _itemProvider.overrideWith((ref) => _ItemsNotifier(items)),
      ],
      child: ColoredBox(
        color: theme.dialogBackgroundColor,
        child: container,
      ),
    );
  }
}

class _Menus extends ConsumerStatefulWidget {
  const _Menus({
    required this.direction,
    required this.mode,
    required this.menuKey,
  }) : super(key: const ValueKey('_Menus'));

  final PlutoLayoutContainerDirection direction;

  final PlutoLayoutTabMode mode;

  final GlobalKey<_MenusState> menuKey;

  @override
  ConsumerState<_Menus> createState() => _MenusState();
}

class _MenusState extends ConsumerState<_Menus> {
  late final StreamSubscription<PlutoLayoutEvent> _eventListener;

  @override
  void initState() {
    super.initState();

    final events = ref.read(layoutEventsProvider);

    _eventListener = events.listen(handleEvent);
  }

  @override
  void dispose() {
    _eventListener.cancel();

    super.dispose();
  }

  MainAxisAlignment getMenuAlignment(PlutoLayoutId id) {
    switch (id) {
      case PlutoLayoutId.top:
        return MainAxisAlignment.start;
      case PlutoLayoutId.left:
        return MainAxisAlignment.end;
      case PlutoLayoutId.right:
        return MainAxisAlignment.start;
      case PlutoLayoutId.bottom:
        return MainAxisAlignment.start;
      case PlutoLayoutId.body:
        return MainAxisAlignment.start;
    }
  }

  int getMenuRotate(PlutoLayoutId id) {
    switch (id) {
      case PlutoLayoutId.top:
        return 0;
      case PlutoLayoutId.left:
        return -45;
      case PlutoLayoutId.right:
        return 45;
      case PlutoLayoutId.bottom:
        return 0;
      case PlutoLayoutId.body:
        return 0;
    }
  }

  void handleEvent(PlutoLayoutEvent event) {
    // todo : refactor.
    if (event is PlutoToggleTabViewEvent &&
        event.containerDirection == widget.direction) {
      final item = ref
          .read(_itemProvider)
          .firstWhereOrNull((e) => e.id == event.tabItemId);

      if (item == null) return;

      toggleTab(ref, item, !item.enabled);
    } else if (event is PlutoRotateTabViewEvent &&
        event.containerDirection == widget.direction) {
      final items = ref.read(_itemProvider);

      if (items.isEmpty) return;

      if (items.length == 1) {
        toggleTab(ref, items.first, !items.first.enabled);
        return;
      }

      final enabledIndex = items.indexWhere((e) => e.enabled);

      if (enabledIndex == -1) {
        toggleTab(ref, items.first, true);
        return;
      }

      if (enabledIndex == items.length - 1) {
        toggleTab(ref, items.last, false);
        return;
      }

      toggleTab(ref, items[enabledIndex + 1], true, showOne: true);
    } else if (event is PlutoHideAllTabViewEvent) {
      ref.read(_itemProvider.notifier).toggleAll(false);

      if (event.afterFocusToBody) {
        ref.read(layoutFocusedIdProvider.notifier).state = PlutoLayoutId.body;
      }
    }
  }

  void toggleTab(
    WidgetRef ref,
    PlutoLayoutTabItem item,
    bool flag, {
    bool? showOne,
  }) {
    final isShowOne = showOne ?? widget.mode.isShowOne;

    final layoutId = ref.read(layoutIdProvider);

    ref.read(layoutFocusedIdProvider.notifier).state = layoutId;

    final layoutData = ref.read(layoutDataProvider);

    ref.read(_itemProvider.notifier).setEnabled(item.id, flag, isShowOne);

    final items = ref.read(_itemProvider).where((e) => e.enabled);

    final maxSize = layoutData.getMaxTabItemViewSize(layoutId);

    PlutoLayoutTabItemSizeResolver._update(
      maxSize: maxSize,
      minSize: PlutoLayoutData.minTabSize,
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    final layoutId = ref.read(layoutIdProvider);

    final items = ref.watch(_itemProvider);

    return Align(
      key: widget.menuKey,
      alignment: widget.direction.isVertical
          ? Alignment.centerLeft
          : Alignment.topCenter,
      child: RotatedBox(
        quarterTurns: getMenuRotate(layoutId),
        child: SingleChildScrollView(
          reverse: widget.direction.isLeft,
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: getMenuAlignment(layoutId),
            children: (widget.direction.isLeft ? items.reversed : items)
                .map(
                  (e) => ToggleButton(
                    title: e.title,
                    icon: e.icon,
                    enabled: e.enabled,
                    changed: (flag) => toggleTab(ref, e, flag),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _TabView extends ConsumerStatefulWidget {
  const _TabView({
    required this.direction,
    required this.tabViewSizeResolver,
    required this.menuKey,
  }) : super(key: const ValueKey('_TabView'));

  final PlutoLayoutContainerDirection direction;

  final PlutoLayoutTabViewSizeResolver? tabViewSizeResolver;

  final GlobalKey<_MenusState> menuKey;

  @override
  ConsumerState<_TabView> createState() => _TabViewState();
}

class _TabViewState extends ConsumerState<_TabView> {
  late final StreamSubscription<PlutoLayoutEvent> _eventListener;

  final ValueNotifier<double?> tabSize = ValueNotifier(null);

  final ChangeNotifier itemResizeNotifier = ChangeNotifier();

  Size? get menuSize {
    final c = widget.menuKey.currentContext;
    if (c == null || widget.menuKey.currentState?.mounted != true) return null;
    return widget.menuKey.currentContext?.size;
  }

  double get menuSizeByDirection {
    final safeMenuSize = menuSize ??
        const Size(PlutoLayoutData.minTabSize, PlutoLayoutData.minTabSize);
    switch (direction) {
      case PlutoLayoutContainerDirection.top:
      case PlutoLayoutContainerDirection.bottom:
        return safeMenuSize.height;
      case PlutoLayoutContainerDirection.left:
      case PlutoLayoutContainerDirection.right:
        return safeMenuSize.width;
    }
  }

  Size get maxSize => MediaQuery.of(context).size;

  PlutoLayoutContainerDirection get direction => widget.direction;

  ResizeIndicatorPosition get tabViewResizePosition {
    switch (direction) {
      case PlutoLayoutContainerDirection.top:
        return ResizeIndicatorPosition.bottom;
      case PlutoLayoutContainerDirection.left:
        return ResizeIndicatorPosition.right;
      case PlutoLayoutContainerDirection.right:
        return ResizeIndicatorPosition.left;
      case PlutoLayoutContainerDirection.bottom:
        return ResizeIndicatorPosition.top;
    }
  }

  ResizeIndicatorPosition get tabItemResizePosition {
    switch (direction) {
      case PlutoLayoutContainerDirection.top:
        return ResizeIndicatorPosition.right;
      case PlutoLayoutContainerDirection.left:
        return ResizeIndicatorPosition.bottom;
      case PlutoLayoutContainerDirection.right:
        return ResizeIndicatorPosition.bottom;
      case PlutoLayoutContainerDirection.bottom:
        return ResizeIndicatorPosition.right;
    }
  }

  @override
  void initState() {
    super.initState();

    final events = ref.read(layoutEventsProvider);

    _eventListener = events.listen(handleEvent);
  }

  @override
  void dispose() {
    tabSize.dispose();

    itemResizeNotifier.dispose();

    _eventListener.cancel();

    super.dispose();
  }

  bool isEnabledItem(e) => e.enabled && e.tabViewBuilder != null;

  PlutoLayoutContainerDirection? getFocusedContainerDirection() {
    final focusedId = ref.read(layoutFocusedIdProvider);

    switch (focusedId) {
      case PlutoLayoutId.top:
        return PlutoLayoutContainerDirection.top;
      case PlutoLayoutId.left:
        return PlutoLayoutContainerDirection.left;
      case PlutoLayoutId.right:
        return PlutoLayoutContainerDirection.right;
      case PlutoLayoutId.bottom:
        return PlutoLayoutContainerDirection.bottom;
      default:
        return null;
    }
  }

  void handleEvent(PlutoLayoutEvent event) {
    if (event is PlutoRelayoutEvent) {
      final layoutId = ref.read(layoutIdProvider);

      resizeTabView(layoutId, Offset.zero);
    } else if (event is PlutoLayoutHasInDecreaseTabViewEvent) {
      // todo : Refactor.
      final tabSizeEvent = event as PlutoLayoutHasInDecreaseTabViewEvent;

      final containerDirection =
          tabSizeEvent.containerDirection ?? getFocusedContainerDirection();

      if (containerDirection != direction) return;

      final hasEnabledItem =
          ref.read(_itemProvider).firstWhereOrNull(isEnabledItem) != null;

      if (!hasEnabledItem) return;

      final layoutId = ref.read(layoutIdProvider);

      final bool isIncreased = event is PlutoIncreaseTabViewEvent;

      final reverse =
          !tabSizeEvent.reverseByDirection && !direction.isIncreasedOffset;

      final double size = isIncreased
          ? reverse
              ? -tabSizeEvent.size
              : tabSizeEvent.size
          : reverse
              ? tabSizeEvent.size
              : -tabSizeEvent.size;

      resizeTabView(
        layoutId,
        Offset(
          widget.direction.isHorizontal ? size : 0,
          widget.direction.isHorizontal ? 0 : size,
        ),
      );
    }
  }

  void resizeTabView(PlutoLayoutId id, Offset offset) {
    ref.read(layoutFocusedIdProvider.notifier).state = id;
    final menuSize = menuSizeByDirection;
    final layoutData = ref.read(layoutDataProvider);
    final maximumSize = layoutData.getTabViewConstrains(id) - (menuSize * 2);

    final constrains = ref.read(layoutDataProvider);
    final defaultSize = direction.isHorizontal
        ? constrains.defaultTabWidth
        : constrains.defaultTabHeight;
    double size = 0;
    double old = tabSize.value ?? defaultSize;

    switch (direction) {
      case PlutoLayoutContainerDirection.top:
        size = old + offset.dy;
        break;
      case PlutoLayoutContainerDirection.left:
        size = old + offset.dx;
        break;
      case PlutoLayoutContainerDirection.right:
        size = old - offset.dx;
        break;
      case PlutoLayoutContainerDirection.bottom:
        size = old - offset.dy;
        break;
    }

    if (widget.tabViewSizeResolver != null) {
      size = widget.tabViewSizeResolver!.resolve(
        maxSize: maximumSize,
        sizeToSet: tabSize.value == null ? null : size,
        defaultSize: defaultSize,
      );
    }

    if (size <= menuSize) return;

    if (size >= maximumSize) {
      size = maximumSize;
    }

    tabSize.value = size;
  }

  void resizeTabItem(PlutoLayoutTabItem item, Offset offset) {
    final layoutData = ref.read(layoutDataProvider);

    final items = ref.read(_itemProvider).where(isEnabledItem).toList();

    final maxSize = direction.isHorizontal
        ? layoutData.leftSize.height
        : layoutData.topSize.width;

    final defaultSize = maxSize / items.length;

    for (final item in items) {
      if (item._size == 0) item._size = defaultSize;
    }

    final resizing = ResizeHelper.items(
      offset: direction.isHorizontal ? offset.dy : offset.dx,
      items: items,
      isMainItem: (i) => i.id == item.id,
      getItemSize: (i) => i._size,
      getItemMinSize: (i) => PlutoLayoutData.minTabSize,
      setItemSize: (i, size) => i._size = size,
      mode: ResizeMode.pushAndPull,
    );

    resizing.update();

    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    itemResizeNotifier.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final enabledItems = ref.watch(_itemProvider).where(isEnabledItem);

    if (enabledItems.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    final layoutId = ref.read(layoutIdProvider);

    final layoutData = ref.read(layoutDataProvider);

    final border = BorderSide(color: theme.dividerColor);

    final children = <Widget>[];

    int length = enabledItems.length;
    for (int i = 0; i < length; i += 1) {
      final item = enabledItems.elementAt(i);
      Widget child = item.tabViewBuilder!(context);
      if (i < length - 1) {
        child = ResizeIndicator<PlutoLayoutTabItem>(
          item: item,
          onResize: resizeTabItem,
          position: tabItemResizePosition,
          child: child,
        );
      }
      children.add(LayoutId(id: item.id, child: child));
    }

    return CustomSingleChildLayout(
      delegate: _TabViewDelegate(
        layoutId,
        direction,
        tabSize,
        menuSizeByDirection,
        widget.tabViewSizeResolver,
        layoutData,
      ),
      child: ResizeIndicator<PlutoLayoutId>(
        item: layoutId,
        position: tabViewResizePosition,
        onResize: resizeTabView,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: direction.isTop ? border : BorderSide.none,
              left: direction.isLeft ? border : BorderSide.none,
              right: direction.isRight ? border : BorderSide.none,
              bottom: direction.isBottom ? border : BorderSide.none,
            ),
          ),
          child: CustomMultiChildLayout(
            delegate: _TabItemsDelegate(
              direction,
              layoutData,
              enabledItems,
              itemResizeNotifier,
            ),
            children: children,
          ),
        ),
      ),
    );
  }
}

class _TabViewDelegate extends SingleChildLayoutDelegate {
  _TabViewDelegate(
    this.layoutId,
    this.direction,
    this.tabSize,
    this.menuSize,
    this.tabViewSizeResolver,
    this.layoutData,
  ) : super(relayout: tabSize);

  final PlutoLayoutId layoutId;

  final PlutoLayoutContainerDirection direction;

  final ValueNotifier<double?> tabSize;

  final double menuSize;

  final PlutoLayoutTabViewSizeResolver? tabViewSizeResolver;

  final PlutoLayoutData layoutData;

  double get defaultHeight => layoutData.defaultTabHeight;

  double get defaultWidth => layoutData.defaultTabWidth;

  double get safeHeight {
    final maxSize = layoutData.getTabViewConstrains(layoutId) - (menuSize * 2);

    if (tabSize.value == null) {
      if (tabViewSizeResolver == null) return defaultHeight;

      return tabViewSizeResolver!.resolve(
        maxSize: maxSize,
        sizeToSet: null,
        defaultSize: defaultHeight,
      );
    }

    if (tabSize.value! >= maxSize) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        tabSize.value = maxSize;
      });
      return maxSize;
    }

    return tabSize.value!;
  }

  double get safeWidth {
    final maxSize = layoutData.getTabViewConstrains(layoutId) - (menuSize * 2);

    if (tabSize.value == null) {
      if (tabViewSizeResolver == null) return defaultWidth;

      return tabViewSizeResolver!.resolve(
        maxSize: maxSize,
        sizeToSet: null,
        defaultSize: defaultWidth,
      );
    }

    if (tabSize.value! >= maxSize) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        tabSize.value = maxSize;
      });
      return maxSize;
    }

    return tabSize.value!;
  }

  @override
  Size getSize(BoxConstraints constraints) {
    switch (direction) {
      case PlutoLayoutContainerDirection.top:
      case PlutoLayoutContainerDirection.bottom:
        return Size(constraints.maxWidth, safeHeight);
      case PlutoLayoutContainerDirection.left:
      case PlutoLayoutContainerDirection.right:
        return Size(safeWidth, constraints.maxHeight);
    }
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset.zero;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    switch (direction) {
      case PlutoLayoutContainerDirection.top:
      case PlutoLayoutContainerDirection.bottom:
        return constraints.tighten(
          width: constraints.maxWidth,
          height: safeHeight,
        );
      case PlutoLayoutContainerDirection.left:
      case PlutoLayoutContainerDirection.right:
        return constraints.tighten(
          width: safeWidth,
          height: constraints.maxHeight,
        );
    }
  }

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) {
    return true;
  }
}

class _TabItemsDelegate extends MultiChildLayoutDelegate {
  _TabItemsDelegate(
    this.direction,
    this.layoutData,
    this.items,
    Listenable notifier,
  ) : super(relayout: notifier);

  final PlutoLayoutContainerDirection direction;

  final PlutoLayoutData layoutData;

  final Iterable<PlutoLayoutTabItem> items;

  Size _previousSize = Size.zero;

  @override
  void performLayout(Size size) {
    _reset(size);

    final length = items.length;
    final double defaultSize = max(
      direction.isHorizontal ? size.height / length : size.width / length,
      0,
    );
    int count = 0;
    double position = 0;
    double remaining = direction.isHorizontal ? size.height : size.width;
    isLast(int c) => c + 1 == length;

    for (final item in items) {
      if (item._size.isNaN) item._size = defaultSize;
      if (isLast(count)) item._size = max(remaining, 0);

      final constrain = direction.isHorizontal
          ? BoxConstraints.tight(
              Size(
                max(size.width, 0),
                max(item._size == 0 ? defaultSize : item._size, 0),
              ),
            )
          : BoxConstraints.tight(
              Size(
                max(item._size == 0 ? defaultSize : item._size, 0),
                max(size.height, 0),
              ),
            );

      if (hasChild(item.id)) {
        final s = layoutChild(item.id, constrain);
        item._size = direction.isHorizontal ? s.height : s.width;
        positionChild(
          item.id,
          Offset(
            direction.isHorizontal ? 0 : position,
            direction.isHorizontal ? position : 0,
          ),
        );
        position += direction.isHorizontal ? s.height : s.width;
        remaining -= item._size;
      }
    }

    _previousSize = size;
  }

  void _reset(Size size) {
    if (_previousSize == Size.zero) return;
    if (_previousSize == size) return;

    final maxSize = direction.isHorizontal ? size.height : size.width;

    PlutoLayoutTabItemSizeResolver._update(
      maxSize: maxSize,
      minSize: PlutoLayoutData.minTabSize,
      items: items,
    );
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}

/// Class to pass to [PlutoLayoutTabs.items].
///
/// Set the information constituting the tab menu.
///
/// {@template pluto_layout_tab_item_id}
/// [id] must pass a unique value. (Usually, if the title is unique, it will be delivered.)
/// {@endtemplate}
///
/// {@template pluto_layout_tab_item_title}
/// [title] is the title of the menu to be displayed.
/// {@endtemplate}
///
/// {@template pluto_layout_tab_item_icon}
/// [icon] is the icon to display before the menu title.
/// {@endtemplate}
///
/// {@template pluto_layout_tab_item_tabViewBuilder}
/// [tabViewBuilder] is a callback function that returns a tab view widget
/// that will be displayed when the menu is tapped.
/// Just pass a function that returns [Widget].
///
/// ```dart
/// tabViewBuilder: (c) {
///   return Padding(
///     padding: EdgeInsets.all(15),
///     child: ListView(
///       children: const [
///         Text('Example contents'),
///         SizedBox(height: 15),
///         Text('Example contents),
///         SizedBox(height: 10),
///         Text('Example contents),
///       ],
///     ),
///   );
/// },
/// ```
/// {@endtemplate}
class PlutoLayoutTabItem {
  PlutoLayoutTabItem({
    required this.id,
    required this.title,
    this.icon,
    this.tabViewBuilder,
    this.sizeResolver = const PlutoLayoutTabItemSizeFlexible(),
    this.enabled = false,
  });

  PlutoLayoutTabItem._({
    required this.id,
    required this.title,
    this.icon,
    this.tabViewBuilder,
    this.sizeResolver = const PlutoLayoutTabItemSizeFlexible(),
    this.enabled = false,
    double? size,
  }) : _size = size ?? 0;

  /// {@macro pluto_layout_tab_item_id}
  final Object id;

  /// {@macro pluto_layout_tab_item_title}
  final String title;

  /// {@macro pluto_layout_tab_item_icon}
  final Widget? icon;

  /// {@macro pluto_layout_tab_item_tabViewBuilder}
  final Widget Function(BuildContext context)? tabViewBuilder;

  /// {@macro pluto_layout_tab_view_size_resolver}
  final PlutoLayoutTabItemSizeResolver sizeResolver;

  /// The open and closed state of the tab view.
  final bool enabled;

  double _size = 0;

  PlutoLayoutTabItem copyWith({
    Object? id,
    String? title,
    Widget? icon,
    Widget Function(BuildContext context)? tabViewBuilder,
    PlutoLayoutTabItemSizeResolver? sizeResolver,
    bool? enabled,
    double? size,
  }) {
    return PlutoLayoutTabItem._(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      tabViewBuilder: tabViewBuilder ?? this.tabViewBuilder,
      sizeResolver: sizeResolver ?? this.sizeResolver,
      enabled: enabled ?? this.enabled,
      size: size ?? _size,
    );
  }
}

/// {@template pluto_layout_tab_view_size_resolver}
/// Abstract class for setting the size of the tab view.
///
/// Implement the [resolve] method that receives the total width,
/// the size to set, and the default size and returns the width of the tab view.
///
/// Implemented classes.
/// [PlutoLayoutTabViewSizeFixed]
/// {@macro pluto_layout_tab_view_size_fixed}
///
/// [PlutoLayoutTabViewSizeConstrains]
/// {@macro pluto_layout_tab_view_size_constrains}
///
/// [PlutoLayoutTabViewSizeRatio]
/// {@macro pluto_layout_tab_view_size_ratio}
/// {@endtemplate}
abstract class PlutoLayoutTabViewSizeResolver {
  const PlutoLayoutTabViewSizeResolver();

  double resolve({
    required double maxSize,
    required double? sizeToSet,
    required double defaultSize,
  });
}

/// {@template pluto_layout_tab_view_size_fixed}
/// Set the tab view to a fixed size.
///
/// After setting, the size cannot be changed.
/// However, if the parent's size is smaller than the set size,
/// the size is adjusted to fit the screen size.
/// {@endtemplate}
class PlutoLayoutTabViewSizeFixed extends PlutoLayoutTabViewSizeResolver {
  const PlutoLayoutTabViewSizeFixed(this._size)
      : assert(_size > 0, 'Size must be greater than 0.');

  final double _size;

  @override
  double resolve({
    required double maxSize,
    required double? sizeToSet,
    required double defaultSize,
  }) =>
      _size;
}

/// {@template pluto_layout_tab_view_size_constrains}
/// You can limit the size of the tab view to the minimum and maximum range.
/// You can also set the initial size.
///
/// At least one of [minSize], [maxSize], and [initialSize] must be set.
/// {@endtemplate}
class PlutoLayoutTabViewSizeConstrains extends PlutoLayoutTabViewSizeResolver {
  const PlutoLayoutTabViewSizeConstrains({
    double? minSize,
    double? maxSize,
    double? initialSize,
  })  : assert(
          minSize == null && maxSize == null && initialSize == null
              ? false
              : true,
          'At least one of minSize, maxSize, and initialSize must be set.',
        ),
        assert(
          minSize == null
              ? true
              : maxSize == null
                  ? true
                  : minSize <= maxSize,
          'MinSize must be less than or equal to maxSize.',
        ),
        assert(
          initialSize == null ||
              ((minSize == null ? true : initialSize >= minSize) &&
                  (maxSize == null ? true : initialSize <= maxSize)),
          'If initialSize is not null, '
          'initialSize must be within the range of minSize and maxSize.',
        ),
        _minSize = minSize,
        _maxSize = maxSize,
        _initialSize = initialSize;

  final double? _minSize;

  final double? _maxSize;

  final double? _initialSize;

  @override
  double resolve({
    required double maxSize,
    required double? sizeToSet,
    required double defaultSize,
  }) {
    sizeToSet ??= _initialSize ?? defaultSize;
    if (_minSize != null && sizeToSet < _minSize!) return _minSize!;
    if (_maxSize != null && sizeToSet > _maxSize!) return _maxSize!;
    return sizeToSet;
  }
}

/// {@template pluto_layout_tab_view_size_ratio}
/// Set the size of the tab view according to the ratio of the total size.
///
/// After setting, the size cannot be changed.
/// However, if the parent's size is smaller than the set size,
/// the size is adjusted to fit the screen size.
/// {@endtemplate}
class PlutoLayoutTabViewSizeRatio extends PlutoLayoutTabViewSizeResolver {
  const PlutoLayoutTabViewSizeRatio(this._ratio)
      : assert(
          0 <= _ratio && _ratio <= 1,
          'The ratio value must be in the range 0 and 1.',
        );

  final double _ratio;

  @override
  double resolve({
    required double maxSize,
    required double? sizeToSet,
    required double defaultSize,
  }) =>
      maxSize * _ratio;
}

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

    if (!narrowing &&
        groupByResolverType.containsKey(PlutoLayoutTabItemSizeInitial)) {
      for (final item in groupByResolverType[PlutoLayoutTabItemSizeInitial]!) {
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

/// {@macro pluto_layout_tab_mode}
enum PlutoLayoutTabMode {
  showOne,
  showSelected;

  bool get isShowOne => this == PlutoLayoutTabMode.showOne;
  bool get isShowSelected => this == PlutoLayoutTabMode.showSelected;
}
