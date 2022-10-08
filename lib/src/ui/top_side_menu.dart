import 'package:flutter/material.dart';

class TopSideMenu extends StatefulWidget {
  const TopSideMenu({Key? key}) : super(key: key);

  @override
  State<TopSideMenu> createState() => _TopSideMenuState();
}

class _TopSideMenuState extends State<TopSideMenu> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: theme.dialogBackgroundColor,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: const Text('top tab'),
    );
  }
}
