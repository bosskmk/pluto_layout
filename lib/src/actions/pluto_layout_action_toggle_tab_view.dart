import 'package:pluto_layout/pluto_layout.dart';

import '../events/events.dart';

/// {@template pluto_layout_action_toggle_tab_view_intent}
/// Toggles the tab view corresponding to [tabItemId].
///
/// [containerDirection] specifies the location of the tab view.
/// For the left tab view, set it to [PlutoLayoutContainerDirection.left].
///
/// [tabItemId] is the [PlutoLayoutTabItem.id] registered in the [PlutoLayoutTabs] widget.
/// [tabItemId] must be an item registered in the [containerDirection] location.
/// {@endtemplate}
class PlutoLayoutActionToggleTabViewIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionToggleTabViewIntent(
    this.containerDirection,
    this.tabItemId,
  );

  final PlutoLayoutContainerDirection containerDirection;

  final Object tabItemId;
}

class PlutoLayoutActionToggleTabViewAction
    extends PlutoLayoutAction<PlutoLayoutActionToggleTabViewIntent> {
  PlutoLayoutActionToggleTabViewAction(super.events);

  @override
  void invoke(PlutoLayoutActionToggleTabViewIntent intent) {
    events.add(PlutoToggleTabViewEvent(
      intent.containerDirection,
      intent.tabItemId,
    ));
  }
}
