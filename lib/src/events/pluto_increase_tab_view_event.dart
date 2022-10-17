import 'package:pluto_layout/pluto_layout.dart';

class PlutoIncreaseTabViewEvent extends PlutoLayoutEvent
    implements PlutoLayoutHasContainerDirection {
  PlutoIncreaseTabViewEvent(this.containerDirection);

  @override
  final PlutoLayoutContainerDirection? containerDirection;
}
