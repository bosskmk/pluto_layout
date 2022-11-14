import 'package:pluto_layout/pluto_layout.dart';

/// Callback method for adding a new tab.
///
/// [items] List of existing [PlutoLayoutTabItem] of tabs to add.
typedef PlutoLayoutActionInsertTabItemResolver = PlutoInsertTabItemResult
    Function({
  required List<PlutoLayoutTabItem> items,
});

/// The return value of the callback to add a new tab
///
/// [index] specifies the index frame where [item] will be added.
/// If no value is specified, it is appended to the end of the tab.
///
/// [item] is the [PlutoLayoutTabItem] to add.
class PlutoInsertTabItemResult {
  const PlutoInsertTabItemResult({
    this.index,
    required this.item,
  });

  final int? index;

  final PlutoLayoutTabItem item;
}

/// {@template pluto_layout_action_insert_tab_item_intent}
/// Add a new tab.
///
/// [layoutId] is the area where the tab will be added.
/// If no value is specified, it is added to the currently focused area.
///
/// [itemResolver] is a callback method for adding a tab.
/// {@endtemplate}
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
