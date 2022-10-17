import 'package:pluto_layout/pluto_layout.dart';

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
