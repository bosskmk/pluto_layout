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
    PlutoLayoutTabMode topMode = PlutoLayoutTabMode.showSelected,
    PlutoLayoutTabMode leftMode = PlutoLayoutTabMode.showSelected,
    PlutoLayoutTabMode rightMode = PlutoLayoutTabMode.showSelected,
    PlutoLayoutTabMode bottomMode = PlutoLayoutTabMode.showSelected,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PlutoLayout(
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
      await buildWidget(
        tester,
        left: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            enabled: true,
            tabViewBuilder: (e) => const Text('left1 view'),
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
      await buildWidget(
        tester,
        left: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            enabled: false,
            tabViewBuilder: (e) => const Text('left1 view'),
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
      await buildWidget(
        tester,
        left: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            enabled: true,
            tabViewBuilder: (e) => const Text('left1 view'),
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
    'left1 탭에 포커스가 있는 상태에서 탭을 닫으면 보더가 렌더링 되지 않아야 한다.',
    (tester) async {
      await buildWidget(
        tester,
        left: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            enabled: true,
            tabViewBuilder: (e) => const Text('left1 view'),
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
        expect(decoration.border?.bottom, BorderSide.none);
        expect(find.text('left1 view'), findsNothing);
      }
    },
  );

  testWidgets(
    '두개의 메뉴에서 left2 탭에 포커스가 있으면 보더가 렌더링 되어야 한다.',
    (tester) async {
      await buildWidget(
        tester,
        left: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            enabled: true,
            tabViewBuilder: (e) => const Text('left1 view'),
          ),
          PlutoLayoutTabItem(
            id: 'left2',
            title: 'left2',
            enabled: true,
            tabViewBuilder: (e) => const Text('left2 view'),
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
      await buildWidget(
        tester,
        left: [
          PlutoLayoutTabItem(
            id: 'left1',
            title: 'left1',
            enabled: true,
            tabViewBuilder: (e) => const Text('left1 view'),
          ),
          PlutoLayoutTabItem(
            id: 'left2',
            title: 'left2',
            enabled: true,
            tabViewBuilder: (e) => const Text('left2 view'),
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
}
