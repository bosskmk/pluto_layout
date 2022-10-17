import 'package:pluto_layout/pluto_layout.dart';

class PlutoToggleTabViewEvent extends PlutoLayoutEvent {
  PlutoToggleTabViewEvent(this.containerDirection, this.tabItemId);

  final PlutoLayoutContainerDirection containerDirection;

  final Object tabItemId;
}
