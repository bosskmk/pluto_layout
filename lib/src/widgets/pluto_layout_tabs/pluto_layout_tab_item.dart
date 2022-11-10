part of pluto_layout_tabs;

/// Class to pass to [PlutoLayoutTabs.items].
///
/// Set the information constituting the tab menu.
///
/// {@template pluto_layout_tab_item_id}
/// [id] must pass a unique value. (Usually, if the title is unique, it will be delivered.)
/// {@endtemplate}
///
/// {@template pluto_layout_tab_item_title}
/// [title] is the title of the menu to be displayed.
/// {@endtemplate}
///
/// {@template pluto_layout_tab_item_icon}
/// [icon] is the icon to display before the menu title.
/// {@endtemplate}
///
/// {@template pluto_layout_tab_item_tabViewBuilder}
/// [tabViewBuilder] is a callback function that returns a tab view widget
/// that will be displayed when the menu is tapped.
/// Just pass a function that returns [Widget].
///
/// {@template pluto_layout_tab_item_showRemoveButton}
/// [showRemoveButton] displays an X button to remove a tab
/// at the right end of the menu when the value is true.
/// {@endtemplate}
///
/// ```dart
/// tabViewBuilder: (c) {
///   return Padding(
///     padding: EdgeInsets.all(15),
///     child: ListView(
///       children: const [
///         Text('Example contents'),
///         SizedBox(height: 15),
///         Text('Example contents),
///         SizedBox(height: 10),
///         Text('Example contents),
///       ],
///     ),
///   );
/// },
/// ```
/// {@endtemplate}
class PlutoLayoutTabItem {
  PlutoLayoutTabItem({
    required this.id,
    required this.title,
    this.icon,
    this.tabViewBuilder,
    this.sizeResolver = const PlutoLayoutTabItemSizeFlexible(),
    this.showRemoveButton = false,
    this.enabled = false,
  });

  PlutoLayoutTabItem._({
    required this.id,
    required this.title,
    this.icon,
    this.tabViewBuilder,
    this.sizeResolver = const PlutoLayoutTabItemSizeFlexible(),
    this.showRemoveButton = false,
    this.enabled = false,
    double? size,
  }) : _size = size ?? 0;

  /// {@macro pluto_layout_tab_item_id}
  final Object id;

  /// {@macro pluto_layout_tab_item_title}
  final String title;

  /// {@macro pluto_layout_tab_item_icon}
  final Widget? icon;

  /// {@macro pluto_layout_tab_item_tabViewBuilder}
  final Widget Function(BuildContext context)? tabViewBuilder;

  /// {@macro pluto_layout_tab_view_size_resolver}
  final PlutoLayoutTabItemSizeResolver sizeResolver;

  /// {@macro pluto_layout_tab_item_showRemoveButton}
  final bool showRemoveButton;

  /// The open and closed state of the tab view.
  final bool enabled;

  double _size = 0;

  PlutoLayoutTabItem copyWith({
    Object? id,
    String? title,
    Widget? icon,
    Widget Function(BuildContext context)? tabViewBuilder,
    PlutoLayoutTabItemSizeResolver? sizeResolver,
    bool? showRemoveButton,
    bool? enabled,
    double? size,
  }) {
    return PlutoLayoutTabItem._(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      tabViewBuilder: tabViewBuilder ?? this.tabViewBuilder,
      sizeResolver: sizeResolver ?? this.sizeResolver,
      showRemoveButton: showRemoveButton ?? this.showRemoveButton,
      enabled: enabled ?? this.enabled,
      size: size ?? _size,
    );
  }
}
