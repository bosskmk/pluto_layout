import 'package:flutter/material.dart';
import 'package:pluto_layout/pluto_layout.dart';

class LeftMenus extends StatefulWidget {
  const LeftMenus({
    required this.controller,
    super.key,
  });

  final PlutoLayoutController controller;

  @override
  State<LeftMenus> createState() => _LeftMenusState();
}

class _LeftMenusState extends State<LeftMenus> {
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
      child: PlutoLayoutMenus(
        items: widget.controller.leftSideMenus.reversed.toList(),
        onToggledItem: widget.controller.setEnabledLeftSideMenuItem,
        direction: PlutoLayoutMenuDirection.left,
      ),
    );
  }
}
