part of pluto_layout_tabs;

class _TabView extends ConsumerStatefulWidget {
  const _TabView({
    required this.direction,
    required this.mode,
    required this.tabViewSizeResolver,
    this.disableResize = false,
  }) : super(key: const ValueKey('_TabView'));

  final PlutoLayoutContainerDirection direction;

  final PlutoLayoutTabMode mode;

  final PlutoLayoutTabViewSizeResolver? tabViewSizeResolver;

  final bool disableResize;

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

  void handleEvent(PlutoLayoutEvent event) {
    if (event is PlutoRelayoutEvent) {
      _handleRelayoutEvent();
    } else if (event is PlutoLayoutInDecreaseTabViewEvent) {
      _handleInDecreaseTabViewEvent(
        event as PlutoLayoutInDecreaseTabViewEvent,
      );
    } else if (event is PlutoLayoutInDecreaseTabItemViewEvent) {
      _handleInDecreaseTabItemViewEvent(
        event as PlutoLayoutInDecreaseTabItemViewEvent,
      );
    }
  }

  void resizeTabView(PlutoLayoutId id, Offset offset, {bool setFocus = true}) {
    if (setFocus) {
      ref.read(focusedLayoutIdProvider.notifier).state = id;
    }

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

    final items = ref
        .read(_itemsProvider)
        .where(_TabsHelper.isEnabledTabView)
        .toList(growable: false);

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
    resizeTabView(ref.read(layoutIdProvider), Offset.zero, setFocus: false);
  }

  void _handleInDecreaseTabViewEvent(
    PlutoLayoutInDecreaseTabViewEvent event,
  ) {
    final eventLayoutId = event.layoutId ?? _TabsHelper.getFocusedLayoutId(ref);

    final layoutId = ref.read(layoutIdProvider);

    if (eventLayoutId != layoutId) return;

    final hasEnabledItem = ref
            .read(_itemsProvider)
            .firstWhereOrNull(_TabsHelper.isEnabledTabView) !=
        null;

    if (!hasEnabledItem) return;

    final double size = _getSizeByInDecrease(
      event.size,
      event is PlutoIncreaseTabViewEvent,
      event.reverseByDirection,
    );

    resizeTabView(
      layoutId,
      Offset(
        widget.direction.isHorizontal ? size : 0,
        widget.direction.isHorizontal ? 0 : size,
      ),
    );
  }

  void _handleInDecreaseTabItemViewEvent(
    PlutoLayoutInDecreaseTabItemViewEvent event,
  ) {
    final eventLayoutId = event.layoutId ?? _TabsHelper.getFocusedLayoutId(ref);

    final eventItemId = event.itemId ?? _TabsHelper.getFocusedItemId(ref);

    if (eventLayoutId == null || eventItemId == null) return;

    if (eventLayoutId != ref.read(layoutIdProvider)) return;

    final item = ref.read(_itemsProvider.notifier).findById(eventItemId);

    if (item == null) return;

    final double size = _getSizeByInDecrease(
      event.size,
      event is PlutoIncreaseTabItemViewEvent,
      event.reverseByDirection,
    );

    resizeTabItem(
      item,
      Offset(
        widget.direction.isHorizontal ? 0 : size,
        widget.direction.isHorizontal ? size : 0,
      ),
    );
  }

  double _getSizeByInDecrease(double size, bool increase, bool reverse) {
    final reverseByDirection = !reverse && !direction.isIncreasedOffset;

    return increase
        ? reverseByDirection
            ? -size
            : size
        : reverseByDirection
            ? size
            : -size;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final layoutId = ref.read(layoutIdProvider);

    final layoutData = ref.read(layoutDataProvider);

    final items = ref.watch(_itemsProvider).where(_TabsHelper.hasTabViewWidget);

    final enabledItems = items.where(_TabsHelper.isEnabled);

    final isEnabledEmpty = enabledItems.isEmpty;

    final lastEnabledItemId = enabledItems.lastOrNull;

    final border = BorderSide(color: theme.dividerColor);

    Widget resizeTabItemOrNot(PlutoLayoutTabItem item) {
      Widget child = _TabItemViewContainer(
        layoutId: layoutId,
        item: item,
        key: ValueKey('_TabItemViewContainer_${item.id}'),
      );

      if (!widget.disableResize &&
          !widget.mode.isShowOneMode &&
          item.enabled &&
          item.id != lastEnabledItemId) {
        child = ResizeIndicator<PlutoLayoutTabItem>(
          item: item,
          onResize: resizeTabItem,
          position: tabItemResizePosition,
          child: child,
        );
      }

      return LayoutId(id: item.id, child: child);
    }

    Widget child = DecoratedBox(
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
          items,
          itemResizeNotifier,
        ),
        children: [
          for (final item in items) resizeTabItemOrNot(item),
        ],
      ),
    );

    if (!widget.disableResize &&
        widget.tabViewSizeResolver?.resizable != false) {
      child = ResizeIndicator<PlutoLayoutId>(
        item: layoutId,
        position: tabViewResizePosition,
        onResize: resizeTabView,
        child: child,
      );
    }

    return CustomSingleChildLayout(
      delegate: _TabViewDelegate(
        layoutId,
        isEnabledEmpty,
        direction,
        tabSize,
        widget.tabViewSizeResolver,
        layoutData,
      ),
      child: child,
    );
  }
}

class _TabViewDelegate extends SingleChildLayoutDelegate {
  _TabViewDelegate(
    this.layoutId,
    this.isEnabledEmpty,
    this.direction,
    this.tabSize,
    this.tabViewSizeResolver,
    this.layoutData,
  ) : super(relayout: tabSize);

  final PlutoLayoutId layoutId;

  final bool isEnabledEmpty;

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
    if (isEnabledEmpty) return Size.zero;

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
    if (isEnabledEmpty) return BoxConstraints.tight(Size.zero);

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
    final enabledItems = items.where(_TabsHelper.isEnabled);
    final enabledLength = enabledItems.length;

    _reset(size, enabledItems);

    final double defaultSize = max(
      direction.isHorizontal
          ? size.height / enabledLength
          : size.width / enabledLength,
      0,
    );
    int enabledCount = 0;
    double position = 0;
    double remaining = direction.isHorizontal ? size.height : size.width;
    isLast(int c) => c + 1 == enabledLength;

    for (final item in items) {
      if (!item.enabled) {
        layoutChild(item.id, BoxConstraints.loose(size));
        continue;
      }

      if (item._size.isNaN) item._size = defaultSize;
      if (isLast(enabledCount)) item._size = max(remaining, 0);

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
        ++enabledCount;
        position += direction.isHorizontal ? s.height : s.width;
        remaining -= item._size;
      }
    }

    _previousSize = size;
  }

  void _reset(Size size, Iterable<PlutoLayoutTabItem> enabledItems) {
    if (_previousSize == size) return;

    final maxSize = direction.isHorizontal ? size.height : size.width;

    PlutoLayoutTabItemSizeResolver._update(
      maxSize: maxSize,
      minSize: PlutoLayoutData.minTabSize,
      items: enabledItems,
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
    super.key,
  });

  final PlutoLayoutId layoutId;

  final PlutoLayoutTabItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
      visible: item.enabled,
      maintainState: item.maintainState,
      child: GestureDetector(
        onTap: () {
          _TabsHelper.setFocus(
            ref: ref,
            layoutId: layoutId,
            itemId: item.id,
          );
        },
        child: item.tabViewWidget!,
      ),
    );
  }
}
