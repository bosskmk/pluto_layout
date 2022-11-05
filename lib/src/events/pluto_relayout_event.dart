import 'events.dart';

/// Event to reset the layout
/// when the size of the parent widget of [Pluto Layout] is changed.
class PlutoRelayoutEvent extends PlutoLayoutEvent {
  const PlutoRelayoutEvent();
}
