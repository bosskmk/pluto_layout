import 'package:flutter/material.dart';
import 'package:pluto_layout/src/widgets/widgets.dart';

class PlutoLayoutMenus extends StatelessWidget {
  const PlutoLayoutMenus({
    required this.items,
    required this.onToggledItem,
    this.direction = PlutoLayoutMenuDirection.left,
    Key? key,
  }) : super(key: key);

  final List<PlutoLayoutMenuItem> items;

  final PlutoLayoutMenuDirection direction;

  final void Function(Object id, bool flag) onToggledItem;

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
                    onToggledItem(item.id, enabled);

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
  left,
  right;

  int get turns => this == PlutoLayoutMenuDirection.left ? -45 : 45;

  MainAxisAlignment get alignment => this == PlutoLayoutMenuDirection.left
      ? MainAxisAlignment.end
      : MainAxisAlignment.start;
}
