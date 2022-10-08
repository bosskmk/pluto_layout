import 'package:flutter/material.dart';
import 'package:pluto_layout/pluto_layout.dart';

class RightMenus extends StatefulWidget {
  const RightMenus({
    required this.controller,
    super.key,
  });

  final PlutoLayoutController controller;

  @override
  State<RightMenus> createState() => _RightMenusState();
}

class _RightMenusState extends State<RightMenus> {
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
      child: PlutoLayoutMenus(
        items: widget.controller.rightSideMenus,
        onToggledItem: widget.controller.setEnabledRightSideMenuItem,
        direction: PlutoLayoutMenuDirection.right,
      ),
    );
  }
}
