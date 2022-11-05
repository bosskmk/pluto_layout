import 'package:pluto_layout/pluto_layout.dart';

import 'events.dart';

/// Event that reduces the size of the tab view in the [containerDirection] direction by [size].
///
/// The [reverseByDirection] property is a property to operate the size
/// of the right and left or top and bottom tab views
/// according to the logic with one direction key.
///
/// For more information, please refer to the link below.
/// https://pluto.weblaze.dev/introduction-to-plutlayout
class PlutoDecreaseTabViewEvent extends PlutoLayoutEvent
    implements PlutoLayoutHasInDecreaseTabViewEvent {
  const PlutoDecreaseTabViewEvent(
    this.containerDirection, {
    this.size = PlutoLayoutHasInDecreaseTabViewEvent.defaultSize,
    this.reverseByDirection = false,
  });

  @override
  final PlutoLayoutContainerDirection? containerDirection;

  @override
  final double size;

  @override
  final bool reverseByDirection;
}
