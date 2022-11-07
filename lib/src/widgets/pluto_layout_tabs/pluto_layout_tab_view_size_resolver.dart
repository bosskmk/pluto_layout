/// {@template pluto_layout_tab_view_size_resolver}
/// Abstract class for setting the size of the tab view.
///
/// Implement the [resolve] method that receives the total width,
/// the size to set, and the default size and returns the width of the tab view.
///
/// Implemented classes.
/// [PlutoLayoutTabViewSizeFixed]
/// {@macro pluto_layout_tab_view_size_fixed}
///
/// [PlutoLayoutTabViewSizeConstrains]
/// {@macro pluto_layout_tab_view_size_constrains}
///
/// [PlutoLayoutTabViewSizeRatio]
/// {@macro pluto_layout_tab_view_size_ratio}
/// {@endtemplate}
abstract class PlutoLayoutTabViewSizeResolver {
  const PlutoLayoutTabViewSizeResolver();

  bool get resizable;

  double resolve({
    required double maxSize,
    required double? sizeToSet,
    required double defaultSize,
  });
}

/// {@template pluto_layout_tab_view_size_fixed}
/// Set the tab view to a fixed size.
///
/// After setting, the size cannot be changed.
/// However, if the parent's size is smaller than the set size,
/// the size is adjusted to fit the screen size.
/// {@endtemplate}
class PlutoLayoutTabViewSizeFixed extends PlutoLayoutTabViewSizeResolver {
  const PlutoLayoutTabViewSizeFixed(this._size)
      : assert(_size > 0, 'Size must be greater than 0.');

  final double _size;

  @override
  final bool resizable = false;

  @override
  double resolve({
    required double maxSize,
    required double? sizeToSet,
    required double defaultSize,
  }) =>
      _size;
}

/// {@template pluto_layout_tab_view_size_constrains}
/// You can limit the size of the tab view to the minimum and maximum range.
/// You can also set the initial size.
///
/// At least one of [minSize], [maxSize], and [initialSize] must be set.
/// {@endtemplate}
class PlutoLayoutTabViewSizeConstrains extends PlutoLayoutTabViewSizeResolver {
  const PlutoLayoutTabViewSizeConstrains({
    double? minSize,
    double? maxSize,
    double? initialSize,
  })  : assert(
          minSize == null && maxSize == null && initialSize == null
              ? false
              : true,
          'At least one of minSize, maxSize, and initialSize must be set.',
        ),
        assert(
          minSize == null
              ? true
              : maxSize == null
                  ? true
                  : minSize <= maxSize,
          'MinSize must be less than or equal to maxSize.',
        ),
        assert(
          initialSize == null ||
              ((minSize == null ? true : initialSize >= minSize) &&
                  (maxSize == null ? true : initialSize <= maxSize)),
          'If initialSize is not null, '
          'initialSize must be within the range of minSize and maxSize.',
        ),
        _minSize = minSize,
        _maxSize = maxSize,
        _initialSize = initialSize;

  final double? _minSize;

  final double? _maxSize;

  final double? _initialSize;

  @override
  final bool resizable = true;

  @override
  double resolve({
    required double maxSize,
    required double? sizeToSet,
    required double defaultSize,
  }) {
    sizeToSet ??= _initialSize ?? defaultSize;
    if (_minSize != null && sizeToSet < _minSize!) return _minSize!;
    if (_maxSize != null && sizeToSet > _maxSize!) return _maxSize!;
    return sizeToSet;
  }
}

/// {@template pluto_layout_tab_view_size_ratio}
/// Set the size of the tab view according to the ratio of the total size.
///
/// After setting, the size cannot be changed.
/// However, if the parent's size is smaller than the set size,
/// the size is adjusted to fit the screen size.
/// {@endtemplate}
class PlutoLayoutTabViewSizeRatio extends PlutoLayoutTabViewSizeResolver {
  const PlutoLayoutTabViewSizeRatio(this._ratio)
      : assert(
          0 <= _ratio && _ratio <= 1,
          'The ratio value must be in the range 0 and 1.',
        );

  final double _ratio;

  @override
  final bool resizable = false;

  @override
  double resolve({
    required double maxSize,
    required double? sizeToSet,
    required double defaultSize,
  }) =>
      maxSize * _ratio;
}
