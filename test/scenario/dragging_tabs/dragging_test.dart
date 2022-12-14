import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../../helper/build_widget_helper.dart';

void main() {
  testWidgets(
    'top 메뉴만 있는 상태에서 _DraggableDragging_left 로 드래그 하면, '
    'top 메뉴가 left 로 이동 되어야 한다.',
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
      final dragPosition = tester.getCenter(
        find.byKey(const ValueKey('_DraggableDragging_left')),
      );
      await gesture.moveTo(dragPosition);
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.text('top1'), findsOneWidget);
      final tabs = find.byType(PlutoLayoutTabs);
      final leftTabs = tabs.at(1).evaluate().first.widget as PlutoLayoutTabs;
      expect(leftTabs.items.length, 1);
      expect(leftTabs.items.first.title, 'top1');
    },
  );

  testWidgets(
    'top 메뉴와 left 메뉴가 있는 상태에서 _DraggableDragging_left 로 드래그 하면, '
    'top 메뉴가 left 로 이동 되어야 한다.',
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
      );

      final menuPosition = tester.getCenter(find.text('top1'));
      final gesture = await tester.startGesture(menuPosition);
      await gesture.moveTo(menuPosition + const Offset(30, 0));
      await tester.pumpAndSettle();
      final dragPosition = tester.getCenter(
        find.byKey(const ValueKey('_DraggableDragging_left')),
      );
      await gesture.moveTo(dragPosition);
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.text('top1'), findsOneWidget);
      final tabs = find.byType(PlutoLayoutTabs);
      final leftTabs = tabs.at(1).evaluate().first.widget as PlutoLayoutTabs;
      expect(leftTabs.items.length, 3);
      expect(leftTabs.items[2].title, 'top1');
    },
  );

  testWidgets(
    'top 메뉴와 left 메뉴가 있는 상태에서 left2 로 드래그 하면, '
    'top 메뉴가 left2 로 이동 되어야 한다.',
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
      );

      final menuPosition = tester.getCenter(find.text('top1'));
      final gesture = await tester.startGesture(menuPosition);
      await gesture.moveTo(menuPosition + const Offset(30, 0));
      await tester.pumpAndSettle();
      final dragPosition = tester.getCenter(find.text('left2'));
      await gesture.moveTo(dragPosition);
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.text('top1'), findsOneWidget);
      final tabs = find.byType(PlutoLayoutTabs);
      final leftTabs = tabs.at(1).evaluate().first.widget as PlutoLayoutTabs;
      expect(leftTabs.items.length, 3);
      expect(leftTabs.items[0].title, 'left1');
      expect(leftTabs.items[1].title, 'top1');
      expect(leftTabs.items[2].title, 'left2');
    },
  );
}
