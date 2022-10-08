import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pluto_layout/pluto_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final PlutoLayoutController controller;

  @override
  void initState() {
    super.initState();

    controller = PlutoLayoutController(
      leftSideMenus: [
        SideMenuItem(
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
        SideMenuItem(
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
        SideMenuItem(
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
      rightSideMenus: [
        SideMenuItem(
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
        SideMenuItem(
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
