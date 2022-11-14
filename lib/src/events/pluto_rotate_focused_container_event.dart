import 'package:pluto_layout/pluto_layout.dart';

/// {@macro pluto_layout_action_rotate_focused_container_intent}
class PlutoRotateFocusedContainerEvent extends PlutoLayoutEvent {
  const PlutoRotateFocusedContainerEvent({
    this.reverse = false,
    this.order = PlutoLayoutId.values,
  });

  final bool reverse;

  final List<PlutoLayoutId> order;
}
