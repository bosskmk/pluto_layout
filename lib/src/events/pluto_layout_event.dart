import 'package:pluto_layout/pluto_layout.dart';

abstract class PlutoLayoutEvent {}

abstract class PlutoLayoutHasContainerDirection {
  PlutoLayoutContainerDirection? get containerDirection;
}
