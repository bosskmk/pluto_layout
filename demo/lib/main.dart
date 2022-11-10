import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_layout/pluto_layout.dart';

import 'screens/screens.dart';
import 'tabs/tabs.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage>
    with SingleTickerProviderStateMixin {
  final String httpProtocol = kReleaseMode ? 'https' : 'http';

  late final TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            LogicalKeySet(
                    LogicalKeyboardKey.control, LogicalKeyboardKey.arrowUp):
                PlutoLayoutActions.increaseTabItemView(),
            LogicalKeySet(
                    LogicalKeyboardKey.control, LogicalKeyboardKey.arrowDown):
                PlutoLayoutActions.decreaseTabItemView(),
          },
          body: PlutoLayoutContainer(
            child: TabBarView(
              controller: tabController,
              children: const [
                HomeScreen(),
                AboutMeScreen(),
              ],
            ),
          ),
          top: PlutoLayoutContainer(
            child: TopTab(tabController: tabController),
          ),
          left: const PlutoLayoutContainer(
            child: LeftTab(),
          ),
          right: const PlutoLayoutContainer(
            child: RightTab(),
          ),
        ),
      ),
    );
  }
}
