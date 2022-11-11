import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_layout/src/events/events.dart';

/// Move the focus of [PlutoLayoutContainer] in the order of [order].
///
/// If [reverse] is true, move the focus in the reverse order.
class PlutoRotateFocusedContainerEvent extends PlutoLayoutEvent {
  const PlutoRotateFocusedContainerEvent({
    this.reverse = false,
    this.order = PlutoLayoutId.values,
  });

  final bool reverse;

  final List<PlutoLayoutId> order;
}
