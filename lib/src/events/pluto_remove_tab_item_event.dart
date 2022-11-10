import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_layout/src/events/events.dart';

/// Event to delete [itemId] located in [layoutId].
///
/// If [layoutId] and [itemId] are null,
/// the focused tab is removed if there is a focused tab.
class PlutoRemoveTabItemEvent extends PlutoLayoutEvent {
  const PlutoRemoveTabItemEvent(this.layoutId, this.itemId);

  final PlutoLayoutId? layoutId;

  final Object? itemId;
}
