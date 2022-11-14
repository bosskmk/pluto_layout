part of pluto_layout_tabs;

/// Renders a tab or widget that fills the [PlutoLayoutContainer].
///
/// If [items] exists, render tab otherwise [child].
class PlutoLayoutTabsOrChild extends StatelessWidget {
  const PlutoLayoutTabsOrChild({
    this.items,
    this.draggable = true,
    this.child,
    super.key,
  });

  final List<PlutoLayoutTabItem>? items;

  final bool draggable;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        _itemsProvider.overrideWith(
          (ref) => _ItemsNotifier(items ?? []),
        ),
      ],
      child: Consumer(
        builder: (innerContext, ref, innerChild) {
          final items = ref.watch(_itemsProvider);

          final hasItems = items.isNotEmpty;

          final tabs = PlutoLayoutTabs._givenItemsProvider(
            mode: PlutoLayoutTabMode.showOneMust,
            draggable: draggable,
            expanded: hasItems,
            items: items,
          );

          if (hasItems) return tabs;

          return Column(
            children: [
              tabs,
              Expanded(child: innerChild ?? const SizedBox.shrink()),
            ],
          );
        },
        child: child,
      ),
    );
  }
}
