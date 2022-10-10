// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

enum ResizeIndicatorPosition {
  top,
  left,
  right,
  bottom;

  bool get horizontal =>
      this == ResizeIndicatorPosition.top ||
      this == ResizeIndicatorPosition.bottom;

  bool get vertical =>
      this == ResizeIndicatorPosition.left ||
      this == ResizeIndicatorPosition.right;

  List<double?> get topLeftRightBottom {
    switch (this) {
      case ResizeIndicatorPosition.top:
        return [0, 0, 0, null];
      case ResizeIndicatorPosition.left:
        return [0, 0, null, 0];
      case ResizeIndicatorPosition.right:
        return [0, null, 0, 0];
      case ResizeIndicatorPosition.bottom:
        return [null, 0, 0, 0];
    }
  }
}

class ResizeIndicator<T> extends StatelessWidget {
  const ResizeIndicator({
    required this.item,
    required this.position,
    required this.onResize,
    required this.child,
    super.key,
  });

  final T item;

  final ResizeIndicatorPosition position;

  final void Function(T, Offset) onResize;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final topLeftRightBottom = position.topLeftRightBottom;
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Stack(
      children: [
        Positioned.fill(child: child),
        Positioned(
          top: topLeftRightBottom[0],
          left: topLeftRightBottom[1],
          right: topLeftRightBottom[2],
          bottom: topLeftRightBottom[3],
          child: MouseRegion(
            cursor: position.horizontal
                ? SystemMouseCursors.resizeUpDown
                : SystemMouseCursors.resizeLeftRight,
            child: GestureDetector(
              onHorizontalDragUpdate: position.vertical
                  ? (details) => onResize(item, details.delta)
                  : null,
              onVerticalDragUpdate: position.horizontal
                  ? (details) => onResize(item, details.delta)
                  : null,
              child: Container(
                width: position.horizontal ? size.width : 5,
                height: position.vertical ? size.height : 5,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    top: position == ResizeIndicatorPosition.top
                        ? BorderSide(color: theme.dividerColor)
                        : BorderSide.none,
                    left: position == ResizeIndicatorPosition.left
                        ? BorderSide(color: theme.dividerColor)
                        : BorderSide.none,
                    right: position == ResizeIndicatorPosition.right
                        ? BorderSide(color: theme.dividerColor)
                        : BorderSide.none,
                    bottom: position == ResizeIndicatorPosition.bottom
                        ? BorderSide(color: theme.dividerColor)
                        : BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
