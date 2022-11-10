import 'package:pluto_layout/pluto_layout.dart';

import 'events.dart';

/// Event to open and close tab views of [layoutId] in order.
class PlutoRotateTabViewEvent extends PlutoLayoutEvent {
  const PlutoRotateTabViewEvent(this.layoutId);

  final PlutoLayoutId layoutId;
}
