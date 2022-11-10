import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_layout/src/widgets/toggle_button.dart';

import '../../helper/build_widget_helper.dart';

void main() {
  testWidgets('delete 키로 tab1 을 삭제하면 tab1 메뉴가 삭제 되어야 한다.', (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.delete):
            PlutoLayoutActions.removeTabItem(PlutoLayoutId.left, 'tab1'),
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
        ),
      ),
    );

    await tester.tap(find.text('body container'));

    expect(find.text('tab1'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.delete);
    await tester.pump();

    expect(find.text('tab1'), findsNothing);
  });

  testWidgets('tab1 에 remove 버튼이 렌더링 되어야 한다.', (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      body: const PlutoLayoutContainer(child: Text('body container')),
      left: PlutoLayoutContainer(
        child: PlutoLayoutTabs(
          items: [
            PlutoLayoutTabItem(
              id: 'tab1',
              title: 'tab1',
              showRemoveButton: true,
              tabViewBuilder: (c) => const Text('tab1 view'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('body container'));

    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('showRemoveButton 이 false 면 tab1 에 remove 버튼이 렌더링 되지 않아야 한다.',
      (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      body: const PlutoLayoutContainer(child: Text('body container')),
      left: PlutoLayoutContainer(
        child: PlutoLayoutTabs(
          items: [
            PlutoLayoutTabItem(
              id: 'tab1',
              title: 'tab1',
              showRemoveButton: false,
              tabViewBuilder: (c) => const Text('tab1 view'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('body container'));

    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('tab1 의 remove 버튼을 탭하면 tab1 이 삭제 되어야 한다.', (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      body: const PlutoLayoutContainer(child: Text('body container')),
      left: PlutoLayoutContainer(
        child: PlutoLayoutTabs(
          items: [
            PlutoLayoutTabItem(
              id: 'tab1',
              title: 'tab1',
              showRemoveButton: true,
              tabViewBuilder: (c) => const Text('tab1 view'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('body container'));

    expect(find.text('tab1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    expect(find.text('tab1'), findsNothing);
  });

  testWidgets(
    'showOneMust 모드에서 tab1 이 활성화 된 상태에서, '
    'tab1을 삭제하면 tab2 가 활성화 되어야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayout(
        tester,
        body: const PlutoLayoutContainer(child: Text('body container')),
        left: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
            mode: PlutoLayoutTabMode.showOneMust,
            items: [
              PlutoLayoutTabItem(
                id: 'tab1',
                title: 'tab1',
                showRemoveButton: true,
                tabViewBuilder: (c) => const Text('tab1 view'),
              ),
              PlutoLayoutTabItem(
                id: 'tab2',
                title: 'tab2',
                showRemoveButton: true,
                tabViewBuilder: (c) => const Text('tab2 view'),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('body container'));

      expect(find.text('tab1 view'), findsOneWidget);
      expect(find.text('tab2 view'), findsNothing);

      final removeButton = find.descendant(
        of: find.ancestor(
          of: find.text('tab1'),
          matching: find.byType(ToggleButton),
        ),
        matching: find.byIcon(Icons.close),
      );

      await tester.tap(removeButton);
      await tester.pumpAndSettle();

      expect(find.text('tab1 view'), findsNothing);
      expect(find.text('tab2 view'), findsOneWidget);
    },
  );

  testWidgets(
    'showOneMust 모드에서 tab2 가 활성화 된 상태에서, '
    'tab2을 삭제하면 tab1 가 활성화 되어야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayout(
        tester,
        body: const PlutoLayoutContainer(child: Text('body container')),
        left: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
            mode: PlutoLayoutTabMode.showOneMust,
            items: [
              PlutoLayoutTabItem(
                id: 'tab1',
                title: 'tab1',
                showRemoveButton: true,
                tabViewBuilder: (c) => const Text('tab1 view'),
              ),
              PlutoLayoutTabItem(
                id: 'tab2',
                title: 'tab2',
                enabled: true,
                showRemoveButton: true,
                tabViewBuilder: (c) => const Text('tab2 view'),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('body container'));

      expect(find.text('tab1 view'), findsNothing);
      expect(find.text('tab2 view'), findsOneWidget);

      final removeButton = find.descendant(
        of: find.ancestor(
          of: find.text('tab2'),
          matching: find.byType(ToggleButton),
        ),
        matching: find.byIcon(Icons.close),
      );

      await tester.tap(removeButton);
      await tester.pumpAndSettle();

      expect(find.text('tab1 view'), findsOneWidget);
      expect(find.text('tab2 view'), findsNothing);
    },
  );
}
