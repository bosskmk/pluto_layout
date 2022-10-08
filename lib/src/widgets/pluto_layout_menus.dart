import 'package:flutter/material.dart';
import 'package:pluto_layout/src/widgets/widgets.dart';

class PlutoLayoutMenus extends StatelessWidget {
  const PlutoLayoutMenus({
    this.direction = PlutoLayoutMenuDirection.top,
    required this.onTap,
    required this.items,
    super.key,
  });

  final PlutoLayoutMenuDirection direction;

  final void Function(Object id, bool flag)? onTap;

  final List<PlutoLayoutMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: RotatedBox(
        quarterTurns: direction.turns,
        child: Row(
          mainAxisAlignment: direction.alignment,
          children: items
              .map<ToggleButton>(
                (item) => ToggleButton(
                  key: ValueKey(item.id),
                  title: item.title,
                  icon: item.icon,
                  enabled: item.enabled,
                  changed: (enabled) {
                    if (onTap != null) onTap!(item.id, enabled);
                    if (item.onTap != null) item.onTap!();
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class PlutoLayoutMenuItem {
  PlutoLayoutMenuItem({
    required this.id,
    required this.title,
    this.icon,
    this.onTap,
    this.tabViewBuilder,
  });

  final Object id;

  final String title;

  final Widget? icon;

  final void Function()? onTap;

  final Widget Function(BuildContext context)? tabViewBuilder;

  bool enabled = false;

  double? tabViewHeight;
}

enum PlutoLayoutMenuDirection {
  top,
  left,
  right,
  bottom;

  bool get isTop => this == PlutoLayoutMenuDirection.top;
  bool get isLeft => this == PlutoLayoutMenuDirection.left;
  bool get isRight => this == PlutoLayoutMenuDirection.right;
  bool get isBottom => this == PlutoLayoutMenuDirection.bottom;

  int get turns {
    switch (this) {
      case PlutoLayoutMenuDirection.top:
        return 0;
      case PlutoLayoutMenuDirection.left:
        return -45;
      case PlutoLayoutMenuDirection.right:
        return 45;
      case PlutoLayoutMenuDirection.bottom:
        return 0;
    }
  }

  MainAxisAlignment get alignment {
    switch (this) {
      case PlutoLayoutMenuDirection.top:
        return MainAxisAlignment.start;
      case PlutoLayoutMenuDirection.left:
        return MainAxisAlignment.end;
      case PlutoLayoutMenuDirection.right:
        return MainAxisAlignment.start;
      case PlutoLayoutMenuDirection.bottom:
        return MainAxisAlignment.start;
    }
  }
}
