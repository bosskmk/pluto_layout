import 'package:pluto_layout/pluto_layout.dart';

import 'events.dart';

/// Event to open and close tab views of [containerDirection] in order.
class PlutoRotateTabViewEvent extends PlutoLayoutEvent {
  const PlutoRotateTabViewEvent(this.containerDirection);

  final PlutoLayoutContainerDirection containerDirection;
}
