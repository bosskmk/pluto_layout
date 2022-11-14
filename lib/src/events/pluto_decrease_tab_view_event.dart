import 'package:pluto_layout/pluto_layout.dart';

/// {@macro pluto_layout_action_decrease_tab_view_intent}
class PlutoDecreaseTabViewEvent extends PlutoLayoutEvent
    implements PlutoLayoutInDecreaseTabViewEvent {
  const PlutoDecreaseTabViewEvent(
    this.layoutId, {
    this.size = PlutoLayoutInDecreaseTabViewEvent.defaultSize,
    this.reverseByDirection = false,
  });

  @override
  final PlutoLayoutId? layoutId;

  @override
  final double size;

  @override
  final bool reverseByDirection;
}
