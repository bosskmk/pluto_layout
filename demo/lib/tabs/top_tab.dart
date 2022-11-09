import 'package:flutter/material.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';

import '../helper/launch_url.dart';

class TopTab extends StatefulWidget {
  const TopTab({required this.tabController, super.key});

  final TabController tabController;

  @override
  State<TopTab> createState() => _TopTabState();
}

class _TopTabState extends State<TopTab> {
  final List<PlutoMenuItem> menuItems = [];

  @override
  void initState() {
    super.initState();

    menuItems.addAll([
      PlutoMenuItem(
          title: 'Home',
          onTap: () {
            widget.tabController.animateTo(0);
          }),
      PlutoMenuItem(
          title: 'About Me',
          onTap: () {
            widget.tabController.animateTo(1);
          }),
      PlutoMenuItem(
        title: 'Links',
        children: [
          PlutoMenuItem(
            title: 'Home page',
            children: [
              PlutoMenuItem(
                  title: 'PlutoGrid',
                  onTap: () =>
                      launchUrl('https://pluto.weblaze.dev/series/pluto-grid')),
              PlutoMenuItem(
                  title: 'PlutoMenuBar',
                  onTap: () => launchUrl(
                      'https://pluto.weblaze.dev/series/pluto-menu-bar')),
            ],
          ),
          PlutoMenuItem(
            title: 'Github',
            children: [
              PlutoMenuItem(
                  title: 'PlutoGrid',
                  onTap: () =>
                      launchUrl('https://github.com/bosskmk/pluto_grid')),
              PlutoMenuItem(
                  title: 'PlutoMenuBar',
                  onTap: () =>
                      launchUrl('https://github.com/bosskmk/pluto_menu_bar')),
            ],
          ),
        ],
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PlutoMenuBar(
      height: 32,
      mode: PlutoMenuBarMode.hover,
      menus: menuItems,
      backgroundColor: theme.dialogBackgroundColor,
      moreIconColor: theme.toggleableActiveColor,
      textStyle: TextStyle(
        color: theme.primaryColorLight,
      ),
    );
  }
}
