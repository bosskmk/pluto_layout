import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_layout/src/helper/resize_helper.dart';

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
/// /// {@macro pluto_layout_example}
class PlutoLayoutTabs extends ConsumerWidget {
  PlutoLayoutTabs({
    this.items = const [],
    this.mode = PlutoLayoutTabMode.showOne,
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

  final GlobalKey<_MenusState> _menuKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    final containerDirection = ref.read(layoutContainerDirectionProvider);

    List<Widget> children = [
      _Menus(direction: containerDirection, mode: mode, menuKey: _menuKey),
      _TabView(direction: containerDirection, menuKey: _menuKey),
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
        _itemProvider.overrideWithProvider(
          StateNotifierProvider<_ItemsNotifier, List<PlutoLayoutTabItem>>(
              (ref) {
            return _ItemsNotifier(items);
          }),
        ),
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
  });

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

    final sizing = AutoSizeHelper.items(
      maxSize: maxSize,
      length: items.length,
      itemMinSize: PlutoLayoutData.minTabSize,
      mode: AutoSizeMode.equal,
    );

    setSize(e) => e.size = sizing.getItemSize(e.size);
    items.forEach(setSize);
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
  const _TabView({required this.direction, required this.menuKey});

  final PlutoLayoutContainerDirection direction;

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
    if (event is PlutoLayoutHasInDecreaseTabViewEvent) {
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

    final constrains = ref.read(layoutDataProvider);
    double size = 0;
    double old = tabSize.value ??
        (direction.isHorizontal
            ? constrains.defaultTabWidth
            : constrains.defaultTabHeight);

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

    final menuSize = menuSizeByDirection;

    if (size <= menuSize) return;
    final layoutData = ref.read(layoutDataProvider);
    final maximumSize = layoutData.getTabViewConstrains(id) - (menuSize * 2);
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
      if (item.size == 0) item.size = defaultSize;
    }

    final resizing = ResizeHelper.items(
      offset: direction.isHorizontal ? offset.dy : offset.dx,
      items: items,
      isMainItem: (i) => i.id == item.id,
      getItemSize: (i) => i.size,
      getItemMinSize: (i) => PlutoLayoutData.minTabSize,
      setItemSize: (i, size) => i.size = size,
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
    this.layoutData,
  ) : super(relayout: tabSize);

  final PlutoLayoutId layoutId;

  final PlutoLayoutContainerDirection direction;

  final ValueNotifier<double?> tabSize;

  final double menuSize;

  final PlutoLayoutData layoutData;

  double get defaultHeight => layoutData.defaultTabHeight;

  double get defaultWidth => layoutData.defaultTabWidth;

  double get safeHeight {
    if (tabSize.value == null) return defaultHeight;

    final maxSize = layoutData.getTabViewConstrains(layoutId) - (menuSize * 2);
    if (tabSize.value! >= maxSize) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        tabSize.value = maxSize;
      });
      return maxSize;
    }

    return tabSize.value!;
  }

  double get safeWidth {
    if (tabSize.value == null) return defaultWidth;

    final maxSize = layoutData.getTabViewConstrains(layoutId) - (menuSize * 2);
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
      if (item.size.isNaN) item.size = defaultSize;
      if (isLast(count)) item.size = max(remaining, 0);

      final constrain = direction.isHorizontal
          ? BoxConstraints.tight(
              Size(
                max(size.width, 0),
                max(item.size == 0 ? defaultSize : item.size, 0),
              ),
            )
          : BoxConstraints.tight(
              Size(
                max(item.size == 0 ? defaultSize : item.size, 0),
                max(size.height, 0),
              ),
            );

      if (hasChild(item.id)) {
        final s = layoutChild(item.id, constrain);
        item.size = direction.isHorizontal ? s.height : s.width;
        positionChild(
          item.id,
          Offset(
            direction.isHorizontal ? 0 : position,
            direction.isHorizontal ? position : 0,
          ),
        );
        position += direction.isHorizontal ? s.height : s.width;
        remaining -= item.size;
      }
    }

    _previousSize = size;
  }

  void _reset(Size size) {
    if (_previousSize == Size.zero) return;
    if (_previousSize == size) return;

    final current = direction.isHorizontal ? size.height : size.width;
    final previous =
        direction.isHorizontal ? _previousSize.height : _previousSize.width;
    final diff = current - previous;

    for (final item in items) {
      item.size += (item.size / previous) * diff;
    }
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
    this.enabled = false,
    this.size = 0,
  });

  /// {@macro pluto_layout_tab_item_id}
  final Object id;

  /// {@macro pluto_layout_tab_item_title}
  final String title;

  /// {@macro pluto_layout_tab_item_icon}
  final Widget? icon;

  /// {@macro pluto_layout_tab_item_tabViewBuilder}
  final Widget Function(BuildContext context)? tabViewBuilder;

  final bool enabled;

  double size = 0;

  PlutoLayoutTabItem copyWith({
    Object? id,
    String? title,
    Widget? icon,
    Widget Function(BuildContext context)? tabViewBuilder,
    bool? enabled,
    double? size,
  }) {
    return PlutoLayoutTabItem(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      tabViewBuilder: tabViewBuilder ?? this.tabViewBuilder,
      enabled: enabled ?? this.enabled,
      size: size ?? this.size,
    );
  }
}

/// {@macro pluto_layout_tab_mode}
enum PlutoLayoutTabMode {
  showOne,
  showSelected;

  bool get isShowOne => this == PlutoLayoutTabMode.showOne;
  bool get isShowSelected => this == PlutoLayoutTabMode.showSelected;
}
