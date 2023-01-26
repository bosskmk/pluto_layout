import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';

import '../helper/launch_url.dart';

final _isAndroid = defaultTargetPlatform == TargetPlatform.android;
final _isIOS = defaultTargetPlatform == TargetPlatform.iOS;
final _isFuchsia = defaultTargetPlatform == TargetPlatform.fuchsia;
final _isMobileWeb = kIsWeb && (_isAndroid || _isIOS || _isFuchsia);
final _isMobileApp = !kIsWeb && (_isAndroid || _isIOS || _isFuchsia);
final _isMobile = _isMobileWeb || _isMobileApp;

class TopTab extends StatefulWidget {
  const TopTab({required this.newTabResolver, super.key});

  final PlutoLayoutActionInsertTabItemResolver newTabResolver;

  @override
  State<TopTab> createState() => _TopTabState();
}

class _TopTabState extends State<TopTab> {
  final List<PlutoMenuItem> menuItems = [];

  @override
  void initState() {
    super.initState();

    final PlutoLayoutEventStreamController? eventStreamController =
        PlutoLayout.getEventStreamController(context);

    menuItems.addAll(
      [
        PlutoMenuItem(
          title: 'Links',
          children: [
            PlutoMenuItem(
              title: 'Home page',
              children: [
                PlutoMenuItem(
                    title: 'PlutoGrid',
                    onTap: () => launchUrl(
                        'https://pluto.weblaze.dev/series/pluto-grid')),
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
        PlutoMenuItem(
          title: 'Tabs',
          children: [
            PlutoMenuItem(
              title: 'New Tab (Shift + N)',
              onTap: () => eventStreamController?.add(
                PlutoInsertTabItemEvent(
                  layoutId: PlutoLayoutId.body,
                  itemResolver: widget.newTabResolver,
                ),
              ),
            ),
            PlutoMenuItem(
              title: 'Rotate',
              children: [
                PlutoMenuItem(
                  title: 'Left (Alt + 1)',
                  onTap: () => eventStreamController
                      ?.add(const PlutoRotateTabViewEvent(PlutoLayoutId.left)),
                ),
                PlutoMenuItem(
                  title: 'Right (Alt + 2)',
                  onTap: () => eventStreamController
                      ?.add(const PlutoRotateTabViewEvent(PlutoLayoutId.right)),
                ),
                PlutoMenuItem(
                  title: 'Body',
                  onTap: () => eventStreamController
                      ?.add(const PlutoRotateTabViewEvent(PlutoLayoutId.body)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PlutoMenuBar(
      height: 32,
      mode: _isMobile ? PlutoMenuBarMode.tap : PlutoMenuBarMode.hover,
      menus: menuItems,
      backgroundColor: theme.dialogBackgroundColor,
      moreIconColor: theme.colorScheme.secondary,
      textStyle: TextStyle(
        color: theme.primaryColorLight,
      ),
    );
  }
}
