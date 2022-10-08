import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../helpers/helpers.dart';
import '../widgets/widgets.dart';

enum TabViewDirection {
  left,
  right;

  bool get isLeft => this == TabViewDirection.left;
  bool get isRight => this == TabViewDirection.right;
}

class TabViewContainer extends StatefulWidget {
  const TabViewContainer({
    required this.controller,
    required this.direction,
    super.key,
  });

  final PlutoLayoutController controller;

  final TabViewDirection direction;

  @override
  State<TabViewContainer> createState() => _TabViewContainerState();
}

class _TabViewContainerState extends State<TabViewContainer> {
  final resizeNotifier = ChangeNotifier();

  List<PlutoLayoutMenuItem> _enabledMenus = [];

  Iterable<PlutoLayoutMenuItem> get enabledMenus {
    switch (widget.direction) {
      case TabViewDirection.left:
        return widget.controller.enabledLeftMenus;
      case TabViewDirection.right:
        return widget.controller.enabledRightMenus;
    }
  }

  Widget getEnabledTabView(BuildContext context, PlutoLayoutMenuItem item) {
    switch (widget.direction) {
      case TabViewDirection.left:
        return widget.controller.getEnabledLeftTabView(context, item);
      case TabViewDirection.right:
        return widget.controller.getEnabledRightTabView(context, item);
    }
  }

  @override
  void initState() {
    super.initState();

    _enabledMenus = enabledMenus.toList(growable: false);

    widget.controller.addListener(listener);
  }

  @override
  void dispose() {
    resizeNotifier.dispose();

    widget.controller.removeListener(listener);

    super.dispose();
  }

  void listener() {
    setState(() {
      _enabledMenus = enabledMenus.toList(growable: false);
    });
  }

  void resize(Object id, Offset offset) {
    final resizing = ResizeHelper.items<PlutoLayoutMenuItem>(
      offset: offset.dy,
      items: _enabledMenus,
      isMainItem: (e) => e.id == id,
      getItemSize: (e) => e.tabViewHeight ?? widget.controller.minTabViewWidth,
      getItemMinSize: (e) => widget.controller.minTabViewWidth,
      setItemSize: (e, size) => e.tabViewHeight = size,
      mode: ResizeMode.pushAndPull,
    );

    resizing.update();

    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    resizeNotifier.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final tabViews = <LayoutId>[];
    final total = _enabledMenus.length;
    int count = 0;

    for (final item in _enabledMenus) {
      Widget child = getEnabledTabView(context, item);

      if (count < total - 1) {
        child = ResizeIndicator(
          id: item.id,
          position: ResizeIndicatorPosition.bottom,
          onResize: resize,
          child: child,
        );
      }

      tabViews.add(LayoutId(id: item.id, child: child));

      ++count;
    }

    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.dialogBackgroundColor,
      child: CustomMultiChildLayout(
        delegate: _Delegate(
          widget.direction,
          _enabledMenus,
          resizeNotifier,
          widget.controller,
        ),
        children: tabViews,
      ),
    );
  }
}

class _Delegate extends MultiChildLayoutDelegate {
  _Delegate(
    this.direction,
    this.menuItems,
    this.resizeNotifier,
    this.controller,
  ) : super(relayout: resizeNotifier);

  final TabViewDirection direction;

  final List<PlutoLayoutMenuItem> menuItems;

  final ChangeNotifier resizeNotifier;

  final PlutoLayoutController controller;

  double get tabViewHeight {
    switch (direction) {
      case TabViewDirection.left:
        return controller.leftTabViewHeight;
      case TabViewDirection.right:
        return controller.rightTabViewHeight;
    }
  }

  void setTabViewHeight(double height) {
    controller.setLayout(
      leftTabViewHeight: direction.isLeft ? height : null,
      rightTabViewHeight: direction.isRight ? height : null,
    );
  }

  @override
  void performLayout(Size size) {
    setTabViewHeight(size.height);
    int length = menuItems.length;
    int count = 0;
    double remainingHeight = size.height;
    double defaultHeight = size.height / length;
    double y = 0;
    bool isLast(int i) => i + 1 == length;

    for (final item in menuItems) {
      item.tabViewHeight ??= defaultHeight;

      if (!hasChild(item.id)) continue;

      if (isLast(count)) item.tabViewHeight = remainingHeight;

      final s = layoutChild(
        item.id,
        BoxConstraints.tightFor(
          height: min(item.tabViewHeight!, remainingHeight),
          width: size.width,
        ),
      );

      positionChild(item.id, Offset(0, y));

      y += s.height;

      remainingHeight -= s.height;

      ++count;
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}
