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

  bool _hasLeftMenus = false;

  bool _hasLeftTabViews = false;

  bool _hasRightMenus = false;

  bool _hasRightTabViews = false;

  @override
  void initState() {
    super.initState();

    _hasLeftMenus = widget.controller.hasLeftMenus;

    _hasLeftTabViews = widget.controller.hasEnabledLeftTabViews;

    _hasRightMenus = widget.controller.hasRightMenus;

    _hasRightTabViews = widget.controller.hasEnabledRightTabViews;

    widget.controller.addListener(listener);
  }

  @override
  void dispose() {
    resizeNotifier.dispose();

    widget.controller.removeListener(listener);

    super.dispose();
  }

  void listener() {
    if (_hasLeftMenus == widget.controller.hasLeftMenus &&
        _hasLeftTabViews == widget.controller.hasEnabledLeftTabViews &&
        _hasRightMenus == widget.controller.hasRightMenus &&
        _hasRightTabViews == widget.controller.hasEnabledRightTabViews) {
      return;
    }

    setState(() {
      _hasLeftMenus = widget.controller.hasLeftMenus;
      _hasLeftTabViews = widget.controller.hasEnabledLeftTabViews;
      _hasRightMenus = widget.controller.hasRightMenus;
      _hasRightTabViews = widget.controller.hasEnabledRightTabViews;
    });
  }

  void resize(Object id, Offset offset) {
    widget.controller.resizeTabViewWidth(id, offset);

    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    resizeNotifier.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _PlutoLayoutDelegate(resizeNotifier, widget.controller),
      children: [
        LayoutId(
          id: PlutoLayoutId.topMenu,
          child: const MenuContainer(direction: PlutoLayoutMenuDirection.top),
        ),
        if (_hasLeftMenus) ...[
          LayoutId(
            id: PlutoLayoutId.leftMenu,
            child: MenuContainer(
              direction: PlutoLayoutMenuDirection.left,
              onTap: widget.controller.setEnabledLeftMenuItem,
              items: widget.controller.leftMenus.reversed.toList(),
            ),
          ),
          if (_hasLeftTabViews)
            LayoutId(
              id: PlutoLayoutId.leftTabView,
              child: ResizeIndicator(
                id: PlutoLayoutId.leftTabView,
                onResize: resize,
                position: ResizeIndicatorPosition.right,
                child: TabViewContainer(
                  controller: widget.controller,
                  direction: TabViewDirection.left,
                ),
              ),
            ),
        ],
        LayoutId(
          id: PlutoLayoutId.bodyContainer,
          child: const BodyContainer(),
        ),
        if (_hasRightMenus) ...[
          LayoutId(
            id: PlutoLayoutId.rightMenu,
            child: MenuContainer(
              direction: PlutoLayoutMenuDirection.right,
              onTap: widget.controller.setEnabledRightMenuItem,
              items: widget.controller.rightMenus,
            ),
          ),
          if (_hasRightTabViews)
            LayoutId(
              id: PlutoLayoutId.rightTabView,
              child: ResizeIndicator(
                id: PlutoLayoutId.rightTabView,
                onResize: resize,
                position: ResizeIndicatorPosition.left,
                child: TabViewContainer(
                  controller: widget.controller,
                  direction: TabViewDirection.right,
                ),
              ),
            ),
        ],
        LayoutId(
          id: PlutoLayoutId.bottomMenu,
          child: const MenuContainer(
            direction: PlutoLayoutMenuDirection.bottom,
          ),
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

  void _updateBeforeLayout(Size size) {
    if (size.width != controller.contentWidth && controller.contentWidth != 0) {
      controller.updateLayout(size);
    }

    controller.setLayout(contentWidth: size.width);
  }

  @override
  void performLayout(Size size) {
    _updateBeforeLayout(size);

    final double minTabViewWidth = controller.minTabViewWidth;
    double bodyTop = 0;
    double bodyLeft = 0;
    double bodyRight = 0;
    double bodyBottom = 0;
    bool bodyNeedsWidth = controller.bodyContainerWidth <= minTabViewWidth;
    double widthBodyNeed = minTabViewWidth - controller.bodyContainerWidth;

    if (hasChild(PlutoLayoutId.topMenu)) {
      final s = layoutChild(
        PlutoLayoutId.topMenu,
        BoxConstraints.tightFor(width: size.width),
      );

      bodyTop += s.height;

      positionChild(
        PlutoLayoutId.topMenu,
        Offset.zero,
      );
    }

    if (hasChild(PlutoLayoutId.bottomMenu)) {
      final s = layoutChild(
        PlutoLayoutId.bottomMenu,
        BoxConstraints.tightFor(width: size.width),
      );

      bodyBottom += s.height;

      positionChild(
        PlutoLayoutId.bottomMenu,
        Offset(size.width - s.width, size.height - s.height),
      );
    }

    if (hasChild(PlutoLayoutId.leftMenu)) {
      final s = layoutChild(
        PlutoLayoutId.leftMenu,
        BoxConstraints.tightFor(height: size.height - bodyTop - bodyBottom),
      );

      bodyLeft += s.width;

      positionChild(
        PlutoLayoutId.leftMenu,
        Offset(0, bodyTop),
      );
    }

    if (hasChild(PlutoLayoutId.leftTabView)) {
      if (bodyNeedsWidth && controller.leftTabViewWidth > minTabViewWidth) {
        if (controller.leftTabViewWidth >= widthBodyNeed) {
          controller.setLayout(
            bodyContainerWidth: minTabViewWidth,
            leftTabViewWidth: controller.leftTabViewWidth - widthBodyNeed,
          );
        } else {
          final take = controller.leftTabViewWidth - widthBodyNeed;
          widthBodyNeed -= take;
          controller.setLayout(
            bodyContainerWidth: controller.bodyContainerWidth + take,
            leftTabViewWidth: controller.leftTabViewWidth - take,
          );
        }
      }

      final s = layoutChild(
        PlutoLayoutId.leftTabView,
        BoxConstraints.tightFor(
          width: controller.leftTabViewWidth,
          height: size.height - bodyTop - bodyBottom,
        ),
      );

      positionChild(
        PlutoLayoutId.leftTabView,
        Offset(bodyLeft, bodyTop),
      );

      bodyLeft += s.width;
    }

    if (hasChild(PlutoLayoutId.rightMenu)) {
      final s = layoutChild(
        PlutoLayoutId.rightMenu,
        BoxConstraints.tightFor(height: size.height - bodyTop - bodyBottom),
      );

      bodyRight += s.width;

      positionChild(
        PlutoLayoutId.rightMenu,
        Offset(size.width - s.width, bodyTop),
      );
    }

    if (hasChild(PlutoLayoutId.rightTabView)) {
      if (bodyNeedsWidth &&
          widthBodyNeed > 0 &&
          controller.rightTabViewWidth > minTabViewWidth) {
        if (controller.rightTabViewWidth >= widthBodyNeed) {
          controller.setLayout(
            bodyContainerWidth: minTabViewWidth,
            rightTabViewWidth: controller.rightTabViewWidth - widthBodyNeed,
          );
        } else {
          final take = controller.rightTabViewWidth - widthBodyNeed;
          widthBodyNeed -= take;
          controller.setLayout(
            bodyContainerWidth: controller.bodyContainerWidth + take,
            rightTabViewWidth: controller.rightTabViewWidth - take,
          );
        }
      }

      final s = layoutChild(
        PlutoLayoutId.rightTabView,
        BoxConstraints.tightFor(
          width: controller.rightTabViewWidth,
          height: size.height - bodyTop - bodyBottom,
        ),
      );

      bodyRight += s.width;

      positionChild(
        PlutoLayoutId.rightTabView,
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

      controller.setLayout(bodyContainerWidth: s.width);

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
  bottomMenu,
  leftMenu,
  leftTabView,
  rightMenu,
  rightTabView,
  topMenu,
}
