import 'package:pluto_layout/pluto_layout.dart';

class PlutoLayoutActionHideAllTabViewIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionHideAllTabViewIntent({
    this.afterFocusToBody = true,
  });

  final bool afterFocusToBody;
}

class PlutoLayoutActionHideAllTabViewAction
    extends PlutoLayoutAction<PlutoLayoutActionHideAllTabViewIntent> {
  PlutoLayoutActionHideAllTabViewAction(super.events);

  @override
  void invoke(PlutoLayoutActionHideAllTabViewIntent intent) {
    events.add(PlutoHideAllTabViewEvent(
      afterFocusToBody: intent.afterFocusToBody,
    ));
  }
}
