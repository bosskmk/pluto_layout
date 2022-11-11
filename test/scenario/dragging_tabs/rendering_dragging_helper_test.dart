import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../../helper/build_widget_helper.dart';

void main() {
  testWidgets(
    'top 메뉴가 2개, 나머지는 없는 상태에서, '
    'top 메뉴를 드래그하면 드래깅 헬퍼 위젯이 3개 렌더링 되어야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayoutWithTabs(
        tester,
        topItems: [
          PlutoLayoutTabItem(id: 'top1', title: 'top1'),
          PlutoLayoutTabItem(id: 'top2', title: 'top2'),
        ],
      );

      final menuPosition = tester.getCenter(find.text('top1'));
      final gesture = await tester.startGesture(menuPosition);
      await gesture.moveTo(menuPosition + const Offset(30, 0));
      await tester.pumpAndSettle();

      // 드래그 하는 위젯의 영역은 렌더링 되지 않는다.
      expect(
        find.byKey(const ValueKey('_DraggableDragging_top')),
        findsNothing,
      );
      // 드래그 하는 위젯의 영역이 아니면 렌더링 된다.
      expect(
        find.byKey(const ValueKey('_DraggableDragging_left')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('_DraggableDragging_right')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('_DraggableDragging_bottom')),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'top 메뉴가 2개, 나머지는 없고 top  만 draggable 인 상태에서, '
    'top 메뉴를 드래그하면 드래깅 헬퍼 위젯이 0개 렌더링 되어야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayoutWithTabs(
        tester,
        topItems: [
          PlutoLayoutTabItem(id: 'top1', title: 'top1'),
          PlutoLayoutTabItem(id: 'top2', title: 'top2'),
        ],
        draggableTop: true,
        draggableLeft: false,
        draggableRight: false,
        draggableBottom: false,
      );

      final menuPosition = tester.getCenter(find.text('top1'));
      final gesture = await tester.startGesture(menuPosition);
      await gesture.moveTo(menuPosition + const Offset(30, 0));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('_DraggableDragging_top')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('_DraggableDragging_left')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('_DraggableDragging_right')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('_DraggableDragging_bottom')),
        findsNothing,
      );
    },
  );

  testWidgets(
    'top 메뉴가 2개, 나머지는 없고 top, left 만 draggable 인 상태에서, '
    'top 메뉴를 드래그하면 드래깅 헬퍼 위젯이 1개 렌더링 되어야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayoutWithTabs(
        tester,
        topItems: [
          PlutoLayoutTabItem(id: 'top1', title: 'top1'),
          PlutoLayoutTabItem(id: 'top2', title: 'top2'),
        ],
        draggableTop: true,
        draggableLeft: true,
        draggableRight: false,
        draggableBottom: false,
      );

      final menuPosition = tester.getCenter(find.text('top1'));
      final gesture = await tester.startGesture(menuPosition);
      await gesture.moveTo(menuPosition + const Offset(30, 0));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('_DraggableDragging_top')),
        findsNothing,
      );
      // draggable 이 true 이고 드래그 하는 위젯의 영역이 아니면 렌더링 된다.
      expect(
        find.byKey(const ValueKey('_DraggableDragging_left')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('_DraggableDragging_right')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('_DraggableDragging_bottom')),
        findsNothing,
      );
    },
  );

  testWidgets(
    'top 메뉴를 드래그 하면 top 메뉴가 2개 렌더링 되어야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayoutWithTabs(
        tester,
        topItems: [
          PlutoLayoutTabItem(id: 'top1', title: 'top1'),
          PlutoLayoutTabItem(id: 'top2', title: 'top2'),
        ],
        leftItems: [
          PlutoLayoutTabItem(id: 'left1', title: 'left1'),
          PlutoLayoutTabItem(id: 'left2', title: 'left2'),
        ],
        draggableTop: true,
        draggableLeft: false,
        draggableRight: false,
        draggableBottom: false,
      );

      final menuPosition = tester.getCenter(find.text('top2'));
      final gesture = await tester.startGesture(menuPosition);
      await gesture.moveTo(menuPosition + const Offset(30, 0));
      await tester.pumpAndSettle();

      // 원래 메뉴, 드래그 피드백
      expect(find.text('top2'), findsNWidgets(2));
    },
  );

  testWidgets(
    'top 메뉴를 left 메뉴의 _DraggableDragging 위로 드래그 하면, '
    'top 메뉴가 3개 렌더링 되어야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayoutWithTabs(
        tester,
        topItems: [
          PlutoLayoutTabItem(id: 'top1', title: 'top1'),
          PlutoLayoutTabItem(id: 'top2', title: 'top2'),
        ],
        leftItems: [
          PlutoLayoutTabItem(id: 'left1', title: 'left1'),
          PlutoLayoutTabItem(id: 'left2', title: 'left2'),
        ],
        draggableTop: true,
        draggableLeft: true,
        draggableRight: false,
        draggableBottom: false,
      );

      final menuPosition = tester.getCenter(find.text('top1'));
      final gesture = await tester.startGesture(menuPosition);
      await gesture.moveTo(menuPosition + const Offset(30, 0));
      await tester.pumpAndSettle();
      final dragPosition = tester.getCenter(
        find.byKey(const ValueKey('_DraggableDragging_left')),
      );
      await gesture.moveTo(dragPosition);
      await tester.pumpAndSettle();

      // 원래 메뉴, 드래그 피드백, 드래그 헬퍼
      expect(find.text('top1'), findsNWidgets(3));
    },
  );
}
