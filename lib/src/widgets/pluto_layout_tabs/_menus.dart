part of pluto_layout_tabs;

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
          .read(_itemsProvider)
          .firstWhereOrNull((e) => e.id == event.tabItemId);

      if (item == null) return;

      toggleTab(ref, item, !item.enabled);
    } else if (event is PlutoRotateTabViewEvent &&
        event.containerDirection == widget.direction) {
      final items = ref.read(_itemsProvider);

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
        toggleTab(
          ref,
          widget.mode.isShowOneMust ? items.first : items.last,
          widget.mode.isShowOneMust ? true : false,
        );
        return;
      }

      toggleTab(ref, items[enabledIndex + 1], true, forceShowOne: true);
    } else if (event is PlutoHideAllTabViewEvent) {
      ref.read(_itemsProvider.notifier).toggleAll(false, widget.mode);

      if (event.afterFocusToBody) {
        ref.read(layoutFocusedIdProvider.notifier).state = PlutoLayoutId.body;
      }
    }
  }

  void toggleTab(
    WidgetRef ref,
    PlutoLayoutTabItem item,
    bool flag, {
    bool? forceShowOne,
  }) {
    if (widget.mode.isShowOneMust) flag = true;

    final layoutId = ref.read(layoutIdProvider);

    ref.read(layoutFocusedIdProvider.notifier).state = layoutId;

    final layoutData = ref.read(layoutDataProvider);

    ref.read(_itemsProvider.notifier).setEnabled(
          item.id,
          flag,
          widget.mode,
          forceShowOne: forceShowOne,
        );

    final items = ref.read(_itemsProvider).where((e) => e.enabled);

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

    final items = ref.watch(_itemsProvider);

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
