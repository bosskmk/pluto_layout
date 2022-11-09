import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_layout/src/events/events.dart';

/// Event to delete [itemId] located in [layoutId].
class PlutoRemoveTabItemEvent extends PlutoLayoutEvent {
  const PlutoRemoveTabItemEvent(this.layoutId, this.itemId);

  final PlutoLayoutId layoutId;

  final Object itemId;
}
