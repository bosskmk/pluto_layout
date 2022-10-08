import 'package:flutter/material.dart';

class BottomMenus extends StatefulWidget {
  const BottomMenus({Key? key}) : super(key: key);

  @override
  State<BottomMenus> createState() => _BottomMenusState();
}

class _BottomMenusState extends State<BottomMenus> {
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
