import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_layout/src/events/events.dart';

typedef PlutoLayoutActionInsertTabItemResolver = PlutoInsertTabItemResult
    Function({
  required List<PlutoLayoutTabItem> items,
});

class PlutoInsertTabItemResult {
  const PlutoInsertTabItemResult({
    this.index,
    required this.item,
  });

  final int? index;

  final PlutoLayoutTabItem item;
}

class PlutoLayoutActionInsertTabItemIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionInsertTabItemIntent({
    this.layoutId,
    required this.itemResolver,
    super.actionsOnlyPrimaryFocus = true,
  });

  final PlutoLayoutId? layoutId;

  final PlutoLayoutActionInsertTabItemResolver itemResolver;
}

class PlutoLayoutActionInsertTabItemAction
    extends PlutoLayoutAction<PlutoLayoutActionInsertTabItemIntent> {
  PlutoLayoutActionInsertTabItemAction(super.events, super.focusNode);

  @override
  void invoke(PlutoLayoutActionInsertTabItemIntent intent) {
    events.add(PlutoInsertTabItemEvent(
      layoutId: intent.layoutId,
      itemResolver: intent.itemResolver,
    ));
  }
}
