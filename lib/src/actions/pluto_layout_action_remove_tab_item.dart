import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_layout/src/events/events.dart';

/// {@template pluto_layout_action_remove_tab_item_intent}
/// Remove [tabItemId] located in [layoutId].
/// {@endtemplate}
class PlutoLayoutActionRemoveTabItemIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionRemoveTabItemIntent(
    this.layoutId,
    this.tabItemId,
  );

  final PlutoLayoutId layoutId;

  final Object tabItemId;
}

class PlutoLayoutActionRemoveTabItemAction
    extends PlutoLayoutAction<PlutoLayoutActionRemoveTabItemIntent> {
  PlutoLayoutActionRemoveTabItemAction(super.events);

  @override
  void invoke(PlutoLayoutActionRemoveTabItemIntent intent) {
    events.add(PlutoRemoveTabItemEvent(
      intent.layoutId,
      intent.tabItemId,
    ));
  }
}
