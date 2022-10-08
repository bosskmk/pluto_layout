import 'package:flutter/material.dart';
import 'package:pluto_layout/pluto_layout.dart';

class RightSideMenu extends StatefulWidget {
  const RightSideMenu({
    required this.controller,
    super.key,
  });

  final PlutoLayoutController controller;

  @override
  State<RightSideMenu> createState() => _RightSideMenuState();
}

class _RightSideMenuState extends State<RightSideMenu> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.dialogBackgroundColor,
        border: Border(
          left: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: SideMenus(
        items: widget.controller.rightSideMenus,
        onToggledItem: widget.controller.setEnabledRightSideMenuItem,
        direction: SideMenuDirection.right,
      ),
    );
  }
}
