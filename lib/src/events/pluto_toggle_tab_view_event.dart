import 'package:pluto_layout/pluto_layout.dart';

import 'events.dart';

/// Event to toggle the tab view of [itemId] in [layoutId].
class PlutoToggleTabViewEvent extends PlutoLayoutEvent {
  const PlutoToggleTabViewEvent(this.layoutId, this.itemId);

  final PlutoLayoutId layoutId;

  final Object itemId;
}
