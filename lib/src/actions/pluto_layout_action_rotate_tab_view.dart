import 'package:pluto_layout/pluto_layout.dart';

class PlutoLayoutActionRotateTabViewIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionRotateTabViewIntent(
    this.containerDirection,
  );

  final PlutoLayoutContainerDirection containerDirection;
}

class PlutoLayoutActionRotateTabViewAction
    extends PlutoLayoutAction<PlutoLayoutActionRotateTabViewIntent> {
  PlutoLayoutActionRotateTabViewAction(super.events);

  @override
  Object? invoke(PlutoLayoutActionRotateTabViewIntent intent) {
    events.add(PlutoRotateTabViewEvent(
      intent.containerDirection,
    ));
    return null;
  }
}
