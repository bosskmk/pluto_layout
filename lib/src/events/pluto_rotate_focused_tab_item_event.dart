import 'package:pluto_layout/pluto_layout.dart';

/// {@macro pluto_layout_action_rotate_focused_tab_item_intent}
class PlutoRotateFocusedTabItemEvent extends PlutoLayoutEvent {
  const PlutoRotateFocusedTabItemEvent({
    this.layoutId,
    this.reverse = false,
  });

  final PlutoLayoutId? layoutId;

  final bool reverse;
}
