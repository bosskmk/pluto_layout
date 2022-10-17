import 'package:flutter/cupertino.dart';
import 'package:pluto_layout/pluto_layout.dart';
import 'package:rxdart/rxdart.dart';

class PlutoLayoutActions {
  static PlutoLayoutActionHideAllTabViewIntent hideAllTabView({
    bool afterFocusToBody = true,
  }) {
    return PlutoLayoutActionHideAllTabViewIntent(
      afterFocusToBody: afterFocusToBody,
    );
  }

  static PlutoLayoutActionToggleTabViewIntent toggleTabView(
    PlutoLayoutContainerDirection containerDirection,
    Object tabItemId,
  ) {
    return PlutoLayoutActionToggleTabViewIntent(containerDirection, tabItemId);
  }

  static PlutoLayoutActionRotateTabViewIntent rotateTabView(
    PlutoLayoutContainerDirection containerDirection,
  ) {
    return PlutoLayoutActionRotateTabViewIntent(containerDirection);
  }

  static PlutoLayoutActionIncreaseTabViewIntent increaseTabView([
    PlutoLayoutContainerDirection? containerDirection,
  ]) {
    return PlutoLayoutActionIncreaseTabViewIntent(containerDirection);
  }

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
