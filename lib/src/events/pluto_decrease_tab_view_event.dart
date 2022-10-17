import 'package:pluto_layout/pluto_layout.dart';

class PlutoDecreaseTabViewEvent extends PlutoLayoutEvent
    implements PlutoLayoutHasInDecreaseTabViewEvent {
  const PlutoDecreaseTabViewEvent(
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
