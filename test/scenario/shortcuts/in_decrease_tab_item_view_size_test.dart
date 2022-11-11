import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_layout/src/events/events.dart';

import '../../helper/build_widget_helper.dart';

void main() {
  testWidgets('alt + arrowDown shortcuts 을 등록하여 left1 탭뷰의 넓이를 축소',
      (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowDown):
            PlutoLayoutActions.decreaseTabItemView(
          layoutId: PlutoLayoutId.left,
          itemId: 'tab1',
        ),
      },
      body: const PlutoLayoutContainer(child: Text('body container')),
      left: PlutoLayoutContainer(
        child: PlutoLayoutTabs(
          mode: PlutoLayoutTabMode.showSelected,
          items: [
            PlutoLayoutTabItem(
              id: 'tab1',
              title: 'tab1',
              enabled: true,
              tabViewBuilder: (c) => const Text('tab1 view'),
            ),
            PlutoLayoutTabItem(
              id: 'tab2',
              title: 'tab2',
              enabled: true,
              tabViewBuilder: (c) => const Text('tab2 view'),
            ),
            PlutoLayoutTabItem(
              id: 'tab3',
              title: 'tab3',
              enabled: true,
              tabViewBuilder: (c) => const Text('tab3 view'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('tab1 view'));
    await tester.pumpAndSettle();

    final beforeSize = tester.getSize(
      find.byKey(const ValueKey('_TabItemViewContainer_tab1')),
    );

    // 두번 감소
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final afterSize = tester.getSize(
      find.byKey(const ValueKey('_TabItemViewContainer_tab1')),
    );

    expect(
      beforeSize.height - afterSize.height,
      PlutoLayoutInDecreaseTabItemViewEvent.defaultSize * 2,
    );
  });

  testWidgets('alt + arrowUp shortcuts 을 등록하여 left1 탭뷰의 넓이를 증가',
      (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowUp):
            PlutoLayoutActions.increaseTabItemView(
          layoutId: PlutoLayoutId.left,
          itemId: 'tab1',
        ),
      },
      body: const PlutoLayoutContainer(child: Text('body container')),
      left: PlutoLayoutContainer(
        child: PlutoLayoutTabs(
          mode: PlutoLayoutTabMode.showSelected,
          items: [
            PlutoLayoutTabItem(
              id: 'tab1',
              title: 'tab1',
              enabled: true,
              tabViewBuilder: (c) => const Text('tab1 view'),
            ),
            PlutoLayoutTabItem(
              id: 'tab2',
              title: 'tab2',
              enabled: true,
              tabViewBuilder: (c) => const Text('tab2 view'),
            ),
            PlutoLayoutTabItem(
              id: 'tab3',
              title: 'tab3',
              enabled: true,
              tabViewBuilder: (c) => const Text('tab3 view'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('tab1 view'));
    await tester.pumpAndSettle();

    final beforeSize = tester.getSize(
      find.byKey(const ValueKey('_TabItemViewContainer_tab1')),
    );

    // 두번 증가
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final afterSize = tester.getSize(
      find.byKey(const ValueKey('_TabItemViewContainer_tab1')),
    );

    expect(
      afterSize.height - beforeSize.height,
      PlutoLayoutInDecreaseTabItemViewEvent.defaultSize * 2,
    );
  });

  testWidgets('alt + arrowDown shortcuts 을 등록하여 포커스 된 left2 탭뷰의 넓이를 감소',
      (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowDown):
            PlutoLayoutActions.decreaseTabItemView(),
      },
      body: const PlutoLayoutContainer(child: Text('body container')),
      left: PlutoLayoutContainer(
        child: PlutoLayoutTabs(
          mode: PlutoLayoutTabMode.showSelected,
          items: [
            PlutoLayoutTabItem(
              id: 'tab1',
              title: 'tab1',
              enabled: true,
              tabViewBuilder: (c) => const Text('tab1 view'),
            ),
            PlutoLayoutTabItem(
              id: 'tab2',
              title: 'tab2',
              enabled: true,
              tabViewBuilder: (c) => const Text('tab2 view'),
            ),
            PlutoLayoutTabItem(
              id: 'tab3',
              title: 'tab3',
              enabled: true,
              tabViewBuilder: (c) => const Text('tab3 view'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('tab2 view'));
    await tester.pumpAndSettle();

    final beforeSize = tester.getSize(
      find.byKey(const ValueKey('_TabItemViewContainer_tab2')),
    );

    // 두번 감소
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final afterSize = tester.getSize(
      find.byKey(const ValueKey('_TabItemViewContainer_tab2')),
    );

    expect(
      beforeSize.height - afterSize.height,
      PlutoLayoutInDecreaseTabItemViewEvent.defaultSize * 2,
    );
  });

  testWidgets('alt + arrowUp shortcuts 을 등록하여 포커스 된 left2 탭뷰의 넓이를 증가',
      (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowUp):
            PlutoLayoutActions.increaseTabItemView(),
      },
      body: const PlutoLayoutContainer(child: Text('body container')),
      left: PlutoLayoutContainer(
        child: PlutoLayoutTabs(
          mode: PlutoLayoutTabMode.showSelected,
          items: [
            PlutoLayoutTabItem(
              id: 'tab1',
              title: 'tab1',
              enabled: true,
              tabViewBuilder: (c) => const Text('tab1 view'),
            ),
            PlutoLayoutTabItem(
              id: 'tab2',
              title: 'tab2',
              enabled: true,
              tabViewBuilder: (c) => const Text('tab2 view'),
            ),
            PlutoLayoutTabItem(
              id: 'tab3',
              title: 'tab3',
              enabled: true,
              tabViewBuilder: (c) => const Text('tab3 view'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('tab2 view'));
    await tester.pumpAndSettle();

    final beforeSize = tester.getSize(
      find.byKey(const ValueKey('_TabItemViewContainer_tab2')),
    );

    // 두번 증가
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final afterSize = tester.getSize(
      find.byKey(const ValueKey('_TabItemViewContainer_tab2')),
    );

    expect(
      afterSize.height - beforeSize.height,
      PlutoLayoutInDecreaseTabItemViewEvent.defaultSize * 2,
    );
  });
}
