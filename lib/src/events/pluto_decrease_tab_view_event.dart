import 'package:pluto_layout/pluto_layout.dart';

class PlutoDecreaseTabViewEvent extends PlutoLayoutEvent
    implements PlutoLayoutHasContainerDirection {
  PlutoDecreaseTabViewEvent(this.containerDirection);

  @override
  final PlutoLayoutContainerDirection? containerDirection;
}
