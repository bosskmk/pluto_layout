import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../pluto_layout.dart';

final layoutContainerDirectionProvider =
    Provider<PlutoLayoutContainerDirection>(
  (ref) => throw UnimplementedError(),
);

class PlutoLayoutContainer extends ConsumerWidget {
  const PlutoLayoutContainer({
    this.backgroundColor,
    required this.child,
    super.key,
  });

  final Color? backgroundColor;

  final Widget child;

  PlutoLayoutContainerDirection _getDirection(PlutoLayoutId id) {
    switch (id) {
      case PlutoLayoutId.top:
        return PlutoLayoutContainerDirection.top;
      case PlutoLayoutId.left:
        return PlutoLayoutContainerDirection.left;
      case PlutoLayoutId.right:
        return PlutoLayoutContainerDirection.right;
      case PlutoLayoutId.bottom:
        return PlutoLayoutContainerDirection.bottom;
      case PlutoLayoutId.body:
        return PlutoLayoutContainerDirection.top;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final layoutId = ref.read(layoutIdProvider);

    final border = BorderSide(color: theme.dividerColor);

    PlutoLayoutContainerDirection direction = _getDirection(layoutId);

    return ProviderScope(
      overrides: [
        layoutContainerDirectionProvider.overrideWithValue(direction),
      ],
      child: GestureDetector(
        onTap: () {
          ref.read(layoutFocusedIdProvider.notifier).state = layoutId;
        },
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: layoutId.isBody
                ? null
                : Border(
                    top: direction.isBottom ? border : BorderSide.none,
                    left: direction.isRight ? border : BorderSide.none,
                    right: direction.isLeft ? border : BorderSide.none,
                    bottom: direction.isTop ? border : BorderSide.none,
                  ),
          ),
          child: child,
        ),
      ),
    );
  }
}

enum PlutoLayoutContainerDirection {
  top,
  left,
  right,
  bottom;

  bool get isTop => this == PlutoLayoutContainerDirection.top;
  bool get isLeft => this == PlutoLayoutContainerDirection.left;
  bool get isRight => this == PlutoLayoutContainerDirection.right;
  bool get isBottom => this == PlutoLayoutContainerDirection.bottom;
  bool get isHorizontal => isLeft || isRight;
  bool get isVertical => isTop || isBottom;
}
