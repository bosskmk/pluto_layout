import 'package:pluto_layout/pluto_layout.dart';

import '../events/events.dart';

/// {@template pluto_layout_action_decrease_tab_view_intent}
/// Decrease the size of the tab view
/// corresponding to the [layoutId] position by a specific pixel.
///
/// If [layoutId] is null,
/// Adjust the size of the currently focused container.
/// If no tab views are open, no action is taken.
///
/// [size] is the size to change in one call.
///
/// [reverseByDirection] converts the decrease
/// to a negative number depending on the direction.
/// In the state where [layoutId] is not specified,
/// use left, right or top, bottom with one arrow key
/// to decrease the size according to the direction.
/// {@endtemplate}
class PlutoLayoutActionDecreaseTabViewIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionDecreaseTabViewIntent(
    this.layoutId, {
    this.size = PlutoLayoutInDecreaseTabViewEvent.defaultSize,
    this.reverseByDirection = false,
  }) : assert(size > 0);

  final PlutoLayoutId? layoutId;

  final double size;

  final bool reverseByDirection;
}

class PlutoLayoutActionDecreaseTabViewAction
    extends PlutoLayoutAction<PlutoLayoutActionDecreaseTabViewIntent> {
  PlutoLayoutActionDecreaseTabViewAction(super.events);

  @override
  void invoke(PlutoLayoutActionDecreaseTabViewIntent intent) {
    events.add(PlutoDecreaseTabViewEvent(
      intent.layoutId,
      size: intent.size,
      reverseByDirection: intent.reverseByDirection,
    ));
  }
}
