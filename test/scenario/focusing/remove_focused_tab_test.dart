import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    PlutoLayoutTabMode topMode = PlutoLayoutTabMode.showSelected,
    PlutoLayoutTabMode leftMode = PlutoLayoutTabMode.showSelected,
    PlutoLayoutTabMode rightMode = PlutoLayoutTabMode.showSelected,
    PlutoLayoutTabMode bottomMode = PlutoLayoutTabMode.showSelected,
    PlutoLayoutId? layoutIdToRemove,
    Object? itemIdToRemove,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PlutoLayout(
          shortcuts: {
            LogicalKeySet(LogicalKeyboardKey.delete):
                PlutoLayoutActions.removeTabItem(
              layoutId: layoutIdToRemove,
              itemId: itemIdToRemove,
            ),
          },
          body: const PlutoLayoutContainer(child: Text('body container')),
          top: PlutoLayoutContainer(
            child: PlutoLayoutTabs(
              mode: topMode,
              items: top ?? [],
              draggable: draggableTop,
            ),
          ),
          left: PlutoLayoutContainer(
            child: PlutoLayoutTabs(
              mode: leftMode,
              items: left ?? [],
              draggable: draggableLeft,
            ),
          ),
          right: PlutoLayoutContainer(
            child: PlutoLayoutTabs(
              mode: rightMode,
              items: right ?? [],
              draggable: draggableRight,
            ),
          ),
          bottom: PlutoLayoutContainer(
            child: PlutoLayoutTabs(
              mode: bottomMode,
              items: bottom ?? [],
              draggable: draggableBottom,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('left1 에 포커스가 있는 경우 left1 탭이 제거 되어야 한다.', (tester) async {
    await buildWidget(
      tester,
      left: [
        PlutoLayoutTabItem(
          id: 'left1',
          title: 'left1',
          tabViewWidget: const Text('left1 view'),
        ),
        PlutoLayoutTabItem(
          id: 'left2',
          title: 'left2',
          tabViewWidget: const Text('left2 view'),
        ),
      ],
    );

    await tester.tap(find.text('left1'));
    await tester.pump();

    expect(find.text('left1'), findsOneWidget);
    expect(find.text('left1 view'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.delete);
    await tester.pump();

    expect(find.text('left1'), findsNothing);
    expect(find.text('left1 view'), findsNothing);
  });

  testWidgets('left2 에 포커스가 있는 경우 left2 탭이 제거 되어야 한다.', (tester) async {
    await buildWidget(
      tester,
      left: [
        PlutoLayoutTabItem(
          id: 'left1',
          title: 'left1',
          tabViewWidget: const Text('left1 view'),
        ),
        PlutoLayoutTabItem(
          id: 'left2',
          title: 'left2',
          tabViewWidget: const Text('left2 view'),
        ),
      ],
    );

    await tester.tap(find.text('left2'));
    await tester.pump();

    expect(find.text('left2'), findsOneWidget);
    expect(find.text('left2 view'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.delete);
    await tester.pump();

    expect(find.text('left2'), findsNothing);
    expect(find.text('left2 view'), findsNothing);
  });

  testWidgets(
    'left1 에 포커스가 있는 상태에서, '
    '삭제할 id 를 left2 로 지정하면 left2 가 삭제 되어야 한다.',
    (tester) async {
      await buildWidget(
        tester,
        layoutIdToRemove: PlutoLayoutId.left,
        itemIdToRemove: 'left2',
        left: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            tabViewWidget: const Text('left1 view'),
          ),
          PlutoLayoutTabItem(
            id: 'left2',
            title: 'left2',
            tabViewWidget: const Text('left2 view'),
          ),
        ],
      );

      await tester.tap(find.text('left1'));
      await tester.pump();

      expect(find.text('left1'), findsOneWidget);
      expect(find.text('left1 view'), findsOneWidget);
      expect(find.text('left2'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.delete);
      await tester.pump();

      expect(find.text('left1'), findsOneWidget);
      expect(find.text('left1 view'), findsOneWidget);
      expect(find.text('left2'), findsNothing);
    },
  );

  testWidgets(
    'layoutId 영역에 없는 itemId 를 지정하면 아무것도 삭제 되지 않아야 한다.',
    (tester) async {
      await buildWidget(
        tester,
        layoutIdToRemove: PlutoLayoutId.right,
        itemIdToRemove: 'left2',
        left: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            tabViewWidget: const Text('left1 view'),
          ),
          PlutoLayoutTabItem(
            id: 'left2',
            title: 'left2',
            tabViewWidget: const Text('left2 view'),
          ),
        ],
      );

      await tester.tap(find.text('left1'));
      await tester.pump();

      expect(find.text('left1'), findsOneWidget);
      expect(find.text('left1 view'), findsOneWidget);
      expect(find.text('left2'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.delete);
      await tester.pump();

      expect(find.text('left1'), findsOneWidget);
      expect(find.text('left1 view'), findsOneWidget);
      expect(find.text('left2'), findsOneWidget);
    },
  );

  testWidgets(
    '잘못 된 itemId 를 지정하면 아무것도 삭제 되지 않아야 한다.',
    (tester) async {
      await buildWidget(
        tester,
        layoutIdToRemove: PlutoLayoutId.left,
        itemIdToRemove: 'left3',
        left: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            tabViewWidget: const Text('left1 view'),
          ),
          PlutoLayoutTabItem(
            id: 'left2',
            title: 'left2',
            tabViewWidget: const Text('left2 view'),
          ),
        ],
      );

      await tester.tap(find.text('left1'));
      await tester.pump();

      expect(find.text('left1'), findsOneWidget);
      expect(find.text('left1 view'), findsOneWidget);
      expect(find.text('left2'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.delete);
      await tester.pump();

      expect(find.text('left1'), findsOneWidget);
      expect(find.text('left1 view'), findsOneWidget);
      expect(find.text('left2'), findsOneWidget);
    },
  );
}
