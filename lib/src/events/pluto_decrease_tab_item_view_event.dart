import 'package:pluto_layout/pluto_layout.dart';

/// {@macro pluto_layout_action_decrease_tab_item_view_intent}
class PlutoDecreaseTabItemViewEvent extends PlutoLayoutEvent
    implements PlutoLayoutInDecreaseTabItemViewEvent {
  const PlutoDecreaseTabItemViewEvent({
    this.layoutId,
    this.itemId,
    this.size = PlutoLayoutInDecreaseTabItemViewEvent.defaultSize,
    this.reverseByDirection = false,
  });

  @override
  final PlutoLayoutId? layoutId;

  @override
  final Object? itemId;

  @override
  final double size;

  @override
  final bool reverseByDirection;
}
