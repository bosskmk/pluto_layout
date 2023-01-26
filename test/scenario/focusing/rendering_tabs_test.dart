import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../../helper/build_widget_helper.dart';

void main() {
  DecoratedBox getDecoratedBox(String tabId) {
    return find
        .ancestor(
          of: find.text(tabId),
          matching: find.byKey(const ValueKey('_MenuContainer_DecoratedBox')),
        )
        .first
        .evaluate()
        .first
        .widget as DecoratedBox;
  }

  testWidgets(
    '최초에 탭에 포커스가 없으면 포커스 보더가 렌더링 되지 않아야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayoutWithTabs(
        tester,
        leftItems: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            enabled: true,
            tabViewWidget: const Text('left1 view'),
          ),
        ],
      );

      final decoratedBox = getDecoratedBox('left1');
      final decoration = decoratedBox.decoration as BoxDecoration;
      expect(decoration.border?.bottom, BorderSide.none);
    },
  );

  testWidgets(
    '닫혀있는 탭을 열면 포커스 보더가 렌더링 되어야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayoutWithTabs(
        tester,
        leftItems: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            enabled: false,
            tabViewWidget: const Text('left1 view'),
          ),
        ],
      );

      {
        final decoratedBox = getDecoratedBox('left1');
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.border?.bottom, BorderSide.none);
        expect(find.text('left1 view'), findsNothing);
      }

      await tester.tap(find.text('left1'));
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('left1');
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.border?.bottom.width, 3);
        expect(find.text('left1 view'), findsOneWidget);
      }
    },
  );

  testWidgets(
    'left1 탭에 포커스가 있으면 보더가 렌더링 되어야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayoutWithTabs(
        tester,
        leftItems: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            enabled: true,
            tabViewWidget: const Text('left1 view'),
          ),
        ],
      );

      await tester.tap(find.text('left1 view'));
      await tester.pump();

      final decoratedBox = getDecoratedBox('left1');
      final decoration = decoratedBox.decoration as BoxDecoration;
      expect(decoration.border?.bottom.width, 3);
    },
  );

  testWidgets(
    'theme 의 toggleableActiveColor 컬러를 변경하면 변경 된 컬러로 포커스 보더가 렌더링 되어야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayoutWithTabs(
        tester,
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(secondary: Colors.blue),
        ),
        leftItems: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            enabled: true,
            tabViewWidget: const Text('left1 view'),
          ),
        ],
      );

      await tester.tap(find.text('left1 view'));
      await tester.pump();

      final decoratedBox = getDecoratedBox('left1');
      final decoration = decoratedBox.decoration as BoxDecoration;
      expect(decoration.border?.bottom.width, 3);
      expect(decoration.border?.bottom.color, Colors.blue);
    },
  );

  testWidgets(
    'left1 탭에 포커스가 있는 상태에서 탭을 닫아도 보더가 렌더링 되어야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayoutWithTabs(
        tester,
        leftItems: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            enabled: true,
            tabViewWidget: const Text('left1 view'),
          ),
        ],
      );

      await tester.tap(find.text('left1 view'));
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('left1');
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.border?.bottom.width, 3);
        expect(find.text('left1 view'), findsOneWidget);
      }

      await tester.tap(find.text('left1'));
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('left1');
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.border?.bottom.width, 3);
        expect(find.text('left1 view'), findsNothing);
      }
    },
  );

  testWidgets(
    '두개의 메뉴에서 left2 탭에 포커스가 있으면 보더가 렌더링 되어야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayoutWithTabs(
        tester,
        leftItems: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            enabled: true,
            tabViewWidget: const Text('left1 view'),
          ),
          PlutoLayoutTabItem(
            id: 'left2',
            title: 'left2',
            enabled: true,
            tabViewWidget: const Text('left2 view'),
          ),
        ],
      );

      await tester.tap(find.text('left2 view'));
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('left1');
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.border?.bottom, BorderSide.none);
      }

      {
        final decoratedBox = getDecoratedBox('left2');
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.border?.bottom.width, 3);
      }
    },
  );

  testWidgets(
    'left1 에 포커스가 있는 상태에서 left2 를 탭하면 포커스 보더가 left2 에 렌더링 되어야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayoutWithTabs(
        tester,
        leftItems: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            enabled: true,
            tabViewWidget: const Text('left1 view'),
          ),
          PlutoLayoutTabItem(
            id: 'left2',
            title: 'left2',
            enabled: true,
            tabViewWidget: const Text('left2 view'),
          ),
        ],
      );

      await tester.tap(find.text('left1 view'));
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('left1');
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.border?.bottom.width, 3);
      }

      {
        final decoratedBox = getDecoratedBox('left2');
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.border?.bottom, BorderSide.none);
      }

      await tester.tap(find.text('left2 view'));
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('left1');
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.border?.bottom, BorderSide.none);
      }

      {
        final decoratedBox = getDecoratedBox('left2');
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.border?.bottom.width, 3);
      }
    },
  );

  testWidgets(
    '포커스를 다음으로 이동하면 포커스가 순서대로 이동 되어야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayoutWithTabs(
        tester,
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.tab):
              PlutoLayoutActions.rotateFocusedTabItem(),
        },
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(secondary: Colors.blue),
        ),
        leftItems: [
          PlutoLayoutTabItem(id: 'left1', title: 'left1'),
          PlutoLayoutTabItem(id: 'left2', title: 'left2'),
          PlutoLayoutTabItem(id: 'left3', title: 'left3'),
        ],
      );

      await tester.tap(find.text('left1'));
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('left1');
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.border?.bottom.width, 3);
        expect(decoration.border?.bottom.color, Colors.blue);
      }

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('left2');
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.border?.bottom.width, 3);
        expect(decoration.border?.bottom.color, Colors.blue);
      }

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('left3');
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.border?.bottom.width, 3);
        expect(decoration.border?.bottom.color, Colors.blue);
      }
    },
  );

  testWidgets(
    '포커스를 이전으로 이동하면 포커스가 순서대로 이동 되어야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayoutWithTabs(
        tester,
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.tab):
              PlutoLayoutActions.rotateFocusedTabItem(reverse: true),
        },
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(secondary: Colors.blue),
        ),
        leftItems: [
          PlutoLayoutTabItem(id: 'left1', title: 'left1'),
          PlutoLayoutTabItem(id: 'left2', title: 'left2'),
          PlutoLayoutTabItem(id: 'left3', title: 'left3'),
        ],
      );

      await tester.tap(find.text('left1'));
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('left1');
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.border?.bottom.width, 3);
        expect(decoration.border?.bottom.color, Colors.blue);
      }

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('left3');
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.border?.bottom.width, 3);
        expect(decoration.border?.bottom.color, Colors.blue);
      }

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('left2');
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.border?.bottom.width, 3);
        expect(decoration.border?.bottom.color, Colors.blue);
      }
    },
  );
}
