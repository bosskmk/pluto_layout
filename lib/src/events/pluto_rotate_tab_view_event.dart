import 'package:pluto_layout/pluto_layout.dart';

class PlutoRotateTabViewEvent extends PlutoLayoutEvent {
  PlutoRotateTabViewEvent(this.containerDirection);

  final PlutoLayoutContainerDirection containerDirection;
}
