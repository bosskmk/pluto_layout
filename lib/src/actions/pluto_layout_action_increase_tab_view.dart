import 'package:pluto_layout/pluto_layout.dart';

class PlutoLayoutActionIncreaseTabViewIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionIncreaseTabViewIntent(
    this.containerDirection,
  );

  final PlutoLayoutContainerDirection? containerDirection;
}

class PlutoLayoutActionIncreaseTabViewAction
    extends PlutoLayoutAction<PlutoLayoutActionIncreaseTabViewIntent> {
  PlutoLayoutActionIncreaseTabViewAction(super.events);

  @override
  Object? invoke(PlutoLayoutActionIncreaseTabViewIntent intent) {
    events.add(PlutoIncreaseTabViewEvent(
      intent.containerDirection,
    ));
    return null;
  }
}
