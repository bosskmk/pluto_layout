import 'package:pluto_layout/pluto_layout.dart';

/// {@macro pluto_layout_action_increase_tab_view_intent}
class PlutoIncreaseTabViewEvent extends PlutoLayoutEvent
    implements PlutoLayoutInDecreaseTabViewEvent {
  const PlutoIncreaseTabViewEvent(
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

abstract class PlutoLayoutInDecreaseTabViewEvent {
  PlutoLayoutId? get layoutId;

  double get size;

  bool get reverseByDirection;

  static const double defaultSize = 10.0;
}
