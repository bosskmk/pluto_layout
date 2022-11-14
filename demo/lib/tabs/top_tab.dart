import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';

import '../helper/launch_url.dart';

final _isAndroid = defaultTargetPlatform == TargetPlatform.android;
final _isIOS = defaultTargetPlatform == TargetPlatform.iOS;
final _isFuchsia = defaultTargetPlatform == TargetPlatform.fuchsia;
final _isMobileWeb = kIsWeb && (_isAndroid || _isIOS || _isFuchsia);
final _isMobileApp = !kIsWeb && (_isAndroid || _isIOS || _isFuchsia);
final _isMobile = _isMobileWeb || _isMobileApp;

class TopTab extends StatefulWidget {
  const TopTab({super.key});

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
              PlutoMenuItem(
                  title: 'PlutoLayout',
                  onTap: () => launchUrl(
                      'https://pluto.weblaze.dev/series/pluto-layout')),
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
              PlutoMenuItem(
                  title: 'PlutoLayout',
                  onTap: () =>
                      launchUrl('https://github.com/bosskmk/pluto_layout')),
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
      mode: _isMobile ? PlutoMenuBarMode.tap : PlutoMenuBarMode.hover,
      menus: menuItems,
      backgroundColor: theme.dialogBackgroundColor,
      moreIconColor: theme.toggleableActiveColor,
      textStyle: TextStyle(
        color: theme.primaryColorLight,
      ),
    );
  }
}
