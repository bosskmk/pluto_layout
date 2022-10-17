import 'package:flutter/cupertino.dart';
import 'package:pluto_layout/pluto_layout.dart';
import 'package:rxdart/rxdart.dart';

/// [Intent] collection for performing specific actions
/// by registering keyboard shortcuts.
///
/// {@macro pluto_layout_shortcuts_example}
class PlutoLayoutActions {
  /// Close all tabviews.
  ///
  /// If [afterFocusToBody] is true,
  /// close all tabviews and the body container gets focus.
  static PlutoLayoutActionHideAllTabViewIntent hideAllTabView({
    bool afterFocusToBody = true,
  }) {
    return PlutoLayoutActionHideAllTabViewIntent(
      afterFocusToBody: afterFocusToBody,
    );
  }

  /// Toggles the tab view corresponding to [tabItemId].
  ///
  /// [containerDirection] specifies the location of the tab view.
  /// For the left tab view, set it to [PlutoLayoutContainerDirection.left].
  ///
  /// [tabItemId] is the [PlutoLayoutTabItem.id] registered in the [PlutoLayoutTabs] widget.
  /// [tabItemId] must be an item registered in the [containerDirection] location.
  static PlutoLayoutActionToggleTabViewIntent toggleTabView(
    PlutoLayoutContainerDirection containerDirection,
    Object tabItemId,
  ) {
    return PlutoLayoutActionToggleTabViewIntent(containerDirection, tabItemId);
  }

  /// Opens and closes all items in the tab view
  /// corresponding to the [containerDirection] position in order.
  static PlutoLayoutActionRotateTabViewIntent rotateTabView(
    PlutoLayoutContainerDirection containerDirection,
  ) {
    return PlutoLayoutActionRotateTabViewIntent(containerDirection);
  }

  /// Increase the size of the tab view
  /// corresponding to the [containerDirection] position by a specific pixel.
  ///
  /// If [containerDirection] is null,
  /// adjust the position of the currently focused container.
  /// If no tab views are open, no action is taken.
  static PlutoLayoutActionIncreaseTabViewIntent increaseTabView([
    PlutoLayoutContainerDirection? containerDirection,
  ]) {
    return PlutoLayoutActionIncreaseTabViewIntent(containerDirection);
  }

  /// Decrease the size of the tab view
  /// corresponding to the [containerDirection] position by a specific pixel.
  ///
  /// If [containerDirection] is null,
  /// adjust the position of the currently focused container.
  /// If no tab views are open, no action is taken.
  static PlutoLayoutActionDecreaseTabViewIntent decreaseTabView([
    PlutoLayoutContainerDirection? containerDirection,
  ]) {
    return PlutoLayoutActionDecreaseTabViewIntent(containerDirection);
  }
}

abstract class PlutoLayoutIntent extends Intent {
  const PlutoLayoutIntent();
}

abstract class PlutoLayoutAction<T extends PlutoLayoutIntent>
    extends Action<T> {
  PlutoLayoutAction(this.events);

  final PublishSubject<PlutoLayoutEvent> events;
}
