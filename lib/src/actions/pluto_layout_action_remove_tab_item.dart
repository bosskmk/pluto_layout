import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_layout/src/events/events.dart';

/// {@template pluto_layout_action_remove_tab_item_intent}
/// Remove [itemId] located in [layoutId].
///
/// If [layoutId] and [itemId] are null,
/// the focused tab is removed if there is a focused tab.
/// {@endtemplate}
class PlutoLayoutActionRemoveTabItemIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionRemoveTabItemIntent(
    this.layoutId,
    this.itemId, {
    super.actionsOnlyPrimaryFocus = true,
  });

  final PlutoLayoutId? layoutId;

  final Object? itemId;
}

class PlutoLayoutActionRemoveTabItemAction
    extends PlutoLayoutAction<PlutoLayoutActionRemoveTabItemIntent> {
  PlutoLayoutActionRemoveTabItemAction(super.events, super.focusNode);

  @override
  void invoke(PlutoLayoutActionRemoveTabItemIntent intent) {
    events.add(PlutoRemoveTabItemEvent(
      intent.layoutId,
      intent.itemId,
    ));
  }
}
