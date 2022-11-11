import 'dart:ui';

import 'package:pluto_layout/pluto_layout.dart';

/// Information needed for the layout of the widget
class PlutoLayoutData {
  /// [PlutoLayout] size constraint.
  Size size = Size.zero;

  /// [PlutoLayout.top] size constraint of container.
  Size topSize = Size.zero;

  /// [PlutoLayout.left] size constraint of container.
  Size leftSize = Size.zero;

  /// [PlutoLayout.right] size constraint of container.
  Size rightSize = Size.zero;

  /// [PlutoLayout.bottom] size constraint of container.
  Size bottomSize = Size.zero;

  /// [PlutoLayout.body] size constraint of container.
  Size bodySize = Size.zero;

  /// Size of menu area when [PlutoLayoutTabs] is set in [PlutoLayout.top].
  Size topTabMenuSize = Size.zero;

  /// Size of menu area when [PlutoLayoutTabs] is set in [PlutoLayout.left].
  Size leftTabMenuSize = Size.zero;

  /// Size of menu area if [PlutoLayoutTabs] is set in [PlutoLayout.right].
  Size rightTabMenuSize = Size.zero;

  /// Size of menu area when [PlutoLayoutTabs] is set in [PlutoLayout.bottom].
  Size bottomTabMenuSize = Size.zero;

  /// Size of menu area if [PlutoLayoutTabs] is set in [PlutoLayout.body].
  Size bodyTabMenuSize = Size.zero;

  /// Default width of tab view.
  ///
  /// Corresponds to left and right tab views.
  double get defaultTabWidth => size.width / 4;

  /// Default height of the tab view.
  ///
  /// Corresponds to top and bottom tab views.
  double get defaultTabHeight => size.height / 6;

  /// Minimum size of the tab view.
  static const double minTabSize = 32;

  /// Maximum size of tab items of [PlutoLayoutTabs] in [id] direction.
  double getTabItemViewMaxSize(PlutoLayoutId id) {
    switch (id) {
      case PlutoLayoutId.top:
        return topSize.width;
      case PlutoLayoutId.left:
        return leftSize.height;
      case PlutoLayoutId.right:
        return rightSize.height;
      case PlutoLayoutId.bottom:
        return bottomSize.width;
      case PlutoLayoutId.body:
        return bodySize.width;
    }
  }

  /// Minimum size of tab view of [PlutoLayoutTabs] in [id] direction.
  double getTabViewMinSize(PlutoLayoutId id) {
    switch (id) {
      case PlutoLayoutId.body:
        return bodyTabMenuSize.height;
      case PlutoLayoutId.top:
        return topTabMenuSize.height;
      case PlutoLayoutId.bottom:
        return bottomTabMenuSize.height;
      case PlutoLayoutId.left:
        return leftTabMenuSize.width;
      case PlutoLayoutId.right:
        return rightTabMenuSize.width;
    }
  }

  /// Maximum size of tab view of [PlutoLayoutTabs] in [id] direction.
  double getTabViewMaxSize(PlutoLayoutId id) {
    switch (id) {
      case PlutoLayoutId.body:
        return size.height -
            topSize.height -
            bottomSize.height -
            bodyTabMenuSize.height;
      case PlutoLayoutId.top:
      case PlutoLayoutId.bottom:
        return size.height - topTabMenuSize.height - bottomTabMenuSize.height;
      case PlutoLayoutId.left:
      case PlutoLayoutId.right:
        return size.width - leftTabMenuSize.width - rightTabMenuSize.width;
    }
  }

  /// Size of menu area of [PlutoLayoutTabs] in [id] direction.
  Size getTabMenuSize(PlutoLayoutId id) {
    switch (id) {
      case PlutoLayoutId.top:
        return topTabMenuSize;
      case PlutoLayoutId.left:
        return leftTabMenuSize;
      case PlutoLayoutId.right:
        return rightTabMenuSize;
      case PlutoLayoutId.bottom:
        return bottomTabMenuSize;
      case PlutoLayoutId.body:
        return bodyTabMenuSize;
    }
  }

  /// Set the menu area size of [PlutoLayoutTabs] in the [id] direction.
  ///
  /// Set in the layout stage in [_RenderMenusWidget] of the [_Menus] widget.
  /// [_TabView] must be laid out before the widget.
  void setTabMenuSize(PlutoLayoutId id, Size size) {
    switch (id) {
      case PlutoLayoutId.top:
        topTabMenuSize = size;
        break;
      case PlutoLayoutId.left:
        leftTabMenuSize = size;
        break;
      case PlutoLayoutId.right:
        rightTabMenuSize = size;
        break;
      case PlutoLayoutId.bottom:
        bottomTabMenuSize = size;
        break;
      case PlutoLayoutId.body:
        bodyTabMenuSize = size;
        break;
    }
  }

  @override
  String toString() {
    String text = 'PlutoLayoutData\n';
    text += 'size: $size\n';
    text += 'topSize: $topSize\n';
    text += 'leftSize: $leftSize\n';
    text += 'rightSize: $rightSize\n';
    text += 'bottomSize: $bottomSize\n';
    text += 'bodySize: $bodySize';
    return text;
  }
}
