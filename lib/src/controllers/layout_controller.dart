import 'dart:math';

mixin LayoutControllerMixin {
  bool _initialized = false;

  double _leftTabViewHeight = 0;

  double _rightTabViewHeight = 0;

  double _leftTabViewWidth = 0;

  double _rightTabViewWidth = 0;

  double _bodyContainerWidth = 0;

  double _contentWidth = 0;

  bool get initializedLayout => _initialized;

  double get contentWidth => _contentWidth;

  double get leftTabViewHeight => _leftTabViewHeight;

  double get rightTabViewHeight => _rightTabViewHeight;

  double get leftTabViewWidth => _leftTabViewWidth;

  double get rightTabViewWidth => _rightTabViewWidth;

  double get bodyContainerWidth => _bodyContainerWidth;

  double get minTabViewWidth;

  void setLayout({
    double? leftTabViewHeight,
    double? rightTabViewHeight,
    double? leftTabViewWidth,
    double? rightTabViewWidth,
    double? bodyContainerWidth,
    double? contentWidth,
  }) {
    _initialize(contentWidth);

    if (leftTabViewHeight != null) _leftTabViewHeight = leftTabViewHeight;
    if (rightTabViewHeight != null) _rightTabViewHeight = rightTabViewHeight;
    if (leftTabViewWidth != null) _leftTabViewWidth = leftTabViewWidth;
    if (rightTabViewWidth != null) _rightTabViewWidth = rightTabViewWidth;
    if (bodyContainerWidth != null) _bodyContainerWidth = bodyContainerWidth;
    if (contentWidth != null) _contentWidth = contentWidth;
  }

  void _initialize(double? contentWidth) {
    if (_initialized) return;

    double initWidth = max(
      contentWidth == null ? minTabViewWidth : contentWidth / 4,
      minTabViewWidth,
    );

    _leftTabViewWidth = initWidth;
    _rightTabViewWidth = initWidth;

    _initialized = true;
  }
}
