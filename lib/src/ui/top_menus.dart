import 'package:flutter/material.dart';

class TopMenus extends StatefulWidget {
  const TopMenus({Key? key}) : super(key: key);

  @override
  State<TopMenus> createState() => _TopMenusState();
}

class _TopMenusState extends State<TopMenus> {
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
