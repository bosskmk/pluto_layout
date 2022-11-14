import 'package:pluto_layout/pluto_layout.dart';

/// {@macro pluto_layout_action_toggle_tab_view_intent}
class PlutoToggleTabViewEvent extends PlutoLayoutEvent {
  const PlutoToggleTabViewEvent({this.layoutId, this.itemId});

  final PlutoLayoutId? layoutId;

  final Object? itemId;
}
