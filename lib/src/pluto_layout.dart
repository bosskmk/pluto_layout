import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_layout/pluto_layout.dart';
import 'package:rxdart/rxdart.dart';

import 'events/events.dart';

/// Shortcut registration type of [PlutoLayout.shortcuts].
typedef PlutoLayoutShortcuts = Map<LogicalKeySet, PlutoLayoutIntent>;

/// ID according to the location of [PlutoLayoutContainer].
final layoutIdProvider = Provider<PlutoLayoutId>(
  (ref) => throw UnimplementedError(),
);

/// ID of [PlutoLayoutContainer] that currently has focus activated.
final layoutFocusedIdProvider = StateProvider<PlutoLayoutId>(
  (ref) => PlutoLayoutId.body,
);

/// Layout information of [PlutoLayout].
final layoutDataProvider = Provider((ref) => PlutoLayoutData());

/// Shortcut information defined by the user.
final layoutShortcutsProvider = Provider<PlutoLayoutShortcuts?>((ref) => null);

/// Event controller for handling shortcut events, etc.
final layoutEventsProvider = Provider<PlutoLayoutEventStreamController>(
  (ref) => throw UnimplementedError(),
);

/// [PlutoLayout] is a UI package that can configure a menu or tab view on each side.
///
/// {@template pluto_layout_example}
/// Check the example code.
/// https://github.com/bosskmk/pluto_layout/blob/main/example/lib/main.dart
///
/// Check out the web demo distributed with the example code.
/// https://weblaze.dev/pluto_layout/build/web/#/
/// {@endtemplate}
///
/// The [body], [top], [left], [right], [bottom] properties must pass a [PlutoLayoutContainer] as a child.
/// [body] must be passed. The rest of the properties can be optionally passed.
///
/// You can configure tab views by passing [PlutoLayoutTabs] as children of [PlutoLayoutContainer].
class PlutoLayout extends StatefulWidget {
  const PlutoLayout({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.body,
    this.shortcuts,
    super.key,
  });

  /// You can configure tab views or menus at the top.
  final PlutoLayoutContainer? top;

  /// You can configure tab views and menus on the left side.
  final PlutoLayoutContainer? left;

  /// You can configure tab views or menus on the right side.
  final PlutoLayoutContainer? right;

  /// You can configure tab views or menus at the bottom.
  final PlutoLayoutContainer? bottom;

  /// This is the basic body screen.
  final PlutoLayoutContainer body;

  /// Specific actions by user registration shortcut keys
  ///
  /// {@template pluto_layout_shortcuts_example}
  /// ```dart
  /// shortcuts: {
  ///   LogicalKeySet(LogicalKeyboardKey.escape):
  ///       PlutoLayoutActions.hideAllTabView(),
  ///   LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
  ///       PlutoLayoutActions.rotateTabView(
  ///     PlutoLayoutContainerDirection.left,
  ///   ),
  ///   LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit2):
  ///       PlutoLayoutActions.rotateTabView(
  ///     PlutoLayoutContainerDirection.right,
  ///   ),
  ///   LogicalKeySet(
  ///           LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowRight):
  ///       PlutoLayoutActions.increaseTabView(),
  ///   LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowLeft):
  ///       PlutoLayoutActions.decreaseTabView(),
  /// },
  /// ```
  /// {@endtemplate}
  final PlutoLayoutShortcuts? shortcuts;

  @override
  State<PlutoLayout> createState() => _PlutoLayoutState();
}

class _PlutoLayoutState extends State<PlutoLayout> {
  final PlutoLayoutEventStreamController _eventStreamController =
      PlutoLayoutEventStreamController();

  @override
  void dispose() {
    _eventStreamController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget layoutWidget = ProviderScope(
      overrides: [
        layoutShortcutsProvider.overrideWithValue(widget.shortcuts),
        layoutEventsProvider.overrideWithValue(_eventStreamController),
      ],
      child: Consumer(
        builder: (c, r, w) {
          final layoutData = r.read(layoutDataProvider);

          final frontId = r.watch(layoutFocusedIdProvider);

          return CustomMultiChildLayout(
            delegate: _PlutoLayoutDelegate(layoutData, _eventStreamController),
            children: <LayoutId>[
              LayoutId(
                id: PlutoLayoutId.body,
                child: _LayoutIdProviderScope(
                  id: PlutoLayoutId.body,
                  child: widget.body,
                ),
              ),
              if (widget.right != null)
                LayoutId(
                  id: PlutoLayoutId.right,
                  child: _LayoutIdProviderScope(
                    id: PlutoLayoutId.right,
                    child: widget.right!,
                  ),
                ),
              if (widget.left != null)
                LayoutId(
                  id: PlutoLayoutId.left,
                  child: _LayoutIdProviderScope(
                    id: PlutoLayoutId.left,
                    child: widget.left!,
                  ),
                ),
              if (widget.bottom != null)
                LayoutId(
                  id: PlutoLayoutId.bottom,
                  child: _LayoutIdProviderScope(
                    id: PlutoLayoutId.bottom,
                    child: widget.bottom!,
                  ),
                ),
              if (widget.top != null)
                LayoutId(
                  id: PlutoLayoutId.top,
                  child: _LayoutIdProviderScope(
                    id: PlutoLayoutId.top,
                    child: widget.top!,
                  ),
                ),
            ]..sort((a, b) => a.id == frontId ? 1 : -1),
          );
        },
      ),
    );

    if (widget.shortcuts != null) {
      layoutWidget = Shortcuts(
        shortcuts: widget.shortcuts!,
        debugLabel: 'PlutoLayout Shortcuts',
        child: layoutWidget,
      );
    }

    return layoutWidget;
  }
}

