import 'package:pluto_layout/pluto_layout.dart';

class PlutoLayoutActionDecreaseTabViewIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionDecreaseTabViewIntent(
    this.containerDirection,
  );

  final PlutoLayoutContainerDirection? containerDirection;
}

class PlutoLayoutActionDecreaseTabViewAction
    extends PlutoLayoutAction<PlutoLayoutActionDecreaseTabViewIntent> {
  PlutoLayoutActionDecreaseTabViewAction(super.events);

  @override
  Object? invoke(PlutoLayoutActionDecreaseTabViewIntent intent) {
    events.add(PlutoDecreaseTabViewEvent(
      intent.containerDirection,
    ));
    return null;
  }
}
