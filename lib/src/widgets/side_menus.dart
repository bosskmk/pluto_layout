import 'package:flutter/material.dart';
import 'package:pluto_layout/pluto_layout.dart';

class SideMenus extends StatelessWidget {
  const SideMenus({
    required this.items,
    required this.onToggledItem,
    this.direction = SideMenuDirection.left,
    Key? key,
  }) : super(key: key);

  final List<SideMenuItem> items;

  final SideMenuDirection direction;

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

enum SideMenuDirection {
  left,
  right;

  int get turns => this == SideMenuDirection.left ? -45 : 45;

  MainAxisAlignment get alignment => this == SideMenuDirection.left
      ? MainAxisAlignment.end
      : MainAxisAlignment.start;
}

class SideMenuItem {
  SideMenuItem({
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
