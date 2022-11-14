import 'package:pluto_layout/pluto_layout.dart';

/// {@macro pluto_layout_action_insert_tab_item_intent}
class PlutoInsertTabItemEvent extends PlutoLayoutEvent {
  const PlutoInsertTabItemEvent({
    this.layoutId,
    required this.itemResolver,
  });

  final PlutoLayoutId? layoutId;

  final PlutoLayoutActionInsertTabItemResolver itemResolver;
}
