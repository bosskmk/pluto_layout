import 'package:pluto_layout/pluto_layout.dart';

import '../events/events.dart';

/// {@template pluto_layout_action_increase_tab_view_intent}
/// Increase the size of the tab view
/// corresponding to the [containerDirection] position by a specific pixel.
///
/// If [containerDirection] is null,
/// adjust the position of the currently focused container.
/// If no tab views are open, no action is taken.
///
/// [size] is the size to change in one call.
///
/// [reverseByDirection] converts the increment
/// to a negative number depending on the direction.
/// In the state where [containerDirection] is not specified,
/// use left, right or top, bottom with one arrow key
/// to increase the size according to the direction.
/// {@endtemplate}
class PlutoLayoutActionIncreaseTabViewIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionIncreaseTabViewIntent(
    this.containerDirection, {
    this.size = PlutoLayoutHasInDecreaseTabViewEvent.defaultSize,
    this.reverseByDirection = false,
  }) : assert(size > 0);

  final PlutoLayoutContainerDirection? containerDirection;

  final double size;

  final bool reverseByDirection;
}

class PlutoLayoutActionIncreaseTabViewAction
    extends PlutoLayoutAction<PlutoLayoutActionIncreaseTabViewIntent> {
  PlutoLayoutActionIncreaseTabViewAction(super.events);

  @override
  void invoke(PlutoLayoutActionIncreaseTabViewIntent intent) {
    events.add(PlutoIncreaseTabViewEvent(
      intent.containerDirection,
      size: intent.size,
      reverseByDirection: intent.reverseByDirection,
    ));
  }
}
