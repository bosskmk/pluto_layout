import 'package:pluto_layout/pluto_layout.dart';

import 'events.dart';

/// Event to toggle the tab view of [itemId] in [layoutId].
///
/// If [layoutId], [itemId] are null, the currently focused id is selected.
/// If there is no focused id, no action is taken.
class PlutoToggleTabViewEvent extends PlutoLayoutEvent {
  const PlutoToggleTabViewEvent({this.layoutId, this.itemId});

  final PlutoLayoutId? layoutId;

  final Object? itemId;
}
