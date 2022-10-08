import 'package:flutter/material.dart';
import 'package:pluto_layout/pluto_layout.dart';

class MenuContainer extends StatelessWidget {
  const MenuContainer({
    this.direction = PlutoLayoutMenuDirection.top,
    this.onTap,
    this.items = const [],
    super.key,
  });

  final List<PlutoLayoutMenuItem> items;

  final void Function(Object, bool)? onTap;

  final PlutoLayoutMenuDirection direction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.dialogBackgroundColor,
        border: Border(
          top: direction.isBottom
              ? BorderSide(color: theme.dividerColor)
              : BorderSide.none,
          left: direction.isRight
              ? BorderSide(color: theme.dividerColor)
              : BorderSide.none,
          right: direction.isLeft
              ? BorderSide(color: theme.dividerColor)
              : BorderSide.none,
          bottom: direction.isTop
              ? BorderSide(color: theme.dividerColor)
              : BorderSide.none,
        ),
      ),
      child: PlutoLayoutMenus(
        direction: direction,
        onTap: onTap,
        items: items,
      ),
    );
  }
}
