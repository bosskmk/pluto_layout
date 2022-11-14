import 'package:pluto_layout/pluto_layout.dart';

/// {@macro pluto_layout_action_rotate_tab_view_intent}
class PlutoRotateTabViewEvent extends PlutoLayoutEvent {
  const PlutoRotateTabViewEvent(this.layoutId);

  final PlutoLayoutId layoutId;
}
