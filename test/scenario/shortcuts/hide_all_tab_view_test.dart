import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../../helper/build_widget_helper.dart';

void main() {
  testWidgets(
      'top, left, right, bottom 탭뷰를 열어 놓은 상태에서, '
      'ESC 키를 등록하여 모든 탭뷰를 닫을 수 있어야 한다.', (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.escape):
            PlutoLayoutActions.hideAllTabView(),
      },
      body: const PlutoLayoutContainer(child: Text('body container')),
      top: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        items: [
          PlutoLayoutTabItem(
            id: 'top1',
            title: 'top',
            enabled: true,
            tabViewBuilder: (c) => const Text('top1 view'),
          ),
          PlutoLayoutTabItem(
            id: 'top2',
            title: 'top',
            enabled: true,
            tabViewBuilder: (c) => const Text('top2 view'),
          ),
        ],
      )),
      left: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        items: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            enabled: true,
            tabViewBuilder: (c) => const Text('left1 view'),
          ),
          PlutoLayoutTabItem(
            id: 'left2',
            title: 'left2',
            enabled: true,
            tabViewBuilder: (c) => const Text('left2 view'),
          ),
        ],
      )),
      right: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        items: [
          PlutoLayoutTabItem(
            id: 'right1',
            title: 'right1',
            enabled: true,
            tabViewBuilder: (c) => const Text('right1 view'),
          ),
          PlutoLayoutTabItem(
            id: 'right2',
            title: 'right2',
            enabled: true,
            tabViewBuilder: (c) => const Text('right2 view'),
          ),
        ],
      )),
      bottom: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        items: [
          PlutoLayoutTabItem(
            id: 'bottom1',
            title: 'bottom1',
            enabled: true,
            tabViewBuilder: (c) => const Text('bottom1 view'),
          ),
          PlutoLayoutTabItem(
            id: 'bottom2',
            title: 'bottom2',
            enabled: true,
            tabViewBuilder: (c) => const Text('bottom2 view'),
          ),
        ],
      )),
    );

    await tester.tap(find.text('body container'));

    expect(find.text('top1 view'), findsOneWidget);
    expect(find.text('top2 view'), findsOneWidget);
    expect(find.text('left1 view'), findsOneWidget);
    expect(find.text('left2 view'), findsOneWidget);
    expect(find.text('right1 view'), findsOneWidget);
    expect(find.text('right2 view'), findsOneWidget);
    expect(find.text('bottom1 view'), findsOneWidget);
    expect(find.text('bottom2 view'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('top1 view'), findsNothing);
    expect(find.text('top2 view'), findsNothing);
    expect(find.text('left1 view'), findsNothing);
    expect(find.text('left2 view'), findsNothing);
    expect(find.text('right1 view'), findsNothing);
    expect(find.text('right2 view'), findsNothing);
    expect(find.text('bottom1 view'), findsNothing);
    expect(find.text('bottom2 view'), findsNothing);
  });
}
