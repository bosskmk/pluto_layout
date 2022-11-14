import 'package:pluto_layout/pluto_layout.dart';

/// {@template pluto_layout_action_increase_tab_view_intent}
/// Increase the size of the tab view
/// corresponding to the [layoutId] position by a specific pixel.
///
/// If [layoutId] is null,
/// adjust the position of the currently focused container.
/// If no tab views are open, no action is taken.
///
/// [size] is the size to change in one call.
///
/// [reverseByDirection] converts the increment
/// to a negative number depending on the direction.
/// In the state where [layoutId] is not specified,
/// use left, right or top, bottom with one arrow key
/// to increase the size according to the direction.
///
/// For more information, please refer to the link below.
/// https://pluto.weblaze.dev/introduction-to-plutlayout
/// {@endtemplate}
class PlutoLayoutActionIncreaseTabViewIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionIncreaseTabViewIntent(
    this.layoutId, {
    this.size = PlutoLayoutInDecreaseTabViewEvent.defaultSize,
    this.reverseByDirection = false,
    super.actionsOnlyPrimaryFocus = true,
  }) : assert(size > 0);

  final PlutoLayoutId? layoutId;

  final double size;

  final bool reverseByDirection;
}

class PlutoLayoutActionIncreaseTabViewAction
    extends PlutoLayoutAction<PlutoLayoutActionIncreaseTabViewIntent> {
  PlutoLayoutActionIncreaseTabViewAction(super.events, super.focusNode);

  @override
  void invoke(PlutoLayoutActionIncreaseTabViewIntent intent) {
    events.add(PlutoIncreaseTabViewEvent(
      intent.layoutId,
      size: intent.size,
      reverseByDirection: intent.reverseByDirection,
    ));
  }
}
