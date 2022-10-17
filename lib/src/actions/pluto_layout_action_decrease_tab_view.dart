import 'package:pluto_layout/pluto_layout.dart';

class PlutoLayoutActionDecreaseTabViewIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionDecreaseTabViewIntent(
    this.containerDirection, {
    this.size = PlutoLayoutHasInDecreaseTabViewEvent.defaultSize,
    this.reverseByDirection = false,
  }) : assert(size > 0);

  final PlutoLayoutContainerDirection? containerDirection;

  final double size;

  final bool reverseByDirection;
}

class PlutoLayoutActionDecreaseTabViewAction
    extends PlutoLayoutAction<PlutoLayoutActionDecreaseTabViewIntent> {
  PlutoLayoutActionDecreaseTabViewAction(super.events);

  @override
  void invoke(PlutoLayoutActionDecreaseTabViewIntent intent) {
    events.add(PlutoDecreaseTabViewEvent(
      intent.containerDirection,
      size: intent.size,
      reverseByDirection: intent.reverseByDirection,
    ));
  }
}
