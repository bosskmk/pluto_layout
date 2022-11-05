import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_layout/src/events/events.dart';

/// Event to delete [item] located in [layoutId].
class PlutoRemoveTabItemEvent extends PlutoLayoutEvent {
  const PlutoRemoveTabItemEvent(this.layoutId, this.item);

  final PlutoLayoutId layoutId;

  final PlutoLayoutTabItem item;
}
