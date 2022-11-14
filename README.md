## PlutoLayout - v0.3.0

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

PlutoLayout is a Flutter UI package that can configure a menu or tab screen on each side.  
You can adjust the width of the tab menu by dragging the right border of the tab menu.  
You can also assign custom shortcut keys to open or close tab views and resize tab views.

### Demo
[Demo Web](https://bosskmk.github.io/pluto_layout/build/web/index.html)

### Installation
[pub.dev](https://pub.dev/packages/pluto_layout)

### Screenshot

![PlutoLayout Screenshot](https://bosskmk.github.io/images/pluto_layout/pluto_layout_0.3.gif)

### Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_layout/pluto_layout.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlutoLayout(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.escape):
          PlutoLayoutActions.hideAllTabView(),
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
          PlutoLayoutActions.rotateTabView(
            PlutoLayoutContainerDirection.left,
          ),
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit2):
          PlutoLayoutActions.rotateTabView(
            PlutoLayoutContainerDirection.right,
          ),
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowUp):
          PlutoLayoutActions.increaseTabView(),
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowDown):
          PlutoLayoutActions.decreaseTabView(),
        },
        body: const PlutoLayoutContainer(
          child: Text('Body container'),
        ),
        top: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
            items: [
              PlutoLayoutTabItem(
                id: 'top1',
                title: 'top1',
                tabViewBuilder: (e) => const Text('top1'),
              ),
              PlutoLayoutTabItem(
                id: 'top2',
                title: 'top2',
                tabViewBuilder: (e) => const Text('top2'),
              ),
            ],
          ),
        ),
        left: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
            items: [
              PlutoLayoutTabItem(
                id: 'left1',
                title: 'left1',
                tabViewBuilder: (e) => const Text('left1'),
              ),
              PlutoLayoutTabItem(
                id: 'left2',
                title: 'left2',
                tabViewBuilder: (e) => const Text('left2'),
              ),
            ],
          ),
        ),
        right: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
            items: [
              PlutoLayoutTabItem(
                id: 'right1',
                title: 'right1',
                tabViewBuilder: (e) => const Text('right1'),
              ),
              PlutoLayoutTabItem(
                id: 'right2',
                title: 'right2',
                tabViewBuilder: (e) => const Text('right2'),
              ),
            ],
          ),
        ),
        bottom: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
            items: [
              PlutoLayoutTabItem(
                id: 'bottom1',
                title: 'bottom1',
                tabViewBuilder: (e) => const Text('bottom1'),
              ),
              PlutoLayoutTabItem(
                id: 'bottom2',
                title: 'bottom2',
                tabViewBuilder: (e) => const Text('bottom2'),
              ),
            ],
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
