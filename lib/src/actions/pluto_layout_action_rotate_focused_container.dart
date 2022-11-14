import 'package:pluto_layout/pluto_layout.dart';

/// {@template pluto_layout_action_rotate_focused_container_intent}
/// Move the focus of [PlutoLayoutContainer] in order.
/// The default movement order is
/// [PlutoLayout.top],
/// [PlutoLayout.left],
/// [PlutoLayout.body],
/// [PlutoLayout.right],
/// [PlutoLayout.bottom].
///
/// [order] can be passed by changing the order of [PlutoLayoutId].
/// Containers not specified in [order] are excluded from the focus list.
///
/// If [reverse] is true, move the focus in the reverse order.
/// {@endtemplate}
class PlutoLayoutActionRotateFocusedContainerIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionRotateFocusedContainerIntent({
    this.reverse = false,
    this.order = PlutoLayoutId.values,
    super.actionsOnlyPrimaryFocus = true,
  });

  final bool reverse;

  final List<PlutoLayoutId> order;
}

class PlutoLayoutActionRotateFocusedContainerAction
    extends PlutoLayoutAction<PlutoLayoutActionRotateFocusedContainerIntent> {
  PlutoLayoutActionRotateFocusedContainerAction(super.events, super.focusNode);

  @override
  void invoke(PlutoLayoutActionRotateFocusedContainerIntent intent) {
    events.add(PlutoRotateFocusedContainerEvent(
      reverse: intent.reverse,
      order: intent.order,
    ));
  }
}
