import 'package:pluto_layout/pluto_layout.dart';

import 'events.dart';

/// Event to toggle the tab view of [tabItemId] in [containerDirection].
class PlutoToggleTabViewEvent extends PlutoLayoutEvent {
  const PlutoToggleTabViewEvent(this.containerDirection, this.tabItemId);

  final PlutoLayoutContainerDirection containerDirection;

  final Object tabItemId;
}
