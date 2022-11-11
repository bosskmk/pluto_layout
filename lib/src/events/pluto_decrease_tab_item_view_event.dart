import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_layout/src/events/events.dart';

/// Event to decrease the size of [itemId] located in [layoutId] by [size].
///
/// The [reverseByDirection] property is a property to operate the size
/// of the right and left or top and bottom tab views
/// according to the logic with one direction key.
///
/// For more information, please refer to the link below.
/// https://pluto.weblaze.dev/introduction-to-plutlayout
class PlutoDecreaseTabItemViewEvent extends PlutoLayoutEvent
    implements PlutoLayoutInDecreaseTabItemViewEvent {
  const PlutoDecreaseTabItemViewEvent({
    this.layoutId,
    this.itemId,
    this.size = PlutoLayoutInDecreaseTabItemViewEvent.defaultSize,
    this.reverseByDirection = false,
  });

  @override
  final PlutoLayoutId? layoutId;

  @override
  final Object? itemId;

  @override
  final double size;

  @override
  final bool reverseByDirection;
}
