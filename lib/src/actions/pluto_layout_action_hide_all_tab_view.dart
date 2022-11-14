import 'package:pluto_layout/pluto_layout.dart';

/// {@template pluto_layout_action_hide_all_tab_view_intent}
/// Close all tabviews.
///
/// If [afterFocusToBody] is true,
/// close all tabviews and the body container gets focus.
/// {@endtemplate}
class PlutoLayoutActionHideAllTabViewIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionHideAllTabViewIntent({
    this.afterFocusToBody = true,
    super.actionsOnlyPrimaryFocus = true,
  });

  final bool afterFocusToBody;
}

class PlutoLayoutActionHideAllTabViewAction
    extends PlutoLayoutAction<PlutoLayoutActionHideAllTabViewIntent> {
  PlutoLayoutActionHideAllTabViewAction(super.events, super.focusNode);

  @override
  void invoke(PlutoLayoutActionHideAllTabViewIntent intent) {
    events.add(PlutoHideAllTabViewEvent(
      afterFocusToBody: intent.afterFocusToBody,
    ));
  }
}
