import 'package:pluto_layout/pluto_layout.dart';

import 'events.dart';

class PlutoRotateTabViewEvent extends PlutoLayoutEvent {
  const PlutoRotateTabViewEvent(this.containerDirection);

  final PlutoLayoutContainerDirection containerDirection;
}
