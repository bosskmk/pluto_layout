import 'events.dart';

/// Event to close all tabviews.
///
/// If [afterFocusToBody] is true,
/// the body container requests focus after the tab view is closed.
class PlutoHideAllTabViewEvent extends PlutoLayoutEvent {
  const PlutoHideAllTabViewEvent({
    this.afterFocusToBody = true,
  });

  final bool afterFocusToBody;
}
