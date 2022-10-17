import 'package:pluto_layout/pluto_layout.dart';

class PlutoLayoutActionIncreaseTabViewIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionIncreaseTabViewIntent(
    this.containerDirection, {
    this.size = PlutoLayoutHasInDecreaseTabViewEvent.defaultSize,
    this.reverseByDirection = false,
  }) : assert(size > 0);

  final PlutoLayoutContainerDirection? containerDirection;

  final double size;

  final bool reverseByDirection;
}

class PlutoLayoutActionIncreaseTabViewAction
    extends PlutoLayoutAction<PlutoLayoutActionIncreaseTabViewIntent> {
  PlutoLayoutActionIncreaseTabViewAction(super.events);

  @override
  void invoke(PlutoLayoutActionIncreaseTabViewIntent intent) {
    events.add(PlutoIncreaseTabViewEvent(
      intent.containerDirection,
      size: intent.size,
      reverseByDirection: intent.reverseByDirection,
    ));
  }
}
