part of pluto_layout_tabs;

class _ItemsNotifier extends StateNotifier<List<PlutoLayoutTabItem>> {
  _ItemsNotifier(List<PlutoLayoutTabItem> items) : super(items);

  void setEnabled(
    Object id,
    bool flag,
    PlutoLayoutTabMode mode, {
    bool? forceShowOne,
  }) {
    PlutoLayoutTabItem disableOrNot(PlutoLayoutTabItem item) {
      if (mode.isShowOneMode || forceShowOne == true) {
        return item.copyWith(enabled: false);
      } else {
        return item;
      }
    }

    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(enabled: flag) else disableOrNot(item),
    ];
  }

  void toggleAll(bool flag, PlutoLayoutTabMode mode) {
    if (mode.isShowOneMust) return;

    state = [
      for (final item in state)
        if (item.enabled == flag) item else item.copyWith(enabled: flag),
    ];
  }

  void insert(int index, PlutoLayoutTabItem item) {
    state.insert(index, item);
    state = [...state];
  }

  void remove(Object id) {
    state = [
      for (final e in state)
        if (id != e.id) e,
    ];
  }
}

final _itemsProvider =
    StateNotifierProvider<_ItemsNotifier, List<PlutoLayoutTabItem>>((ref) {
  return _ItemsNotifier([]);
});
