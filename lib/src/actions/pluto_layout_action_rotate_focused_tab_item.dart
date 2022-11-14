import 'package:pluto_layout/pluto_layout.dart';

/// {@template pluto_layout_action_rotate_focused_tab_item_intent}
/// Move the focus of the tab item located at [layoutId] in order.
///
/// If [layoutId] is null, the currently focused id is selected.
/// If there is no current focused id
/// or there is no [PlutoLayoutTabs] in the focused area,
/// no action is taken.
///
/// If [reverse] is true, reverse the focus order.
/// {@endtemplate}
class PlutoLayoutActionRotateFocusedTabItemIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionRotateFocusedTabItemIntent({
    this.layoutId,
    this.reverse = false,
    super.actionsOnlyPrimaryFocus = true,
  });

  final PlutoLayoutId? layoutId;

  final bool reverse;
}

class PlutoLayoutActionRotateFocusedTabItemAction
    extends PlutoLayoutAction<PlutoLayoutActionRotateFocusedTabItemIntent> {
  PlutoLayoutActionRotateFocusedTabItemAction(super.events, super.focusNode);

  @override
  void invoke(PlutoLayoutActionRotateFocusedTabItemIntent intent) {
    events.add(PlutoRotateFocusedTabItemEvent(
      layoutId: intent.layoutId,
      reverse: intent.reverse,
    ));
  }
}
