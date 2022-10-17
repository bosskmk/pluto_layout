import 'package:pluto_layout/pluto_layout.dart';

class PlutoIncreaseTabViewEvent extends PlutoLayoutEvent
    implements PlutoLayoutHasInDecreaseTabViewEvent {
  const PlutoIncreaseTabViewEvent(
    this.containerDirection, {
    this.size = PlutoLayoutHasInDecreaseTabViewEvent.defaultSize,
    this.reverseByDirection = false,
  });

  @override
  final PlutoLayoutContainerDirection? containerDirection;

  @override
  final double size;

  @override
  final bool reverseByDirection;
}
