part of pluto_layout_tabs;

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
      return _handleRelayoutEvent();
    }

    if (event is PlutoLayoutHasInDecreaseTabViewEvent) {
      return _handleInDecreaseTabViewEvent(
        event as PlutoLayoutHasInDecreaseTabViewEvent,
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

    final items = ref.read(_itemsProvider).where(isEnabledItem).toList();

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

  void _handleRelayoutEvent() {
    resizeTabView(ref.read(layoutIdProvider), Offset.zero);
  }

  void _handleInDecreaseTabViewEvent(
    PlutoLayoutHasInDecreaseTabViewEvent event,
  ) {
    final containerDirection =
        event.containerDirection ?? getFocusedContainerDirection();

    if (containerDirection != direction) return;

    final hasEnabledItem =
        ref.read(_itemsProvider).firstWhereOrNull(isEnabledItem) != null;

    if (!hasEnabledItem) return;

    final layoutId = ref.read(layoutIdProvider);

    final bool isIncreased = event is PlutoIncreaseTabViewEvent;

    final reverse = !event.reverseByDirection && !direction.isIncreasedOffset;

    final double size = isIncreased
        ? reverse
            ? -event.size
            : event.size
        : reverse
            ? event.size
            : -event.size;

    resizeTabView(
      layoutId,
      Offset(
        widget.direction.isHorizontal ? size : 0,
        widget.direction.isHorizontal ? 0 : size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final enabledItems = ref.watch(_itemsProvider).where(isEnabledItem);

    if (enabledItems.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    final layoutId = ref.read(layoutIdProvider);

    final layoutData = ref.read(layoutDataProvider);

    final border = BorderSide(color: theme.dividerColor);

    final int length = enabledItems.length;

    Widget resizeOrNot(int index, PlutoLayoutTabItem item) {
      Widget child = item.tabViewBuilder!(context);

      if (index < length - 1) {
        child = ResizeIndicator<PlutoLayoutTabItem>(
          item: item,
          onResize: resizeTabItem,
          position: tabItemResizePosition,
          child: child,
        );
      }

      return LayoutId(id: item.id, child: child);
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
            children: [
              for (int i = 0; i < length; i += 1)
                resizeOrNot(i, enabledItems.elementAt(i)),
            ],
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
