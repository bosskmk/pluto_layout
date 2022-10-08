import 'package:flutter/material.dart';
import 'package:pluto_layout/pluto_layout.dart';

class LeftSideMenu extends StatefulWidget {
  const LeftSideMenu({
    required this.controller,
    super.key,
  });

  final PlutoLayoutController controller;

  @override
  State<LeftSideMenu> createState() => _LeftSideMenuState();
}

class _LeftSideMenuState extends State<LeftSideMenu> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.dialogBackgroundColor,
        border: Border(
          right: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: SideMenus(
        items: widget.controller.leftSideMenus.reversed.toList(),
        onToggledItem: widget.controller.setEnabledLeftSideMenuItem,
        direction: SideMenuDirection.left,
      ),
    );
  }
}
