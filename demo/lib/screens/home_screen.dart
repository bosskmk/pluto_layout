import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';

import '../example_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final List<PlutoColumn> columns = [];

  final List<PlutoRow> rows = [];

  final List<PlutoMenuItem> bodyMenuItems = [];

  @override
  bool get wantKeepAlive => true;

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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(ExampleText.bodyTitle),
                const SizedBox(height: 15),
                const Text(ExampleText.bodyDesc1),
                const SizedBox(height: 50),
                const Text(ExampleText.bodyPlutoGridTitle),
                const SizedBox(height: 15),
                const Text(ExampleText.bodyPlutoGridDesc1),
                const SizedBox(height: 10),
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
                const SizedBox(height: 50),
                const Text(ExampleText.bodyPlutoMenuBarTitle),
                const SizedBox(height: 15),
                const Text(ExampleText.bodyPlutoMenuBarDesc1),
                const SizedBox(height: 10),
                PlutoMenuBar(
                  mode: PlutoMenuBarMode.hover,
                  backgroundColor: theme.dialogBackgroundColor,
                  moreIconColor: theme.toggleableActiveColor,
                  textStyle: TextStyle(
                    color: theme.primaryColorLight,
                  ),
                  menus: bodyMenuItems,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
