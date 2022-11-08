import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_layout/pluto_layout.dart';

void main() {
  Future<void> buildWidget(
    WidgetTester tester, {
    List<PlutoLayoutTabItem>? top,
    List<PlutoLayoutTabItem>? left,
    List<PlutoLayoutTabItem>? right,
    List<PlutoLayoutTabItem>? bottom,
    bool draggableTop = true,
    bool draggableLeft = true,
    bool draggableRight = true,
    bool draggableBottom = true,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PlutoLayout(
          body: const PlutoLayoutContainer(child: Text('body container')),
          top: PlutoLayoutContainer(
              child: PlutoLayoutTabs(
            items: top ?? [],
            draggable: draggableTop,
          )),
          left: PlutoLayoutContainer(
              child: PlutoLayoutTabs(
            items: left ?? [],
            draggable: draggableLeft,
          )),
          right: PlutoLayoutContainer(
              child: PlutoLayoutTabs(
            items: right ?? [],
            draggable: draggableRight,
          )),
          bottom: PlutoLayoutContainer(
              child: PlutoLayoutTabs(
            items: bottom ?? [],
            draggable: draggableBottom,
          )),
        ),
      ),
    );
  }

  testWidgets(
    'top 메뉴만 있는 상태에서 _DraggableDragging_left 로 드래그 하면, '
    'top 메뉴가 left 로 이동 되어야 한다.',
    (tester) async {
      await buildWidget(
        tester,
        top: [
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
      await buildWidget(
        tester,
        top: [
          PlutoLayoutTabItem(id: 'top1', title: 'top1'),
          PlutoLayoutTabItem(id: 'top2', title: 'top2'),
        ],
        left: [
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
      await buildWidget(
        tester,
        top: [
          PlutoLayoutTabItem(id: 'top1', title: 'top1'),
          PlutoLayoutTabItem(id: 'top2', title: 'top2'),
        ],
        left: [
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
