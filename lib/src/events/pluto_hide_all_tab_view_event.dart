import 'events.dart';

/// {@macro pluto_layout_action_hide_all_tab_view_intent}
class PlutoHideAllTabViewEvent extends PlutoLayoutEvent {
  const PlutoHideAllTabViewEvent({
    this.afterFocusToBody = true,
  });

  final bool afterFocusToBody;
}
