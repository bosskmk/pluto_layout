import 'package:pluto_layout/pluto_layout.dart';

import '../events/events.dart';

/// {@template pluto_layout_action_toggle_tab_view_intent}
/// Toggles the tab view corresponding to [itemId].
///
/// [layoutId] specifies the location of the tab view.
/// For the left tab view, set it to [PlutoLayoutContainerDirection.left].
///
/// [itemId] is the [PlutoLayoutTabItem.id] registered in the [PlutoLayoutTabs] widget.
/// [itemId] must be an item registered in the [layoutId] location.
///
/// If [layoutId], [itemId] are null, the currently focused id is selected.
/// If there is no focused id, no action is taken.
/// {@endtemplate}
class PlutoLayoutActionToggleTabViewIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionToggleTabViewIntent({
    this.layoutId,
    this.itemId,
  });

  final PlutoLayoutId? layoutId;

  final Object? itemId;
}

class PlutoLayoutActionToggleTabViewAction
    extends PlutoLayoutAction<PlutoLayoutActionToggleTabViewIntent> {
  PlutoLayoutActionToggleTabViewAction(super.events);

  @override
  void invoke(PlutoLayoutActionToggleTabViewIntent intent) {
    events.add(PlutoToggleTabViewEvent(
      layoutId: intent.layoutId,
      itemId: intent.itemId,
    ));
  }
}
