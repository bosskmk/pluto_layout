import 'package:pluto_layout/pluto_layout.dart';

/// {@macro pluto_layout_action_increase_tab_item_view_intent}
class PlutoIncreaseTabItemViewEvent extends PlutoLayoutEvent
    implements PlutoLayoutInDecreaseTabItemViewEvent {
  const PlutoIncreaseTabItemViewEvent({
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

abstract class PlutoLayoutInDecreaseTabItemViewEvent {
  PlutoLayoutId? get layoutId;

  Object? get itemId;

  double get size;

  bool get reverseByDirection;

  static const double defaultSize = 10.0;
}
