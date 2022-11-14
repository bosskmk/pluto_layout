import 'package:pluto_layout/pluto_layout.dart';

/// {@macro pluto_layout_action_remove_tab_item_intent}
class PlutoRemoveTabItemEvent extends PlutoLayoutEvent {
  const PlutoRemoveTabItemEvent(this.layoutId, this.itemId);

  final PlutoLayoutId? layoutId;

  final Object? itemId;
}
