import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pluto_layout/pluto_layout.dart';

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

class _DemoPageState extends State<DemoPage> {
  late final PlutoLayoutController controller;

  @override
  void initState() {
    super.initState();

    controller = PlutoLayoutController(
      leftMenus: [
        PlutoLayoutMenuItem(
          id: 'Files',
          title: 'Files',
          icon: const Icon(Icons.folder, size: 18),
          tabViewBuilder: (c) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: 500,
              width: 500,
              child: ListView(
                children: List.generate(
                  30,
                  (i) => Text('files $i'),
                ),
              ),
            ),
          ),
        ),
        PlutoLayoutMenuItem(
          id: 'Docs',
          title: 'Docs',
          icon: const Icon(Icons.my_library_books, size: 18),
          tabViewBuilder: (c) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: 500,
              width: 500,
              child: ListView(
                children: List.generate(
                  30,
                  (i) => Text('docs $i'),
                ),
              ),
            ),
          ),
        ),
        PlutoLayoutMenuItem(
          id: 'Docs2',
          title: 'Docs2',
          icon: const Icon(Icons.my_library_books, size: 18),
          tabViewBuilder: (c) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: 500,
              width: 500,
              child: ListView(
                children: List.generate(
                  30,
                  (i) => Text('docs2 $i'),
                ),
              ),
            ),
          ),
        ),
      ],
      rightMenus: [
        PlutoLayoutMenuItem(
          id: 'Settings',
          title: 'Settings',
          icon: const Icon(Icons.settings, size: 18),
          tabViewBuilder: (c) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: 500,
              width: 500,
              child: ListView(
                children: List.generate(
                  30,
                  (i) => Text('Settings $i'),
                ),
              ),
            ),
          ),
        ),
        PlutoLayoutMenuItem(
          id: 'Profile',
          title: 'Profile',
          icon: const Icon(Icons.account_box, size: 18),
          tabViewBuilder: (c) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: 500,
              width: 500,
              child: ListView(
                children: List.generate(
                  30,
                  (i) => Text('Profile $i'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
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
          scrollbars: false,
        ),
        child: PlutoLayout(
          controller: controller,
        ),
      ),
    );
  }
}
