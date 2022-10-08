// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_layout/src/ui/ui.dart';

import 'widgets/widgets.dart';

class PlutoLayout extends StatefulWidget {
  PlutoLayout({
    PlutoLayoutController? controller,
    super.key,
  }) : controller = controller ?? PlutoLayoutController();

  final PlutoLayoutController controller;

  @override
  State<PlutoLayout> createState() => _PlutoLayoutState();
}

class _PlutoLayoutState extends State<PlutoLayout> {
  final resizeNotifier = ChangeNotifier();

  bool _hasLeftSideMenus = false;

  bool _hasLeftSideTabViews = false;

  bool _hasRightSideMenus = false;

  bool _hasRightSideTabViews = false;

  @override
  void initState() {
    super.initState();

    _hasLeftSideMenus = widget.controller.hasLeftSideMenus;

    _hasLeftSideTabViews = widget.controller.hasEnabledLeftSideTabViews;

    _hasRightSideMenus = widget.controller.hasRightSideMenus;

    _hasRightSideTabViews = widget.controller.hasEnabledRightSideTabViews;

    widget.controller.addListener(listener);
  }

  @override
  void dispose() {
    resizeNotifier.dispose();

    widget.controller.removeListener(listener);

    super.dispose();
  }

  void listener() {
    if (_hasLeftSideMenus == widget.controller.hasLeftSideMenus &&
        _hasLeftSideTabViews == widget.controller.hasEnabledLeftSideTabViews &&
        _hasRightSideMenus == widget.controller.hasRightSideMenus &&
        _hasRightSideTabViews ==
            widget.controller.hasEnabledRightSideTabViews) {
      return;
    }

    setState(() {
      _hasLeftSideMenus = widget.controller.hasLeftSideMenus;
      _hasLeftSideTabViews = widget.controller.hasEnabledLeftSideTabViews;
      _hasRightSideMenus = widget.controller.hasRightSideMenus;
      _hasRightSideTabViews = widget.controller.hasEnabledRightSideTabViews;
    });
  }

  void resize(Object id, Offset offset) {
    widget.controller.resizeSideTabViewWidth(id, offset);

    // ignore: invalid_use_of_visible_for_testing_member
    resizeNotifier.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _PlutoLayoutDelegate(resizeNotifier, widget.controller),
      children: [
        LayoutId(
          id: PlutoLayoutId.topSideMenu,
          child: const TopMenus(),
        ),
        if (_hasLeftSideMenus) ...[
          LayoutId(
            id: PlutoLayoutId.leftSideMenu,
            child: LeftMenus(controller: widget.controller),
          ),
          if (_hasLeftSideTabViews)
            LayoutId(
              id: PlutoLayoutId.leftSideTabView,
              child: ResizeIndicator(
                id: PlutoLayoutId.leftSideTabView,
                onResize: resize,
                position: ResizeIndicatorPosition.right,
                child: LeftTabView(controller: widget.controller),
              ),
            ),
        ],
        LayoutId(
          id: PlutoLayoutId.bodyContainer,
          child: const BodyContainer(),
        ),
        if (_hasRightSideMenus) ...[
          LayoutId(
            id: PlutoLayoutId.rightSideMenu,
            child: RightMenus(controller: widget.controller),
          ),
          if (_hasRightSideTabViews)
            LayoutId(
              id: PlutoLayoutId.rightSideTabView,
              child: ResizeIndicator(
                id: PlutoLayoutId.rightSideTabView,
                onResize: resize,
                position: ResizeIndicatorPosition.left,
                child: RightTabView(controller: widget.controller),
              ),
            ),
        ],
        LayoutId(
          id: PlutoLayoutId.bottomSideMenu,
          child: const BottomMenus(),
        ),
      ],
    );
  }
}

class _PlutoLayoutDelegate extends MultiChildLayoutDelegate {
  _PlutoLayoutDelegate(this.resizeNotifier, this.controller)
      : super(relayout: resizeNotifier);

  final ChangeNotifier resizeNotifier;

  final PlutoLayoutController controller;

