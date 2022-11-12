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
            PlutoLayoutId.left,
          ),
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit2):
              PlutoLayoutActions.rotateTabView(
            PlutoLayoutId.right,
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
                tabViewWidget: const Text('top1'),
              ),
              PlutoLayoutTabItem(
                id: 'top2',
                title: 'top2',
                tabViewWidget: const Text('top2'),
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
                tabViewWidget: const Text('left1'),
              ),
              PlutoLayoutTabItem(
                id: 'left2',
                title: 'left2',
                tabViewWidget: const Text('left2'),
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
                tabViewWidget: const Text('right1'),
              ),
              PlutoLayoutTabItem(
                id: 'right2',
                title: 'right2',
                tabViewWidget: const Text('right2'),
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
                tabViewWidget: const Text('bottom1'),
              ),
              PlutoLayoutTabItem(
                id: 'bottom2',
                title: 'bottom2',
                tabViewWidget: const Text('bottom2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
