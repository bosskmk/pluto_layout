import 'package:pluto_layout/pluto_layout.dart';

/// {@template pluto_layout_action_rotate_tab_view_intent}
/// Opens and closes all items in the tab view
/// corresponding to the [layoutId] position in order.
/// {@endtemplate}
class PlutoLayoutActionRotateTabViewIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionRotateTabViewIntent(
    this.layoutId, {
    super.actionsOnlyPrimaryFocus = true,
  });

  final PlutoLayoutId layoutId;
}

class PlutoLayoutActionRotateTabViewAction
    extends PlutoLayoutAction<PlutoLayoutActionRotateTabViewIntent> {
  PlutoLayoutActionRotateTabViewAction(super.events, super.focusNode);

  @override
  void invoke(PlutoLayoutActionRotateTabViewIntent intent) {
    events.add(PlutoRotateTabViewEvent(
      intent.layoutId,
    ));
  }
}