  @override
  void performLayout(Size size) {
    if (size.width != controller.contentWidth && controller.contentWidth != 0) {
      controller.updateLayout(size);
    }

    controller.contentWidth = size.width;
    final double minSideTabViewWidth = controller.minSideTabViewWidth;
    double bodyTop = 0;
    double bodyLeft = 0;
    double bodyRight = 0;
    double bodyBottom = 0;
    bool keepBodyContainerWidth =
        controller.bodyContainerWidth <= minSideTabViewWidth;
    double takeForBodyWidth =
        minSideTabViewWidth - controller.bodyContainerWidth;

    if (hasChild(PlutoLayoutId.topSideMenu)) {
      final s = layoutChild(
        PlutoLayoutId.topSideMenu,
        BoxConstraints.tightFor(width: size.width),
      );

      bodyTop += s.height;

      positionChild(
        PlutoLayoutId.topSideMenu,
        Offset.zero,
      );
    }

    if (hasChild(PlutoLayoutId.bottomSideMenu)) {
      final s = layoutChild(
        PlutoLayoutId.bottomSideMenu,
        BoxConstraints.tightFor(width: size.width),
      );

      bodyBottom += s.height;

      positionChild(
        PlutoLayoutId.bottomSideMenu,
        Offset(size.width - s.width, size.height - s.height),
      );
    }

    if (hasChild(PlutoLayoutId.leftSideMenu)) {
      final s = layoutChild(
        PlutoLayoutId.leftSideMenu,
        BoxConstraints.tightFor(height: size.height - bodyTop - bodyBottom),
      );

      bodyLeft += s.width;

      positionChild(
        PlutoLayoutId.leftSideMenu,
        Offset(0, bodyTop),
      );
    }

    if (hasChild(PlutoLayoutId.leftSideTabView)) {
      if (keepBodyContainerWidth &&
          controller.leftSideTabViewWidth > minSideTabViewWidth) {
        if (controller.leftSideTabViewWidth >= takeForBodyWidth) {
          controller.bodyContainerWidth = minSideTabViewWidth;
          controller.leftSideTabViewWidth -= takeForBodyWidth;
        } else {
          final take = controller.leftSideTabViewWidth - takeForBodyWidth;
          takeForBodyWidth -= take;
          controller.bodyContainerWidth += take;
        }
      }

      final s = layoutChild(
        PlutoLayoutId.leftSideTabView,
        BoxConstraints.tightFor(
          width: controller.leftSideTabViewWidth,
          height: size.height - bodyTop - bodyBottom,
        ),
      );

      positionChild(
        PlutoLayoutId.leftSideTabView,
        Offset(bodyLeft, bodyTop),
      );

      bodyLeft += s.width;
    }

    if (hasChild(PlutoLayoutId.rightSideMenu)) {
      final s = layoutChild(
        PlutoLayoutId.rightSideMenu,
        BoxConstraints.tightFor(height: size.height - bodyTop - bodyBottom),
      );

      bodyRight += s.width;

      positionChild(
        PlutoLayoutId.rightSideMenu,
        Offset(size.width - s.width, bodyTop),
      );
    }

    if (hasChild(PlutoLayoutId.rightSideTabView)) {
      if (keepBodyContainerWidth &&
          controller.rightSideTabViewWidth > minSideTabViewWidth &&
          takeForBodyWidth > 0) {
        if (controller.leftSideTabViewWidth >= takeForBodyWidth) {
          controller.bodyContainerWidth = minSideTabViewWidth;
          controller.rightSideTabViewWidth -= takeForBodyWidth;
        } else {
          final take = controller.rightSideTabViewWidth - takeForBodyWidth;
          takeForBodyWidth -= take;
          controller.bodyContainerWidth += take;
        }
      }

      final s = layoutChild(
        PlutoLayoutId.rightSideTabView,
        BoxConstraints.tightFor(
          width: controller.rightSideTabViewWidth,
          height: size.height - bodyTop - bodyBottom,
        ),
      );

      bodyRight += s.width;

      positionChild(
        PlutoLayoutId.rightSideTabView,
        Offset(size.width - bodyRight, bodyTop),
      );
    }

    if (hasChild(PlutoLayoutId.bodyContainer)) {
      final s = layoutChild(
        PlutoLayoutId.bodyContainer,
        BoxConstraints.tight(Size(
          size.width - bodyLeft - bodyRight,
          size.height - bodyTop - bodyBottom,
        )),
      );

      controller.bodyContainerWidth = s.width;

      positionChild(
        PlutoLayoutId.bodyContainer,
        Offset(bodyLeft, bodyTop),
      );
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}

enum PlutoLayoutId {
  bodyContainer,
  bottomSideMenu,
  leftSideMenu,
  leftSideTabView,
  rightSideMenu,
  rightSideTabView,
  topSideMenu,
}
