part of pluto_layout_tabs;

class _TabView extends ConsumerStatefulWidget {
  const _TabView({
    required this.direction,
    required this.mode,
    required this.tabViewSizeResolver,
  }) : super(key: const ValueKey('_TabView'));

  final PlutoLayoutContainerDirection direction;

  final PlutoLayoutTabMode mode;

  final PlutoLayoutTabViewSizeResolver? tabViewSizeResolver;

  @override
  ConsumerState<_TabView> createState() => _TabViewState();
}

class _TabViewState extends ConsumerState<_TabView> {
  late final StreamSubscription<PlutoLayoutEvent> _eventListener;

  final ValueNotifier<double?> tabSize = ValueNotifier(null);

  final ChangeNotifier itemResizeNotifier = ChangeNotifier();

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

  PlutoLayoutId? getFocusedLayoutId() {
    return ref.read(focusedLayoutIdProvider);
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
    ref.read(focusedLayoutIdProvider.notifier).state = id;
    final layoutData = ref.read(layoutDataProvider);
    final minimumSize = layoutData.getTabViewMinSize(id);
    final maximumSize = layoutData.getTabViewMaxSize(id);

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

    if (size < minimumSize) return;

    if (size > maximumSize) size = maximumSize;

    tabSize.value = size;
  }

  void resizeTabItem(PlutoLayoutTabItem item, Offset offset) {
    final layoutId = ref.read(layoutIdProvider);

    final layoutData = ref.read(layoutDataProvider);

    final items =
        ref.read(_itemsProvider).where(isEnabledItem).toList(growable: false);

    final maxSize = layoutData.getTabItemViewMaxSize(layoutId);

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
    final eventLayoutId = event.layoutId ?? getFocusedLayoutId();

    final layoutId = ref.read(layoutIdProvider);

    if (eventLayoutId != layoutId) return;

    final hasEnabledItem =
        ref.read(_itemsProvider).firstWhereOrNull(isEnabledItem) != null;

    if (!hasEnabledItem) return;

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

    Widget resizeTabItemOrNot(int index, PlutoLayoutTabItem item) {
      Widget child = _TabItemViewContainer(layoutId: layoutId, item: item);

      if (!widget.mode.isShowOneMode && index < length - 1) {
        child = ResizeIndicator<PlutoLayoutTabItem>(
          item: item,
          onResize: resizeTabItem,
          position: tabItemResizePosition,
          child: child,
        );
      }

      return LayoutId(id: item.id, child: child);
    }

    final child = DecoratedBox(
      position: DecorationPosition.foreground,
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
            resizeTabItemOrNot(i, enabledItems.elementAt(i)),
        ],
      ),
    );

    return CustomSingleChildLayout(
      delegate: _TabViewDelegate(
        layoutId,
        direction,
        tabSize,
        widget.tabViewSizeResolver,
        layoutData,
      ),
      child: widget.tabViewSizeResolver?.resizable == false
          ? child
          : ResizeIndicator<PlutoLayoutId>(
              item: layoutId,
              position: tabViewResizePosition,
              onResize: resizeTabView,
              child: child,
            ),
    );
  }
}

class _TabViewDelegate extends SingleChildLayoutDelegate {
  _TabViewDelegate(
    this.layoutId,
    this.direction,
    this.tabSize,
    this.tabViewSizeResolver,
    this.layoutData,
  ) : super(relayout: tabSize);

  final PlutoLayoutId layoutId;

  final PlutoLayoutContainerDirection direction;

  final ValueNotifier<double?> tabSize;

  final PlutoLayoutTabViewSizeResolver? tabViewSizeResolver;

  final PlutoLayoutData layoutData;

  double get safeHeight {
    return _getSafeSize(layoutData.defaultTabHeight);
  }

  double get safeWidth {
    return _getSafeSize(layoutData.defaultTabWidth);
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

  double _getSafeSize(double defaultSize) {
    final maxSize = layoutData.getTabViewMaxSize(layoutId);

    if (tabSize.value == null) {
      if (tabViewSizeResolver == null) return defaultSize;

      return tabViewSizeResolver!.resolve(
        maxSize: maxSize,
        sizeToSet: null,
        defaultSize: defaultSize,
      );
    }

    if (tabSize.value! > maxSize) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        tabSize.value = maxSize;
      });
      return maxSize;
    }

    return tabSize.value!;
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

class _TabItemViewContainer extends ConsumerWidget {
  const _TabItemViewContainer({
    required this.layoutId,
    required this.item,
  });

  final PlutoLayoutId layoutId;

  final PlutoLayoutTabItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        _TabItemFocusHelper.setFocus(
          ref: ref,
          layoutId: layoutId,
          itemId: item.id,
        );
      },
      child: item.tabViewBuilder!(context),
    );
  }
}
