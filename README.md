## PlutoLayout - v0.2.0

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

PlutoLayout is a Flutter UI package that can configure a menu or tab screen on each side.  
You can adjust the width of the tab menu by dragging the right border of the tab menu.  
You can also assign custom shortcut keys to open or close tab views and resize tab views.

### Demo
[Demo Web](https://bosskmk.github.io/pluto_layout/build/web/index.html)

### Installation
[pub.dev](https://pub.dev/packages/pluto_layout)

### Screenshot

![PlutoLayout Screenshot](https://bosskmk.github.io/images/pluto_layout/pluto_layout.gif)

### Usage

```dart
class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage>
    with SingleTickerProviderStateMixin {
  final List<PlutoMenuItem> menuItems = [];

  @override
  void initState() {
    super.initState();

    menuItems.addAll([
      PlutoMenuItem(
          title: 'Home',
          onTap: () {
            print('Tap home.');
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

    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
          scrollbars: true,
        ),
        child: PlutoLayout(
          // You can assign custom shortcut keys.
          shortcuts: {
            // Pressing the Escape key closes all open tabviews.
            LogicalKeySet(LogicalKeyboardKey.escape):
            PlutoLayoutActions.hideAllTabView(),
            // If you press alt + 1, 
            // the tab views registered in left are opened and closed sequentially.
            LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
            PlutoLayoutActions.rotateTabView(
              PlutoLayoutContainerDirection.left,
            ),
            // If the tab view is open, 
            // you can resize the tab view with alt + left or right keys.
            LogicalKeySet(
                LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowRight):
            PlutoLayoutActions.increaseTabView(reverseByDirection: true),
            LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowLeft):
            PlutoLayoutActions.decreaseTabView(reverseByDirection: true),
          },
          body: PlutoLayoutContainer(
            child: Text('Body container'),
          ),
          top: PlutoLayoutContainer(
            child: PlutoMenuBar(
              height: 32,
              mode: PlutoMenuBarMode.hover,
              menus: menuItems,
              backgroundColor: theme.dialogBackgroundColor,
              moreIconColor: theme.toggleableActiveColor,
              textStyle: TextStyle(
                color: theme.primaryColorLight,
              ),
            ),
          ),
          left: PlutoLayoutContainer(
            child: PlutoLayoutTabs(
              mode: PlutoLayoutTabMode.showSelected,
              items: [
                PlutoLayoutTabItem(
                  id: 'Project',
                  title: 'Project',
                  tabViewBuilder: (c) {
                    return Text('Project View');
                  },
                ),
                PlutoLayoutTabItem(
                  id: 'Bookmark',
                  title: 'Bookmark',
                  tabViewBuilder: (c) {
                    return Text('Bookmark View');
                  },
                ),
                PlutoLayoutTabItem(
                  id: 'Structure',
                  title: 'Structure',
                  tabViewBuilder: (c) {
                    return ListView(
                      children: List.generate(20, (i) => i)
                          .map((e) => Text('$e'))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

<br>

### Related packages
> develop packages that make it easy to develop admin pages or CMS with Flutter.
* [PlutoGrid](https://github.com/bosskmk/pluto_grid)
* [PlutoMenuBar](https://github.com/bosskmk/pluto_menu_bar)
* [PlutoLayout](https://github.com/bosskmk/pluto_layout)

<br>

### Donate to this project

[![Buy me a coffee](https://www.buymeacoffee.com/assets/img/custom_images/white_img.png)](https://www.buymeacoffee.com/manki)

<br>

### Jetbrains provides a free license

[<img alt="IDE license support" src="https://resources.jetbrains.com/storage/products/company/brand/logos/jb_beam.png" width="170"/>](https://www.jetbrains.com/community/opensource/#support)
