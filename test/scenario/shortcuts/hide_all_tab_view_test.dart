import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../../helper/build_widget_helper.dart';

void main() {
  Future<void> buildAddTabs(
    WidgetTester tester, {
    bool enableTop1 = true,
    bool enableTop2 = true,
    bool enableLeft1 = true,
    bool enableLeft2 = true,
    bool enableRight1 = true,
    bool enableRight2 = true,
    bool enableBottom1 = true,
    bool enableBottom2 = true,
    PlutoLayoutTabMode topMode = PlutoLayoutTabMode.showSelected,
    PlutoLayoutTabMode leftMode = PlutoLayoutTabMode.showSelected,
    PlutoLayoutTabMode rightMode = PlutoLayoutTabMode.showSelected,
    PlutoLayoutTabMode bottomMode = PlutoLayoutTabMode.showSelected,
  }) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.escape):
            PlutoLayoutActions.hideAllTabView(),
      },
      body: const PlutoLayoutContainer(child: Text('body container')),
      top: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        mode: topMode,
        items: [
          PlutoLayoutTabItem(
            id: 'top1',
            title: 'top1',
            enabled: enableTop1,
            tabViewBuilder: (c) => const Text('top1 view'),
          ),
          PlutoLayoutTabItem(
            id: 'top2',
            title: 'top2',
            enabled: enableTop2,
            tabViewBuilder: (c) => const Text('top2 view'),
          ),
        ],
      )),
      left: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        mode: leftMode,
        items: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            enabled: enableLeft1,
            tabViewBuilder: (c) => const Text('left1 view'),
          ),
          PlutoLayoutTabItem(
            id: 'left2',
            title: 'left2',
            enabled: enableLeft2,
            tabViewBuilder: (c) => const Text('left2 view'),
          ),
        ],
      )),
      right: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        mode: rightMode,
        items: [
          PlutoLayoutTabItem(
            id: 'right1',
            title: 'right1',
            enabled: enableRight1,
            tabViewBuilder: (c) => const Text('right1 view'),
          ),
          PlutoLayoutTabItem(
            id: 'right2',
            title: 'right2',
            enabled: enableRight2,
            tabViewBuilder: (c) => const Text('right2 view'),
          ),
        ],
      )),
      bottom: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        mode: bottomMode,
        items: [
          PlutoLayoutTabItem(
            id: 'bottom1',
            title: 'bottom1',
            enabled: enableBottom1,
            tabViewBuilder: (c) => const Text('bottom1 view'),
          ),
          PlutoLayoutTabItem(
            id: 'bottom2',
            title: 'bottom2',
            enabled: enableBottom2,
            tabViewBuilder: (c) => const Text('bottom2 view'),
          ),
        ],
      )),
    );
  }

  testWidgets(
      'top, left, right, bottom 탭뷰를 열어 놓은 상태에서, '
      'ESC 키를 등록하여 모든 탭뷰를 닫을 수 있어야 한다.', (tester) async {
    await buildAddTabs(tester);

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

  testWidgets(
    'left 모드가 showOneMust 인 경우 모든 아이템이 enable false 여도, '
    '첫번째 탭이 활성화 되어야 한다.',
    (tester) async {
      await buildAddTabs(
        tester,
        leftMode: PlutoLayoutTabMode.showOneMust,
        enableLeft1: false,
        enableLeft2: false,
      );

      await tester.tap(find.text('body container'));

      expect(find.text('left1 view'), findsOneWidget);
      expect(find.text('left2 view'), findsNothing);
    },
  );

  testWidgets(
    'left 모드가 showOneMust 인 경우 두번째 탭만 활성화 하면 두번째 탭이 열려져 있어야 한다.',
    (tester) async {
      await buildAddTabs(
        tester,
        leftMode: PlutoLayoutTabMode.showOneMust,
        enableLeft1: false,
        enableLeft2: true,
      );

      await tester.tap(find.text('body container'));

      expect(find.text('left1 view'), findsNothing);
      expect(find.text('left2 view'), findsOneWidget);
    },
  );

  testWidgets(
    'top, left, right, bottom 탭뷰를 열어 놓은 상태에서, '
    'ESC 키를 등록하여 모든 탭뷰를 닫으면, '
    'mode 가 showOneMust 인 left 탭은 닫히지 않아야 한다.',
    (tester) async {
      await buildAddTabs(
        tester,
        leftMode: PlutoLayoutTabMode.showOneMust,
        enableLeft1: false,
        enableLeft2: true,
      );

      await tester.tap(find.text('body container'));

      expect(find.text('top1 view'), findsOneWidget);
      expect(find.text('top2 view'), findsOneWidget);
      // showOneMust 모드에서 하나만 활성화 된다.
      expect(find.text('left1 view'), findsNothing);
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
      // 두번째 탭은 닫히지 않아야 한다.
      expect(find.text('left2 view'), findsOneWidget);
      expect(find.text('right1 view'), findsNothing);
      expect(find.text('right2 view'), findsNothing);
      expect(find.text('bottom1 view'), findsNothing);
      expect(find.text('bottom2 view'), findsNothing);
    },
  );
}
