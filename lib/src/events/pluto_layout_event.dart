import 'package:pluto_layout/pluto_layout.dart';

abstract class PlutoLayoutEvent {
  const PlutoLayoutEvent();
}

abstract class PlutoLayoutHasInDecreaseTabViewEvent {
  PlutoLayoutContainerDirection? get containerDirection;

  double get size;

  bool get reverseByDirection;

  static const double defaultSize = 10.0;
}
