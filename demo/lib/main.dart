// ignore_for_file: prefer_const_constructors

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
          top: PlutoLayoutContainer(
            child: PlutoLayoutTabs(
              mode: PlutoLayoutTabMode.showSelected,
              items: [
                PlutoLayoutTabItem(
                  id: 'File',
                  title: 'File',
                  tabViewBuilder: (c) {
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(20, (i) => i)
                          .map((e) => Text('$e'))
                          .toList(),
                    );
                  },
                ),
                PlutoLayoutTabItem(
                  id: 'Edit',
                  title: 'Edit',
                  tabViewBuilder: (c) {
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(20, (i) => i)
                          .map((e) => Text('$e'))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          left: PlutoLayoutContainer(
            // backgroundColor: Colors.blueAccent,
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
          right: PlutoLayoutContainer(
            child: PlutoLayoutTabs(
              mode: PlutoLayoutTabMode.showSelected,
              items: [
                PlutoLayoutTabItem(
                  id: 'Flutter Inspector',
                  title: 'Flutter Inspector',
                  tabViewBuilder: (c) {
                    return Text('Flutter Inspector View');
                  },
                ),
                PlutoLayoutTabItem(
                  id: 'Flutter Performance',
                  title: 'Flutter Performance',
                  tabViewBuilder: (c) {
                    return Text('Flutter Performance View');
                  },
                ),
              ],
            ),
          ),
          bottom: PlutoLayoutContainer(
            child: PlutoLayoutTabs(
              mode: PlutoLayoutTabMode.showSelected,
              items: [
                PlutoLayoutTabItem(
                  id: 'Terminal',
                  title: 'Terminal',
                  tabViewBuilder: (c) {
                    return Text('Terminal View');
                  },
                ),
                PlutoLayoutTabItem(
                  id: 'Git',
                  title: 'Git',
                  tabViewBuilder: (c) {
                    return Text('Git View');
                  },
                ),
              ],
            ),
          ),
          body: PlutoLayoutContainer(
            // backgroundColor: Colors.green,
            child: Text('body'),
          ),
        ),
      ),
    );
  }
}
