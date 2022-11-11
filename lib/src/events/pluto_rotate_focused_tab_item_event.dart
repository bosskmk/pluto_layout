import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_layout/src/events/events.dart';

/// Move the focus of the tab item located at [layoutId] in order.
///
/// If [layoutId] is null, the currently focused id is selected.
///
/// If there is no [PlutoLayoutTabs] in that location, no action is taken.
class PlutoRotateFocusedTabItemEvent extends PlutoLayoutEvent {
  const PlutoRotateFocusedTabItemEvent({
    this.layoutId,
    this.reverse = false,
  });

  final PlutoLayoutId? layoutId;

  final bool reverse;
}
