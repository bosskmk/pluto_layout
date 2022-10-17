import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../helper/build_widget_helper.dart';

void main() {
  testWidgets('body 에 전달한 위젯이 렌더링 되어야 한다.', (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      body: const PlutoLayoutContainer(
        child: Text('body container'),
      ),
    );

    expect(find.text('body container'), findsOneWidget);
  });

  testWidgets('top 에 전달한 위젯이 렌더링 되어야 한다.', (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      body: const PlutoLayoutContainer(
        child: Text('body container'),
      ),
      top: const PlutoLayoutContainer(
        child: Text('top container'),
      ),
    );

    expect(find.text('body container'), findsOneWidget);
    expect(find.text('top container'), findsOneWidget);
  });

  testWidgets('left 에 전달한 위젯이 렌더링 되어야 한다.', (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      body: const PlutoLayoutContainer(
        child: Text('body container'),
      ),
      left: const PlutoLayoutContainer(
        child: Text('left container'),
      ),
    );

    expect(find.text('body container'), findsOneWidget);
    expect(find.text('left container'), findsOneWidget);
  });

  testWidgets('right 에 전달한 위젯이 렌더링 되어야 한다.', (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      body: const PlutoLayoutContainer(
        child: Text('body container'),
      ),
      right: const PlutoLayoutContainer(
        child: Text('right container'),
      ),
    );

    expect(find.text('body container'), findsOneWidget);
    expect(find.text('right container'), findsOneWidget);
  });

  testWidgets('bottom 에 전달한 위젯이 렌더링 되어야 한다.', (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      body: const PlutoLayoutContainer(
        child: Text('body container'),
      ),
      bottom: const PlutoLayoutContainer(
        child: Text('bottom container'),
      ),
    );

    expect(find.text('body container'), findsOneWidget);
    expect(find.text('bottom container'), findsOneWidget);
  });

  testWidgets('shortcuts 를 전달하지 않으면 Shortcuts 위젯이 렌더링 되지 않아야 한다.',
      (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      body: const PlutoLayoutContainer(
        child: Text('body container'),
      ),
      shortcuts: null,
    );

    final shortcuts = find
        .byType(Shortcuts)
        .evaluate()
        .map<Shortcuts>((e) => e.widget as Shortcuts)
        .toList();

    findShortcuts(e) => e.debugLabel == 'PlutoLayout Shortcuts';

    expect(shortcuts.firstWhereOrNull(findShortcuts), null);
  });

  testWidgets('shortcuts 를 전달하면 Shortcuts 위젯이 렌더링 되어야 한다.', (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      body: const PlutoLayoutContainer(
        child: Text('body container'),
      ),
      shortcuts: {},
    );

    final shortcuts = find
        .byType(Shortcuts)
        .evaluate()
        .map<Shortcuts>((e) => e.widget as Shortcuts)
        .toList();

    findShortcuts(e) => e.debugLabel == 'PlutoLayout Shortcuts';

    expect(shortcuts.firstWhereOrNull(findShortcuts), isNot(null));
  });
}
