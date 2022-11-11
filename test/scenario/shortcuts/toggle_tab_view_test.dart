import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../../helper/build_widget_helper.dart';

void main() {
  testWidgets('alt + 1 shortcuts 을 등록하여 left 탭뷰를 toggle.', (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
            PlutoLayoutActions.toggleTabView(
          layoutId: PlutoLayoutId.left,
          itemId: 'tab1',
        ),
      },
      body: const PlutoLayoutContainer(child: Text('body container')),
      left: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        items: [
          PlutoLayoutTabItem(
            id: 'tab1',
            title: 'tab1',
            tabViewBuilder: (c) => const Text('tab1 view'),
          ),
        ],
      )),
    );

    await tester.tap(find.text('body container'));

    expect(find.text('tab1 view'), findsNothing);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    expect(find.text('tab1 view'), findsOneWidget);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    expect(find.text('tab1 view'), findsNothing);
  });
}
