import 'package:flutter/material.dart';

class BottomSideMenu extends StatefulWidget {
  const BottomSideMenu({Key? key}) : super(key: key);

  @override
  State<BottomSideMenu> createState() => _BottomSideMenuState();
}

class _BottomSideMenuState extends State<BottomSideMenu> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: theme.dialogBackgroundColor,
        border: Border(
          top: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: const Text('bottom tab'),
    );
  }
}
