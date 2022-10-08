import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../helpers/helpers.dart';
import 'layout_controller.dart';

mixin MenuControllerMixin implements LayoutControllerMixin, ChangeNotifier {
  final Map<Object, Widget> _leftWidgets = {};

  final Map<Object, Widget> _rightWidgets = {};

  List<PlutoLayoutMenuItem> get leftMenus;

  List<PlutoLayoutMenuItem> get rightMenus;

  Iterable<PlutoLayoutMenuItem> get enabledLeftMenus =>
      leftMenus.where((e) => e.tabViewBuilder != null && e.enabled);

  Iterable<PlutoLayoutMenuItem> get enabledRightMenus =>
      rightMenus.where((e) => e.tabViewBuilder != null && e.enabled);

  bool get hasLeftMenus => leftMenus.isNotEmpty;

  bool get hasRightMenus => rightMenus.isNotEmpty;

  bool get hasEnabledLeftTabViews =>
      leftMenus.where((e) => e.enabled).isNotEmpty;

  bool get hasEnabledRightTabViews =>
      rightMenus.where((e) => e.enabled).isNotEmpty;

  bool _previousEnabledLeftTabView = false;

  bool _previousEnabledRightTabView = false;

  void setEnabledLeftMenuItem(Object id, bool flag) {
    final found = leftMenus.firstWhereOrNull((e) => e.id == id);

    if (found == null) return;

    updatePreviousEnabledTabView();

    found.enabled = flag;

    final sizing = AutoSizeHelper.items(
      maxSize: leftTabViewHeight,
      length: enabledLeftMenus.length,
      itemMinSize: minTabViewWidth,
      mode: AutoSizeMode.equal,
    );

    for (final item in enabledLeftMenus) {
      item.tabViewHeight = sizing.getItemSize(
        item.tabViewHeight ?? minTabViewWidth,
      );
    }

    resetTabViewWidth();

    notifyListeners();
  }

  void setEnabledRightMenuItem(Object id, bool flag) {
    final found = rightMenus.firstWhereOrNull((e) => e.id == id);

    if (found == null) return;

    updatePreviousEnabledTabView();

    found.enabled = flag;

    final sizing = AutoSizeHelper.items(
      maxSize: rightTabViewHeight,
      length: enabledRightMenus.length,
      itemMinSize: minTabViewWidth,
      mode: AutoSizeMode.equal,
    );

    for (final item in enabledRightMenus) {
      item.tabViewHeight = sizing.getItemSize(
        item.tabViewHeight ?? minTabViewWidth,
      );
    }

    resetTabViewWidth();

    notifyListeners();
  }

  Widget getEnabledLeftTabView(
    BuildContext context,
    PlutoLayoutMenuItem item,
  ) {
    if (_leftWidgets[item.id] == null) {
      _leftWidgets[item.id] = item.tabViewBuilder!(context);
    }

    return _leftWidgets[item.id]!;
  }

  Widget getEnabledRightTabView(
    BuildContext context,
    PlutoLayoutMenuItem item,
  ) {
    if (_rightWidgets[item.id] == null) {
      _rightWidgets[item.id] = item.tabViewBuilder!(context);
    }

    return _rightWidgets[item.id]!;
  }

  void resizeTabViewWidth(Object id, Offset offset) {
    final items = [
      if (hasEnabledLeftTabViews) PlutoLayoutId.leftTabView,
      PlutoLayoutId.bodyContainer,
      if (hasEnabledRightTabViews) PlutoLayoutId.rightTabView,
    ];

    final resizing = ResizeHelper.items<PlutoLayoutId>(
      offset: id == PlutoLayoutId.leftTabView ? offset.dx : -offset.dx,
      items: items,
      isMainItem: (e) => e == id,
      getItemSize: (e) {
        if (e == PlutoLayoutId.leftTabView) return leftTabViewWidth;
        if (e == PlutoLayoutId.bodyContainer) return bodyContainerWidth;
        if (e == PlutoLayoutId.rightTabView) return rightTabViewWidth;
        throw 'This exception is not thrown.';
      },
      getItemMinSize: (e) => minTabViewWidth,
      setItemSize: (e, size) {
        setLayout(
          leftTabViewWidth: e == PlutoLayoutId.leftTabView ? size : null,
          bodyContainerWidth: e == PlutoLayoutId.bodyContainer ? size : null,
          rightTabViewWidth: e == PlutoLayoutId.rightTabView ? size : null,
        );
      },
      mode: ResizeMode.pushAndPull,
    );

    resizing.update();
  }

  void resetTabViewWidth() {
    setLayout(
      bodyContainerWidth: _previousEnabledLeftTabView != hasEnabledLeftTabViews
          ? hasEnabledLeftTabViews
              ? bodyContainerWidth - leftTabViewWidth
              : bodyContainerWidth + leftTabViewWidth
          : _previousEnabledRightTabView != hasEnabledRightTabViews
              ? hasEnabledRightTabViews
                  ? bodyContainerWidth - rightTabViewWidth
                  : bodyContainerWidth + rightTabViewWidth
              : null,
    );

    updatePreviousEnabledTabView();
  }

  void updateLayout(Size size) {
    if (!initializedLayout) return;

    double diff = contentWidth - size.width;

    int length = 1;
    if (hasEnabledLeftTabViews) ++length;
    if (hasEnabledRightTabViews) ++length;

    final double diffScale = diff / length;

    setLayout(
      bodyContainerWidth: bodyContainerWidth - diffScale,
      leftTabViewWidth: hasEnabledLeftTabViews
          ? max(leftTabViewWidth - diffScale, minTabViewWidth)
          : null,
      rightTabViewWidth: hasEnabledRightTabViews
          ? max(rightTabViewWidth - diffScale, minTabViewWidth)
          : null,
    );
  }

  void updatePreviousEnabledTabView() {
    _previousEnabledLeftTabView = hasEnabledLeftTabViews;
    _previousEnabledRightTabView = hasEnabledRightTabViews;
  }
}
