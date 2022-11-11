import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../../helper/build_widget_helper.dart';

void main() {
  const focusedColor = Colors.blue;

  const unfocusedColor = Colors.black;

  Future<void> buildWidget(
    WidgetTester tester, {
    String? top,
    String? left,
    String? right,
    String? bottom,
  }) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      theme: ThemeData(
        highlightColor: focusedColor,
        dividerColor: unfocusedColor,
      ),
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.tab):
            PlutoLayoutActions.rotateFocusedContainer(),
        LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.tab):
            PlutoLayoutActions.rotateFocusedContainer(reverse: true),
      },
      body: const PlutoLayoutContainer(child: Text('body container')),
      top: top == null ? null : PlutoLayoutContainer(child: Text(top)),
      left: left == null ? null : PlutoLayoutContainer(child: Text(left)),
      right: right == null ? null : PlutoLayoutContainer(child: Text(right)),
      bottom: bottom == null ? null : PlutoLayoutContainer(child: Text(bottom)),
    );
  }

  DecoratedBox getDecoratedBox(String text) {
    return find
        .descendant(
          of: find.ancestor(
            of: find.text(text),
            matching: find.byType(PlutoLayoutContainer),
          ),
          matching: find.byType(DecoratedBox),
        )
        .evaluate()
        .first
        .widget as DecoratedBox;
  }

  void testFocusBorder(Border? border, bool focus) {
    expect(border, focus ? isNot(null) : null);
    if (focus) {
      expect(border?.top.width, 1);
      expect(border?.left.width, 1);
      expect(border?.right.width, 1);
      expect(border?.top.width, 1);
      expect(border?.top.strokeAlign, StrokeAlign.outside);
      expect(border?.left.strokeAlign, StrokeAlign.outside);
      expect(border?.right.strokeAlign, StrokeAlign.outside);
      expect(border?.top.strokeAlign, StrokeAlign.outside);
      expect(border?.top.color, focusedColor);
      expect(border?.left.color, focusedColor);
      expect(border?.right.color, focusedColor);
      expect(border?.top.color, focusedColor);
    }
  }

  testWidgets(
    '최초에 body container 에 포커스 보더가 렌더링 되어야 한다.',
    (tester) async {
      await buildWidget(tester);

      final decoratedBox = getDecoratedBox('body container');
      final decoration = decoratedBox.decoration as BoxDecoration;
      final border = decoration.border as Border;
      testFocusBorder(border, true);
    },
  );

  testWidgets(
    'right 로 포커스를 변경하면 right 에 포커스 보더가 렌더링 되어야 한다.',
    (tester) async {
      await buildWidget(tester, right: 'right container');

      {
        final decoratedBox = getDecoratedBox('body container');
        final decoration = decoratedBox.decoration as BoxDecoration;
        final border = decoration.border as Border;
        testFocusBorder(border, true);
      }

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('body container');
        final decoration = decoratedBox.decoration as BoxDecoration;
        final border = decoration.border as Border?;
        testFocusBorder(border, false);
      }

      {
        final decoratedBox = getDecoratedBox('right container');
        final decoration = decoratedBox.decoration as BoxDecoration;
        final border = decoration.border as Border;
        testFocusBorder(border, true);
      }
    },
  );

  testWidgets(
    'left 로 포커스를 변경하면 left 에 포커스 보더가 렌더링 되어야 한다.',
    (tester) async {
      await buildWidget(
        tester,
        left: 'left container',
        right: 'right container',
      );

      {
        final decoratedBox = getDecoratedBox('body container');
        final decoration = decoratedBox.decoration as BoxDecoration;
        final border = decoration.border as Border;
        testFocusBorder(border, true);
      }

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shift);
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('body container');
        final decoration = decoratedBox.decoration as BoxDecoration;
        final border = decoration.border as Border?;
        testFocusBorder(border, false);
      }

      {
        final decoratedBox = getDecoratedBox('left container');
        final decoration = decoratedBox.decoration as BoxDecoration;
        final border = decoration.border as Border;
        testFocusBorder(border, true);
      }
    },
  );

  testWidgets(
    'right, left, body 순서로 포커스를 변경하면 순서대로 포커스 보더가 렌더링 되어야 한다.',
    (tester) async {
      await buildWidget(
        tester,
        left: 'left container',
        right: 'right container',
      );

      {
        final decoratedBox = getDecoratedBox('body container');
        final decoration = decoratedBox.decoration as BoxDecoration;
        final border = decoration.border as Border;
        testFocusBorder(border, true);
      }

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('right container');
        final decoration = decoratedBox.decoration as BoxDecoration;
        final border = decoration.border as Border;
        testFocusBorder(border, true);
      }

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('left container');
        final decoration = decoratedBox.decoration as BoxDecoration;
        final border = decoration.border as Border;
        testFocusBorder(border, true);
      }

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('body container');
        final decoration = decoratedBox.decoration as BoxDecoration;
        final border = decoration.border as Border;
        testFocusBorder(border, true);
      }
    },
  );

  testWidgets(
    'left, right, body 순서로 포커스를 변경하면 순서대로 포커스 보더가 렌더링 되어야 한다.',
    (tester) async {
      await buildWidget(
        tester,
        left: 'left container',
        right: 'right container',
      );

      {
        final decoratedBox = getDecoratedBox('body container');
        final decoration = decoratedBox.decoration as BoxDecoration;
        final border = decoration.border as Border;
        testFocusBorder(border, true);
      }

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shift);
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('left container');
        final decoration = decoratedBox.decoration as BoxDecoration;
        final border = decoration.border as Border;
        testFocusBorder(border, true);
      }

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shift);
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('right container');
        final decoration = decoratedBox.decoration as BoxDecoration;
        final border = decoration.border as Border;
        testFocusBorder(border, true);
      }

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shift);
      await tester.pump();

      {
        final decoratedBox = getDecoratedBox('body container');
        final decoration = decoratedBox.decoration as BoxDecoration;
        final border = decoration.border as Border;
        testFocusBorder(border, true);
      }
    },
  );
}
