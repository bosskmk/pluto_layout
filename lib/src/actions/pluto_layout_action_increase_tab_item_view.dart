import 'package:pluto_layout/pluto_layout.dart';

/// {@template pluto_layout_action_increase_tab_item_view_intent}
/// Increase the size of the tab item view of [itemId] located at [layoutId].
///
/// If [layoutId] is null,
/// Adjust the size of the currently focused container.
/// If no tab views are open, no action is taken.
///
/// If [itemId] is null,
/// Adjust the size of the currently focused tab item.
///
/// [size] is the size to change in one call.
///
/// [reverseByDirection] converts the decrease
/// to a negative number depending on the direction.
/// In the state where [layoutId] is not specified,
/// use left, right or top, bottom with one arrow key
/// to decrease the size according to the direction.
///
/// For more information, please refer to the link below.
/// https://pluto.weblaze.dev/introduction-to-plutlayout
/// {@endtemplate}
class PlutoLayoutActionIncreaseTabItemViewIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionIncreaseTabItemViewIntent({
    this.layoutId,
    this.itemId,
    this.size = PlutoLayoutInDecreaseTabItemViewEvent.defaultSize,
    this.reverseByDirection = false,
    super.actionsOnlyPrimaryFocus = true,
  }) : assert(size > 0);

  final PlutoLayoutId? layoutId;

  final Object? itemId;

  final double size;

  final bool reverseByDirection;
}

class PlutoLayoutActionIncreaseTabItemViewAction
    extends PlutoLayoutAction<PlutoLayoutActionIncreaseTabItemViewIntent> {
  PlutoLayoutActionIncreaseTabItemViewAction(super.events, super.focusNode);

  @override
  void invoke(PlutoLayoutActionIncreaseTabItemViewIntent intent) {
    events.add(PlutoIncreaseTabItemViewEvent(
      layoutId: intent.layoutId,
      itemId: intent.itemId,
      size: intent.size,
      reverseByDirection: intent.reverseByDirection,
    ));
  }
}
