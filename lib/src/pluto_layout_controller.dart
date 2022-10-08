import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:pluto_layout/pluto_layout.dart';

import 'helper/resize_helper.dart';

class PlutoLayoutController extends ChangeNotifier {
  PlutoLayoutController({
    List<PlutoLayoutMenuItem>? leftSideMenus,
    List<PlutoLayoutMenuItem>? rightSideMenus,
    this.minSideTabViewWidth = 32.0,
  })  : _leftSideMenus = leftSideMenus ?? const [],
        _rightSideMenus = rightSideMenus ?? const [];

  final List<PlutoLayoutMenuItem> _leftSideMenus;

  final List<PlutoLayoutMenuItem> _rightSideMenus;

  final Map<Object, Widget> _leftSideWidgets = {};

  final Map<Object, Widget> _rightSideWidgets = {};

  final double minSideTabViewWidth;

  @protected
  double leftSideHeight = 0;

  @protected
  double rightSideHeight = 0;

  @protected
  double leftSideTabViewWidth = 200;

  @protected
  double rightSideTabViewWidth = 200;

  @protected
  double bodyContainerWidth = 200;

  @protected
  double contentWidth = 0;

  bool _previousEnabledLeftSideTabView = false;

  bool _previousEnabledRightSideTabView = false;

  List<PlutoLayoutMenuItem> get leftSideMenus => _leftSideMenus;

  List<PlutoLayoutMenuItem> get rightSideMenus => _rightSideMenus;

  Iterable<PlutoLayoutMenuItem> get enabledLeftSideMenus =>
      _leftSideMenus.where((e) => e.tabViewBuilder != null && e.enabled);

  Iterable<PlutoLayoutMenuItem> get enabledRightSideMenus =>
      _rightSideMenus.where((e) => e.tabViewBuilder != null && e.enabled);

  bool get hasLeftSideMenus => _leftSideMenus.isNotEmpty;

  bool get hasRightSideMenus => _rightSideMenus.isNotEmpty;

  bool get hasEnabledLeftSideTabViews =>
      _leftSideMenus.where((e) => e.enabled).isNotEmpty;

  bool get hasEnabledRightSideTabViews =>
      _rightSideMenus.where((e) => e.enabled).isNotEmpty;

  double get sumContentWidth =>
      leftSideTabViewWidth + bodyContainerWidth + rightSideTabViewWidth;

  void setEnabledLeftSideMenuItem(Object id, bool flag) {
    final found = _leftSideMenus.firstWhereOrNull((e) => e.id == id);

    if (found == null) return;

    updatePreviousEnabledSideTabView();

    found.enabled = flag;

    final sizing = AutoSizeHelper.items(
      maxSize: leftSideHeight,
      length: enabledLeftSideMenus.length,
      itemMinSize: 45,
      mode: AutoSizeMode.equal,
    );

    for (final item in enabledLeftSideMenus) {
      item.tabViewHeight = sizing.getItemSize(item.tabViewHeight ?? 200);
    }

    resetTabViewWidth();

    notifyListeners();
  }

  void setEnabledRightSideMenuItem(Object id, bool flag) {
    final found = _rightSideMenus.firstWhereOrNull((e) => e.id == id);

    if (found == null) return;

    updatePreviousEnabledSideTabView();

    found.enabled = flag;

    final sizing = AutoSizeHelper.items(
      maxSize: rightSideHeight,
      length: enabledRightSideMenus.length,
      itemMinSize: 45,
      mode: AutoSizeMode.equal,
    );

    for (final item in enabledRightSideMenus) {
      item.tabViewHeight = sizing.getItemSize(item.tabViewHeight ?? 200);
    }

    resetTabViewWidth();

    notifyListeners();
  }

  Widget getEnabledLeftSideTabView(
    BuildContext context,
    PlutoLayoutMenuItem item,
  ) {
    if (_leftSideWidgets[item.id] == null) {
      _leftSideWidgets[item.id] = item.tabViewBuilder!(context);
    }

    return _leftSideWidgets[item.id]!;
  }

  Widget getEnabledRightSideTabView(
    BuildContext context,
    PlutoLayoutMenuItem item,
  ) {
    if (_rightSideWidgets[item.id] == null) {
      _rightSideWidgets[item.id] = item.tabViewBuilder!(context);
    }

    return _rightSideWidgets[item.id]!;
  }

  void resizeSideTabViewWidth(Object id, Offset offset) {
    final items = [
      if (hasEnabledLeftSideTabViews) PlutoLayoutId.leftSideTabView,
      PlutoLayoutId.bodyContainer,
      if (hasEnabledRightSideTabViews) PlutoLayoutId.rightSideTabView,
    ];

    final resizing = ResizeHelper.items<PlutoLayoutId>(
      offset: id == PlutoLayoutId.leftSideTabView ? offset.dx : -offset.dx,
      items: items,
      isMainItem: (e) => e == id,
      getItemSize: (e) {
        if (e == PlutoLayoutId.leftSideTabView) return leftSideTabViewWidth;
        if (e == PlutoLayoutId.bodyContainer) return bodyContainerWidth;
        if (e == PlutoLayoutId.rightSideTabView) return rightSideTabViewWidth;
        throw 'This exception is not thrown.';
      },
      getItemMinSize: (e) => minSideTabViewWidth,
      setItemSize: (e, size) {
        if (e == PlutoLayoutId.leftSideTabView) leftSideTabViewWidth = size;
        if (e == PlutoLayoutId.bodyContainer) bodyContainerWidth = size;
        if (e == PlutoLayoutId.rightSideTabView) rightSideTabViewWidth = size;
      },
      mode: ResizeMode.pushAndPull,
    );

    resizing.update();
  }

  void resetTabViewWidth() {
    if (_previousEnabledLeftSideTabView != hasEnabledLeftSideTabViews) {
      if (hasEnabledLeftSideTabViews) {
        bodyContainerWidth -= leftSideTabViewWidth;
      } else {
        bodyContainerWidth += leftSideTabViewWidth;
      }
    } else if (_previousEnabledRightSideTabView !=
        hasEnabledRightSideTabViews) {
      if (hasEnabledRightSideTabViews) {
        bodyContainerWidth -= rightSideTabViewWidth;
      } else {
        bodyContainerWidth += rightSideTabViewWidth;
      }
    }

    updatePreviousEnabledSideTabView();
  }

  void updateLayout(Size size) {
    double diff = contentWidth - size.width;

    int length = 1;
    if (hasEnabledLeftSideTabViews) ++length;
    if (hasEnabledRightSideTabViews) ++length;

    bodyContainerWidth -= diff / length;

    if (hasEnabledLeftSideTabViews) {
      leftSideTabViewWidth -= diff / length;
      leftSideTabViewWidth = max(leftSideTabViewWidth, minSideTabViewWidth);
    }

    if (hasEnabledRightSideTabViews) {
      rightSideTabViewWidth -= diff / length;
      rightSideTabViewWidth = max(rightSideTabViewWidth, minSideTabViewWidth);
    }
  }

  void updatePreviousEnabledSideTabView() {
    _previousEnabledLeftSideTabView = hasEnabledLeftSideTabViews;
    _previousEnabledRightSideTabView = hasEnabledRightSideTabViews;
  }
}
