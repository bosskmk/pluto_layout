import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_layout/src/events/events.dart';

class PlutoInsertTabItemEvent extends PlutoLayoutEvent {
  const PlutoInsertTabItemEvent({
    this.layoutId,
    required this.itemResolver,
  });

  final PlutoLayoutId? layoutId;

  final PlutoLayoutActionInsertTabItemResolver itemResolver;
}
