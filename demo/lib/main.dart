import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';
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

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  PlutoInsertTabItemResult newTabResolver(
      {required List<PlutoLayoutTabItem> items}) {
    final foundNew = items
        .where((e) => e.title.startsWith('New '))
        .map((e) => int.parse(e.title.replaceAll('New ', '')))
        .toList()
      ..sort();

    final int index = foundNew.isEmpty ? 1 : ++foundNew.last;

    return PlutoInsertTabItemResult(
      item: PlutoLayoutTabItem(
        id: '$index',
        title: 'New $index',
        enabled: false,
        showRemoveButton: true,
        tabViewWidget: _NewGrid(
          key: GlobalKey(),
          focusNode: FocusNode(),
        ),
      ),
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
          scrollbars: true,
        ),
        child: PlutoLayout(
          shortcuts: {
            LogicalKeySet(LogicalKeyboardKey.escape):
                PlutoLayoutActions.hideAllTabView(),
            LogicalKeySet(LogicalKeyboardKey.enter):
                PlutoLayoutActions.toggleTabView(),
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
            LogicalKeySet(LogicalKeyboardKey.tab):
                PlutoLayoutActions.rotateFocusedTabItem(),
            LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.tab):
                PlutoLayoutActions.rotateFocusedTabItem(reverse: true),
            LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.control,
                    LogicalKeyboardKey.arrowRight):
                PlutoLayoutActions.rotateFocusedContainer(),
            LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.control,
                    LogicalKeyboardKey.arrowLeft):
                PlutoLayoutActions.rotateFocusedContainer(reverse: true),
            LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.keyN):
                PlutoLayoutActions.insertTabItem(
              layoutId: PlutoLayoutId.body,
              itemResolver: newTabResolver,
            ),
            LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.keyW):
                PlutoLayoutActions.removeTabItem(),
          },
          body: const PlutoLayoutContainer(
            child: HomeScreen(),
          ),
          top: PlutoLayoutContainer(
            child: TopTab(newTabResolver: newTabResolver),
          ),
          left: const PlutoLayoutContainer(
            child: LeftTab(),
          ),
          right: const PlutoLayoutContainer(
            child: RightTab(),
          ),
          bottom: const PlutoLayoutContainer(
            child: BottomTab(),
          ),
        ),
      ),
    );
  }
}

class _NewGrid extends StatefulWidget
    implements PlutoLayoutTabViewWidgetHasFocusNode {
  const _NewGrid({
    required this.focusNode,
    super.key,
  });

  @override
  final FocusNode focusNode;

  @override
  State<_NewGrid> createState() => _NewGridState();
}

class _NewGridState extends State<_NewGrid> {
  late final PlutoGridStateManager stateManager;

  final List<PlutoColumn> columns = List.generate(20, (i) => i)
      .map(
        (e) => PlutoColumn(
          title: '$e',
          field: '$e',
          type: PlutoColumnType.text(),
        ),
      )
      .toList();

  final List<PlutoRow> rows = [];

  @override
  void initState() {
    super.initState();

    rows.addAll(
      List.generate(100, (i) => i).map(
        (e) => PlutoRow(
          cells: Map.fromEntries(columns.map(
            (e) => MapEntry(
              e.field,
              PlutoCell(value: ''),
            ),
          )),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Focus(
      focusNode: widget.focusNode,
      onFocusChange: (flag) {
        if (widget.focusNode.hasPrimaryFocus) {
          stateManager.setKeepFocus(flag);
        }
      },
      child: PlutoGrid(
        columns: columns,
        rows: rows,
        onLoaded: (e) {
          stateManager = e.stateManager;
          stateManager.setShowColumnFilter(true, notify: false);
          stateManager.setCurrentCell(stateManager.firstCell, 0);
        },
        configuration: PlutoGridConfiguration(
          shortcut: PlutoGridShortcut(
            actions: {
              ...PlutoGridShortcut.defaultActions,
              LogicalKeySet(LogicalKeyboardKey.escape):
                  _SetParentFocus(context),
            },
          ),
          style: PlutoGridStyleConfig.dark(
            gridBackgroundColor: theme.dialogBackgroundColor,
            borderColor: theme.dividerColor,
            rowColor: theme.dialogBackgroundColor,
            activatedColor: theme.focusColor,
            activatedBorderColor: theme.toggleableActiveColor,
          ),
        ),
      ),
    );
  }
}

class _SetParentFocus extends PlutoGridShortcutAction {
  _SetParentFocus(this.context);

  final BuildContext context;

  @override
  void execute({
    required PlutoKeyManagerEvent keyEvent,
    required PlutoGridStateManager stateManager,
  }) {
    if (!stateManager.isEditing && !stateManager.mode.isPopup) {
      PlutoLayoutContainer.getFocusNode(context)?.requestFocus();
      return;
    }

    const PlutoGridActionDefaultEscapeKey().execute(
      keyEvent: keyEvent,
      stateManager: stateManager,
    );
  }
}