class _PlutoLayoutDelegate extends MultiChildLayoutDelegate {
  _PlutoLayoutDelegate(this._size, this._events);

  final PlutoLayoutData _size;

  final PlutoLayoutEventStreamController _events;

  @override
  void performLayout(Size size) {
    _relayoutEvent(size);

    _size.size = size;

    PlutoLayoutId id = PlutoLayoutId.top;
    if (hasChild(id)) {
      _size.topSize = layoutChild(id, BoxConstraints.loose(size));
      positionChild(id, Offset.zero);
    }

    id = PlutoLayoutId.bottom;
    if (hasChild(id)) {
      _size.bottomSize = layoutChild(id, BoxConstraints.loose(size));
      positionChild(id, Offset(0, size.height - _size.bottomSize.height));
    }

    id = PlutoLayoutId.left;
    if (hasChild(id)) {
      _size.leftSize = layoutChild(
        id,
        BoxConstraints.loose(
          Size(
            size.width,
            max(size.height - _size.topSize.height - _size.bottomSize.height,
                0),
          ),
        ),
      );
      positionChild(id, Offset(0, _size.topSize.height));
    }

    id = PlutoLayoutId.right;
    if (hasChild(id)) {
      _size.rightSize = layoutChild(
        id,
        BoxConstraints.loose(
          Size(
            size.width,
            max(size.height - _size.topSize.height - _size.bottomSize.height,
                0),
          ),
        ),
      );
      positionChild(
        id,
        Offset(size.width - _size.rightSize.width, _size.topSize.height),
      );
    }

    id = PlutoLayoutId.body;
    if (hasChild(id)) {
      _size.bodySize = layoutChild(
        id,
        BoxConstraints.tight(Size(
          max(size.width - _size.leftSize.width - _size.rightSize.width, 0),
          max(size.height - _size.topSize.height - _size.bottomSize.height, 0),
        )),
      );
      positionChild(id, Offset(_size.leftSize.width, _size.topSize.height));
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }

  void _relayoutEvent(Size size) {
    if (_size.size == Size.zero) return;
    if (_size.size == size) return;

    _events.add(const PlutoRelayoutEvent());
  }
}

class _LayoutIdProviderScope extends StatelessWidget {
  const _LayoutIdProviderScope({
    required this.id,
    required this.child,
  });

  final PlutoLayoutId id;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [layoutIdProvider.overrideWithValue(id)],
      child: child,
    );
  }
}

/// Event controller in PlutoLayout
///
/// Listen for events to handle keyboard shortcut events, etc.
/// The received event is handled by listening to the event
/// in the widget that needs event handling.
class PlutoLayoutEventStreamController {
  final PublishSubject<PlutoLayoutEvent> _subject =
      PublishSubject<PlutoLayoutEvent>();

  /// Register event handlers in widgets that need to handle events.
  StreamSubscription<PlutoLayoutEvent> listen(
    void Function(PlutoLayoutEvent) handler,
  ) {
    return _subject.listen(handler);
  }

  void add(PlutoLayoutEvent event) {
    _subject.add(event);
  }

  void dispose() {
    _subject.close();
  }
}

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
            bottomTabMenuSize.height;
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

/// [PlutoLayoutContainer] ID by position of the widget.
enum PlutoLayoutId {
  top,
  left,
  right,
  bottom,
  body;

  bool get isTop => this == PlutoLayoutId.top;
  bool get isLeft => this == PlutoLayoutId.left;
  bool get isRight => this == PlutoLayoutId.right;
  bool get isBottom => this == PlutoLayoutId.bottom;
  bool get isBody => this == PlutoLayoutId.body;
}
