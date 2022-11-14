part of pluto_layout_tabs;

/// Class to pass to [PlutoLayoutTabs.items].
///
/// Set the information constituting the tab menu.
///
/// [id]
/// {@macro pluto_layout_tab_item_id}
///
/// [title]
/// {@macro pluto_layout_tab_item_title}
///
/// [icon]
/// {@macro pluto_layout_tab_item_icon}
///
/// [tabViewWidget]
/// {@macro pluto_layout_tab_item_tabViewWidget}
///
/// [sizeResolver]
/// {@macro pluto_layout_tab_item_sizeResolver}
///
/// [showRemoveButton]
/// {@macro pluto_layout_tab_item_showRemoveButton}
///
/// [enabled]
/// {@macro pluto_layout_tab_item_enabled}
///
/// [maintainState]
/// {@macro pluto_layout_tab_item_maintainState}
class PlutoLayoutTabItem {
  PlutoLayoutTabItem({
    required this.id,
    required this.title,
    this.icon,
    this.tabViewWidget,
    this.sizeResolver = const PlutoLayoutTabItemSizeFlexible(),
    this.showRemoveButton = false,
    this.enabled = false,
  });

  PlutoLayoutTabItem._({
    required this.id,
    required this.title,
    this.icon,
    this.tabViewWidget,
    this.sizeResolver = const PlutoLayoutTabItemSizeFlexible(),
    this.showRemoveButton = false,
    this.enabled = false,
    double? size,
  }) : _size = size ?? 0;

  /// {@template pluto_layout_tab_item_id}
  /// [id] must pass a unique value. (Usually, if the title is unique, it will be delivered.)
  /// {@endtemplate}
  final Object id;

  /// {@template pluto_layout_tab_item_title}
  /// [title] is the title of the menu to be displayed.
  /// {@endtemplate}
  final String title;

  /// {@template pluto_layout_tab_item_icon}
  /// [icon] is the icon to display before the menu title.
  /// {@endtemplate}
  final Widget? icon;

  /// {@template pluto_layout_tab_item_tabViewWidget}
  /// [tabViewWidget] is a callback function that returns a tab view widget
  /// that will be displayed when the menu is tapped.
  /// Just pass a function that returns [Widget].
  ///
  /// ```dart
  /// tabViewWidget: Padding(
  ///   padding: EdgeInsets.all(15),
  ///   child: ListView(
  ///     children: const [
  ///       Text('Example contents'),
  ///       SizedBox(height: 15),
  ///       Text('Example contents),
  ///       SizedBox(height: 10),
  ///       Text('Example contents),
  ///     ],
  ///   ),
  /// ),
  /// ```
  ///
  /// If [tabViewWidget] is a widget that implements [PlutoLayoutTabViewWidgetHasFocusNode]
  /// Call [PlutoLayoutTabViewWidgetHasFocusNode.focusNode.requestFocus] when the tab is active.
  /// {@endtemplate}
  final Widget? tabViewWidget;

  /// {@template pluto_layout_tab_item_sizeResolver}
  /// [sizeResolver] is set the size of the tab item view.
  /// {@endtemplate}
  final PlutoLayoutTabItemSizeResolver sizeResolver;

  /// {@template pluto_layout_tab_item_showRemoveButton}
  /// [showRemoveButton] displays an X button to remove a tab
  /// at the right end of the menu when the value is true.
  /// {@endtemplate}
  final bool showRemoveButton;

  /// {@template pluto_layout_tab_item_enabled}
  /// [enabled] The open and closed state of the tab view.
  /// {@endtemplate}
  final bool enabled;

  /// {@template pluto_layout_tab_item_maintainState}
  /// If [tabViewWidget.key] is [GlobalKey], the state is maintained
  /// even when the tab is closed or moved.
  /// {@endtemplate}
  bool get maintainState => tabViewWidget?.key is GlobalKey;

  /// A key to access the menu's RenderBox to change the scroll position
  /// when a menu located outside the scrollable area is focused.
  GlobalObjectKey get _menuKey => GlobalObjectKey('_Menu_$id');

  RenderBox? get _menuRenderBox =>
      _menuKey.currentContext?.findRenderObject() as RenderBox?;

  double _size = 0;

  /// [tabViewWidget] is changed to the active state,
  /// If it is a [Widget] that implements [PlutoLayoutTabViewWidgetHasFocusNode],
  /// Call [PlutoLayoutTabViewWidgetHasFocusNode.focusNode.requestFocus].
  void requestFocus() {
    if (tabViewWidget is! PlutoLayoutTabViewWidgetHasFocusNode) return;

    final focusNode =
        (tabViewWidget as PlutoLayoutTabViewWidgetHasFocusNode).focusNode;

    if (focusNode.hasFocus) return;

    focusNode.requestFocus();
  }

  /// Change the scroll position if the menu is located outside the scroll area.
  void _scrollMenuToVisible(ScrollController? scrollController) {
    if (scrollController == null) return;

    final menuRenderBox = _menuRenderBox;

    if (menuRenderBox == null) return;

    scrollController.position.ensureVisible(menuRenderBox, alignment: 0.5);
  }

  PlutoLayoutTabItem copyWith({
    Object? id,
    String? title,
    Widget? icon,
    Widget? tabViewWidget,
    PlutoLayoutTabItemSizeResolver? sizeResolver,
    bool? showRemoveButton,
    bool? enabled,
    double? size,
  }) {
    return PlutoLayoutTabItem._(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      tabViewWidget: tabViewWidget ?? this.tabViewWidget,
      sizeResolver: sizeResolver ?? this.sizeResolver,
      showRemoveButton: showRemoveButton ?? this.showRemoveButton,
      enabled: enabled ?? this.enabled,
      size: size ?? _size,
    );
  }
}

/// Calls [focusNode.requestFocus]
/// when a tab is added as active or becomes active due to a toggle event.
///
/// You need to implement a getter
/// that can access [FocusNode] in [PlutoLayoutTabItem.tabViewWidget].
abstract class PlutoLayoutTabViewWidgetHasFocusNode implements Widget {
  FocusNode get focusNode;
}
