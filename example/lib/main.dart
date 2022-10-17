// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/darcula.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:highlight/languages/dart.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'example_text.dart';

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
  final List<PlutoMenuItem> menuItems = [];

  final String httpProtocol = kReleaseMode ? 'https' : 'http';

  late final TabController tabController;

  @override
  void initState() {
    super.initState();

    menuItems.addAll([
      PlutoMenuItem(
          title: 'Home',
          onTap: () {
            tabController.animateTo(0);
          }),
      PlutoMenuItem(
          title: 'About Me',
          onTap: () {
            tabController.animateTo(1);
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

    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
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
            LogicalKeySet(
                    LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowRight):
                PlutoLayoutActions.increaseTabView(),
            LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowLeft):
                PlutoLayoutActions.decreaseTabView(),
          },
          body: PlutoLayoutContainer(
            child: TabBarView(
              controller: tabController,
              children: const [
                _BodyHomeScreen(),
                _AboutMeScreen(),
              ],
            ),
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
                  id: ExampleText.aboutTitle,
                  title: ExampleText.aboutTitle,
                  tabViewBuilder: (c) {
                    return Padding(
                      padding: EdgeInsets.all(15),
                      child: ListView(
                        children: const [
                          Text(ExampleText.aboutTitle),
                          SizedBox(height: 15),
                          Text(ExampleText.aboutDesc1),
                          SizedBox(height: 10),
                          Text(ExampleText.aboutDesc2),
                        ],
                      ),
                    );
                  },
                ),
                PlutoLayoutTabItem(
                  id: ExampleText.aboutLayoutTitle,
                  title: ExampleText.aboutLayoutTitle,
                  tabViewBuilder: (c) {
                    return Padding(
                      padding: EdgeInsets.all(15),
                      child: ListView(
                        children: const [
                          Text(ExampleText.aboutLayoutTitle),
                          SizedBox(height: 15),
                          Text(ExampleText.aboutLayoutDesc1),
                          SizedBox(height: 10),
                          Text(ExampleText.aboutLayoutDesc2),
                        ],
                      ),
                    );
                  },
                ),
                PlutoLayoutTabItem(
                  id: ExampleText.nestedTabsTitle,
                  title: ExampleText.nestedTabsTitle,
                  tabViewBuilder: (c) {
                    return Padding(
                      padding: EdgeInsets.all(15),
                      child: ListView(
                        children: const [
                          Text(ExampleText.nestedTabsTitle),
                          SizedBox(height: 15),
                          Text(ExampleText.nestedTabsDesc1),
                          SizedBox(height: 10),
                          Text(ExampleText.nestedTabsDesc2),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          right: PlutoLayoutContainer(
            child: PlutoLayoutTabs(
              items: [
                PlutoLayoutTabItem(
                  id: ExampleText.donateTitle,
                  title: ExampleText.donateTitle,
                  tabViewBuilder: (c) {
                    return Padding(
                      padding: EdgeInsets.all(15),
                      child: ListView(
                        children: [
                          Text(ExampleText.donateTitle),
                          SizedBox(height: 15),
                          Text(ExampleText.donateDesc1),
                          SizedBox(height: 50),
                          Center(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  launchUrl(
                                      'https://github.com/sponsors/bosskmk');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.all(15),
                                  constraints: BoxConstraints(
                                    maxWidth: 213.7,
                                    minHeight: 32,
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.favorite, color: Colors.pink),
                                      Expanded(
                                        child: Text(
                                          'Github Sponsor',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            overflow: TextOverflow.fade,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  launchUrl(
                                      'https://www.buymeacoffee.com/manki');
                                },
                                child: Image.asset(
                                  'assets/buy_me_a_coffee.png',
                                  height: 60,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                PlutoLayoutTabItem(
                  id: ExampleText.jetbrainsTitle,
                  title: ExampleText.jetbrainsTitle,
                  tabViewBuilder: (c) {
                    return Padding(
                      padding: EdgeInsets.all(15),
                      child: ListView(
                        children: [
                          Text(ExampleText.jetbrainsTitle),
                          SizedBox(height: 15),
                          Text(ExampleText.jetbrainsDesc1),
                          SizedBox(height: 50),
                          Center(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  launchUrl(
                                      'https://www.jetbrains.com/community/opensource/#support');
                                },
                                child: Image.asset(
                                  'assets/jb_beam.png',
                                  height: 150,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

class _BodyHomeScreen extends StatefulWidget {
  const _BodyHomeScreen({Key? key}) : super(key: key);

  @override
  State<_BodyHomeScreen> createState() => _BodyHomeScreenState();
}

class _BodyHomeScreenState extends State<_BodyHomeScreen>
    with AutomaticKeepAliveClientMixin {
  final List<PlutoColumn> columns = [];

  final List<PlutoRow> rows = [];

  final List<PlutoMenuItem> bodyMenuItems = [];

  late final CodeController codeController;

  @override
  void initState() {
    super.initState();

    columns.addAll([
      PlutoColumn(
        title: 'Text',
        field: 'text_column',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Number',
        field: 'number_column',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Date',
        field: 'date_column',
        type: PlutoColumnType.date(),
      ),
      PlutoColumn(
        title: 'Time',
        field: 'time_column',
        type: PlutoColumnType.time(),
      ),
      PlutoColumn(
        title: 'Select',
        field: 'select_column',
        type: PlutoColumnType.select(
          ['PlutoGrid', 'PlutoMenuBar', 'PlutoLayout'],
        ),
      ),
    ]);

    rows.addAll([
      PlutoRow(
        cells: {
          'text_column': PlutoCell(value: 'Text 1'),
          'number_column': PlutoCell(value: 12345),
          'date_column': PlutoCell(value: '2022-01-01'),
          'time_column': PlutoCell(value: '12:30'),
          'select_column': PlutoCell(value: 'PlutoGrid'),
        },
      ),
      PlutoRow(
        cells: {
          'text_column': PlutoCell(value: 'Text 2'),
          'number_column': PlutoCell(value: 12345),
          'date_column': PlutoCell(value: '2022-02-01'),
          'time_column': PlutoCell(value: '05:30'),
          'select_column': PlutoCell(value: 'PlutoMenuBar'),
        },
      ),
      PlutoRow(
        cells: {
          'text_column': PlutoCell(value: 'Text 3'),
          'number_column': PlutoCell(value: 12345),
          'date_column': PlutoCell(value: '2022-03-01'),
          'time_column': PlutoCell(value: '07:25'),
          'select_column': PlutoCell(value: 'PlutoLayout'),
        },
      ),
    ]);

    bodyMenuItems.addAll([
      PlutoMenuItem(title: 'Menu1', children: [
        PlutoMenuItem(title: 'Menu1-1', children: [
          PlutoMenuItem(title: 'Menu1-1-1'),
          PlutoMenuItem(title: 'Menu1-1-2'),
        ]),
        PlutoMenuItem(title: 'Menu1-2'),
      ]),
      PlutoMenuItem(title: 'Menu2', children: [
        PlutoMenuItem(title: 'Menu2-1', children: [
          PlutoMenuItem(title: 'Menu2-1-1'),
          PlutoMenuItem(title: 'Menu2-1-2'),
        ]),
        PlutoMenuItem(title: 'Menu2-2'),
      ]),
      PlutoMenuItem(title: 'Menu3', children: [
        PlutoMenuItem(title: 'Menu3-1', children: [
          PlutoMenuItem(title: 'Menu3-1-1'),
          PlutoMenuItem(title: 'Menu3-1-2'),
        ]),
        PlutoMenuItem(title: 'Menu3-2'),
      ]),
    ]);

    codeController = CodeController(
      text: exampleCode,
      language: dart,
      theme: darculaTheme,
    );
  }

  @override
  void dispose() {
    codeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800),
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.all(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ExampleText.bodyTitle),
                SizedBox(height: 15),
                Text(ExampleText.bodyDesc1),
                SizedBox(height: 50),
                Text(ExampleText.bodyPlutoGridTitle),
                SizedBox(height: 15),
                Text(ExampleText.bodyPlutoGridDesc1),
                SizedBox(height: 10),
                SizedBox(
                  height: 300,
                  child: PlutoGrid(
                    columns: columns,
                    rows: rows,
                    configuration: PlutoGridConfiguration(
                      style: PlutoGridStyleConfig.dark(
                        gridBackgroundColor: theme.dialogBackgroundColor,
                        borderColor: theme.dividerColor,
                        rowColor: theme.dialogBackgroundColor,
                        activatedColor: theme.backgroundColor,
                        activatedBorderColor: theme.toggleableActiveColor,
                        gridBorderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Text(ExampleText.bodyPlutoMenuBarTitle),
                SizedBox(height: 15),
                Text(ExampleText.bodyPlutoMenuBarDesc1),
                SizedBox(height: 10),
                PlutoMenuBar(
                  mode: PlutoMenuBarMode.hover,
                  backgroundColor: theme.dialogBackgroundColor,
                  moreIconColor: theme.toggleableActiveColor,
                  textStyle: TextStyle(
                    color: theme.primaryColorLight,
                  ),
                  menus: bodyMenuItems,
                ),
                SizedBox(height: 50),
                Text(ExampleText.bodyCodeFieldTitle),
                SizedBox(height: 15),
                Text(ExampleText.bodyCodeFieldDesc1),
                SizedBox(height: 10),
                CodeField(controller: codeController, maxLines: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _AboutMeScreen extends StatelessWidget {
  const _AboutMeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800),
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.all(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About Me'),
                SizedBox(height: 15),
                Text(
                  'I develop Flutter packages as a hobby as a backend developer.\n'
                  'I am interested in developing CMS or administrator services.\n'
                  'I like to improve the convenience of users who use CMS or administrator services.\n',
                  textAlign: TextAlign.left,
                ),
                Wrap(
                  direction: Axis.vertical,
                  spacing: 10.0,
                  children: [
                    TextButton.icon(
                      label: Text('Github'),
                      onPressed: () => launchUrl('https://github.com/bosskmk'),
                      icon: const FaIcon(FontAwesomeIcons.github),
                    ),
                    TextButton.icon(
                      label: Text('Youtube'),
                      onPressed: () => launchUrl(
                          'https://www.youtube.com/channel/UCNhIXBPlLI_y8wkQQw-_ImQ'),
                      icon: const FaIcon(
                        FontAwesomeIcons.youtube,
                        color: Color(0xFFFD0001),
                        size: 22,
                      ),
                    ),
                    TextButton.icon(
                      label: Text('Twitch'),
                      onPressed: () =>
                          launchUrl('https://www.twitch.tv/bosskmk'),
                      icon: const FaIcon(
                        FontAwesomeIcons.twitch,
                        color: Color(0xFF9447FE),
                      ),
                    ),
                    TextButton.icon(
                      label: Text('Pub.dev'),
                      onPressed: () => launchUrl(
                          'https://pub.dev/publishers/weblaze.dev/packages'),
                      icon: const FaIcon(
                        FontAwesomeIcons.link,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void launchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (await url_launcher.canLaunchUrl(uri)) {
    url_launcher.launchUrl(uri);
  }
}

const exampleCode = '''
// https://pub.dev/packages/code_text_field
class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final List<PlutoMenuItem> menuItems = [];

  final List<PlutoColumn> columns = [];

  final List<PlutoRow> rows = [];

  final List<PlutoMenuItem> bodyMenuItems = [];

  late final CodeController codeController;

  late final String exampleCode;

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

    columns.addAll([
      PlutoColumn(
        title: 'Column1',
        field: 'column1',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Column2',
        field: 'column2',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Column3',
        field: 'column3',
        type: PlutoColumnType.text(),
      ),
    ]);

    rows.addAll([
      PlutoRow(
        cells: {
          'column1': PlutoCell(value: ''),
          'column2': PlutoCell(value: ''),
          'column3': PlutoCell(value: ''),
        },
      ),
      PlutoRow(
        cells: {
          'column1': PlutoCell(value: ''),
          'column2': PlutoCell(value: ''),
          'column3': PlutoCell(value: ''),
        },
      ),
      PlutoRow(
        cells: {
          'column1': PlutoCell(value: ''),
          'column2': PlutoCell(value: ''),
          'column3': PlutoCell(value: ''),
        },
      ),
    ]);

    bodyMenuItems.addAll([
      PlutoMenuItem(title: 'Menu1', children: [
        PlutoMenuItem(title: 'Menu1-1', children: [
          PlutoMenuItem(title: 'Menu1-1-1'),
          PlutoMenuItem(title: 'Menu1-1-2'),
        ]),
        PlutoMenuItem(title: 'Menu1-2'),
      ]),
      PlutoMenuItem(title: 'Menu2', children: [
        PlutoMenuItem(title: 'Menu2-1', children: [
          PlutoMenuItem(title: 'Menu2-1-1'),
          PlutoMenuItem(title: 'Menu2-1-2'),
        ]),
        PlutoMenuItem(title: 'Menu2-2'),
      ]),
      PlutoMenuItem(title: 'Menu3', children: [
        PlutoMenuItem(title: 'Menu3-1', children: [
          PlutoMenuItem(title: 'Menu3-1-1'),
          PlutoMenuItem(title: 'Menu3-1-2'),
        ]),
        PlutoMenuItem(title: 'Menu3-2'),
      ]),
    ]);

    codeController = CodeController(
      language: dart,
      theme: darculaTheme,
    );

    // final exampleFile = File('');
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
                  id: ExampleText.aboutTitle,
                  title: ExampleText.aboutTitle,
                  tabViewBuilder: (c) {
                    return Padding(
                      padding: EdgeInsets.all(15),
                      child: ListView(
                        children: const [
                          Text(ExampleText.aboutTitle),
                          SizedBox(height: 15),
                          Text(ExampleText.aboutDesc1),
                          SizedBox(height: 10),
                          Text(ExampleText.aboutDesc2),
                        ],
                      ),
                    );
                  },
                ),
                PlutoLayoutTabItem(
                  id: ExampleText.aboutLayoutTitle,
                  title: ExampleText.aboutLayoutTitle,
                  tabViewBuilder: (c) {
                    return Padding(
                      padding: EdgeInsets.all(15),
                      child: ListView(
                        children: const [
                          Text(ExampleText.aboutLayoutTitle),
                          SizedBox(height: 15),
                          Text(ExampleText.aboutLayoutDesc1),
                          SizedBox(height: 10),
                          Text(ExampleText.aboutLayoutDesc2),
                        ],
                      ),
                    );
                  },
                ),
                PlutoLayoutTabItem(
                  id: ExampleText.nestedTabsTitle,
                  title: ExampleText.nestedTabsTitle,
                  tabViewBuilder: (c) {
                    return Padding(
                      padding: EdgeInsets.all(15),
                      child: ListView(
                        children: const [
                          Text(ExampleText.nestedTabsTitle),
                          SizedBox(height: 15),
                          Text(ExampleText.nestedTabsDesc1),
                          SizedBox(height: 10),
                          Text(ExampleText.nestedTabsDesc2),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          body: PlutoLayoutContainer(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 800),
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.all(50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ExampleText.bodyTitle),
                        SizedBox(height: 15),
                        Text(ExampleText.bodyDesc1),
                        SizedBox(height: 50),
                        Text(ExampleText.bodyPlutoGridTitle),
                        SizedBox(height: 15),
                        Text(ExampleText.bodyPlutoGridDesc1),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 300,
                          child: PlutoGrid(
                            columns: columns,
                            rows: rows,
                            configuration: PlutoGridConfiguration(
                              style: PlutoGridStyleConfig.dark(
                                gridBackgroundColor:
                                    theme.dialogBackgroundColor,
                                borderColor: theme.dividerColor,
                                rowColor: theme.dialogBackgroundColor,
                                activatedColor: theme.backgroundColor,
                                activatedBorderColor:
                                    theme.toggleableActiveColor,
                                gridBorderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        Text(ExampleText.bodyPlutoMenuBarTitle),
                        SizedBox(height: 15),
                        Text(ExampleText.bodyPlutoMenuBarDesc1),
                        SizedBox(height: 10),
                        PlutoMenuBar(
                          mode: PlutoMenuBarMode.hover,
                          backgroundColor: theme.dialogBackgroundColor,
                          moreIconColor: theme.toggleableActiveColor,
                          textStyle: TextStyle(
                            color: theme.primaryColorLight,
                          ),
                          menus: bodyMenuItems,
                        ),
                        SizedBox(height: 50),
                        Text(ExampleText.bodyCodeFieldTitle),
                        SizedBox(height: 15),
                        Text(ExampleText.bodyCodeFieldDesc1),
                        SizedBox(height: 10),
                        CodeField(controller: codeController),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          right: PlutoLayoutContainer(
            child: PlutoLayoutTabs(
              items: [
                PlutoLayoutTabItem(
                  id: ExampleText.donateTitle,
                  title: ExampleText.donateTitle,
                  tabViewBuilder: (c) {
                    return Padding(
                      padding: EdgeInsets.all(15),
                      child: ListView(
                        children: [
                          Text(ExampleText.donateTitle),
                          SizedBox(height: 15),
                          Text(ExampleText.donateDesc1),
                          SizedBox(height: 50),
                          Center(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  launchUrl(
                                      'https://github.com/sponsors/bosskmk');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.all(15),
                                  constraints: BoxConstraints(
                                    maxWidth: 213.7,
                                    minHeight: 32,
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.favorite, color: Colors.pink),
                                      Expanded(
                                        child: Text(
                                          'Github Sponsor',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            overflow: TextOverflow.fade,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  launchUrl(
                                      'https://www.buymeacoffee.com/manki');
                                },
                                child: Image.asset(
                                  'assets/buy_me_a_coffee.png',
                                  height: 60,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                PlutoLayoutTabItem(
                  id: ExampleText.jetbrainsTitle,
                  title: ExampleText.jetbrainsTitle,
                  tabViewBuilder: (c) {
                    return Padding(
                      padding: EdgeInsets.all(15),
                      child: ListView(
                        children: [
                          Text(ExampleText.jetbrainsTitle),
                          SizedBox(height: 15),
                          Text(ExampleText.jetbrainsDesc1),
                          SizedBox(height: 50),
                          Center(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  launchUrl(
                                      'https://www.jetbrains.com/community/opensource/#support');
                                },
                                child: Image.asset(
                                  'assets/jb_beam.png',
                                  height: 150,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
''';
