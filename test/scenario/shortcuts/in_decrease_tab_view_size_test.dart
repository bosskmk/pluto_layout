import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../../helper/build_widget_helper.dart';

void main() {
  testWidgets('alt + arrowLeft shortcuts 을 등록하여 left 탭뷰의 넓이를 축소',
      (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
            PlutoLayoutActions.toggleTabView(
          PlutoLayoutContainerDirection.left,
          'tab1',
        ),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowLeft):
            PlutoLayoutActions.decreaseTabView(
          containerDirection: PlutoLayoutContainerDirection.left,
        ),
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
      )),
    );

    await tester.tap(find.text('body container'));

    expect(find.text('tab1 view'), findsNothing);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final beforeSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    // 두번 감소
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final afterSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    expect(
      beforeSize.width - afterSize.width,
      PlutoLayoutHasInDecreaseTabViewEvent.defaultSize * 2,
    );
  });

  testWidgets(
    'reverseByDirection 가 true 인 상태에서, '
    'alt + arrowLeft shortcuts 을 등록하여 left 탭뷰의 넓이를 축소',
    (tester) async {
      await BuildWidgetHelper.plutoLayout(
        tester,
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
              PlutoLayoutActions.toggleTabView(
            PlutoLayoutContainerDirection.left,
            'tab1',
          ),
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowLeft):
              PlutoLayoutActions.decreaseTabView(
            containerDirection: PlutoLayoutContainerDirection.left,
            reverseByDirection: true,
          ),
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
        )),
      );

      await tester.tap(find.text('body container'));

      expect(find.text('tab1 view'), findsNothing);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
      await tester.pumpAndSettle();

      final beforeSize = tester.getSize(find.ancestor(
        of: find.text('tab1 view'),
        matching: find.byType(PlutoLayoutContainer),
      ));

      // 두번 감소
      await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
      await tester.pumpAndSettle();

      final afterSize = tester.getSize(find.ancestor(
        of: find.text('tab1 view'),
        matching: find.byType(PlutoLayoutContainer),
      ));

      expect(
        beforeSize.width - afterSize.width,
        PlutoLayoutHasInDecreaseTabViewEvent.defaultSize * 2,
      );
    },
  );

  testWidgets(
    'alt + arrowLeft shortcuts 을 등록하고, '
    '축소 사이즈를 20으로 변경하여 left 탭뷰의 넓이를 축소',
    (tester) async {
      await BuildWidgetHelper.plutoLayout(
        tester,
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
              PlutoLayoutActions.toggleTabView(
            PlutoLayoutContainerDirection.left,
            'tab1',
          ),
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowLeft):
              PlutoLayoutActions.decreaseTabView(
            containerDirection: PlutoLayoutContainerDirection.left,
            size: 20,
          ),
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
        )),
      );

      await tester.tap(find.text('body container'));

      expect(find.text('tab1 view'), findsNothing);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
      await tester.pumpAndSettle();

      final beforeSize = tester.getSize(find.ancestor(
        of: find.text('tab1 view'),
        matching: find.byType(PlutoLayoutContainer),
      ));

      // 두번 감소
      await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
      await tester.pumpAndSettle();

      final afterSize = tester.getSize(find.ancestor(
        of: find.text('tab1 view'),
        matching: find.byType(PlutoLayoutContainer),
      ));

      expect(
        beforeSize.width - afterSize.width,
        20 * 2,
      );
    },
  );

  testWidgets('alt + arrowRight shortcuts 을 등록하여 left 탭뷰의 넓이를 증가',
      (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
            PlutoLayoutActions.toggleTabView(
          PlutoLayoutContainerDirection.left,
          'tab1',
        ),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowRight):
            PlutoLayoutActions.increaseTabView(
          containerDirection: PlutoLayoutContainerDirection.left,
        ),
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
      )),
    );

    await tester.tap(find.text('body container'));

    expect(find.text('tab1 view'), findsNothing);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final beforeSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    // 두번 증가
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final afterSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    expect(
      afterSize.width - beforeSize.width,
      PlutoLayoutHasInDecreaseTabViewEvent.defaultSize * 2,
    );
  });

  testWidgets(
    'reverseByDirection 가 true 인 상태에서, '
    'alt + arrowRight shortcuts 을 등록하여 left 탭뷰의 넓이를 증가',
    (tester) async {
      await BuildWidgetHelper.plutoLayout(
        tester,
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
              PlutoLayoutActions.toggleTabView(
            PlutoLayoutContainerDirection.left,
            'tab1',
          ),
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowRight):
              PlutoLayoutActions.increaseTabView(
            containerDirection: PlutoLayoutContainerDirection.left,
            reverseByDirection: true,
          ),
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
        )),
      );

      await tester.tap(find.text('body container'));

      expect(find.text('tab1 view'), findsNothing);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
      await tester.pumpAndSettle();

      final beforeSize = tester.getSize(find.ancestor(
        of: find.text('tab1 view'),
        matching: find.byType(PlutoLayoutContainer),
      ));

      // 두번 증가
      await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
      await tester.pumpAndSettle();

      final afterSize = tester.getSize(find.ancestor(
        of: find.text('tab1 view'),
        matching: find.byType(PlutoLayoutContainer),
      ));

      expect(
        afterSize.width - beforeSize.width,
        PlutoLayoutHasInDecreaseTabViewEvent.defaultSize * 2,
      );
    },
  );

  testWidgets(
    'alt + arrowRight shortcuts 을 등록하고, '
    '증가 사이즈를 3으로 변경하여 left 탭뷰의 넓이를 증가',
    (tester) async {
      await BuildWidgetHelper.plutoLayout(
        tester,
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
              PlutoLayoutActions.toggleTabView(
            PlutoLayoutContainerDirection.left,
            'tab1',
          ),
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowRight):
              PlutoLayoutActions.increaseTabView(
            containerDirection: PlutoLayoutContainerDirection.left,
            size: 3,
          ),
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
        )),
      );

      await tester.tap(find.text('body container'));

      expect(find.text('tab1 view'), findsNothing);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
      await tester.pumpAndSettle();

      final beforeSize = tester.getSize(find.ancestor(
        of: find.text('tab1 view'),
        matching: find.byType(PlutoLayoutContainer),
      ));

      // 두번 증가
      await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
      await tester.pumpAndSettle();

      final afterSize = tester.getSize(find.ancestor(
        of: find.text('tab1 view'),
        matching: find.byType(PlutoLayoutContainer),
      ));

      expect(
        afterSize.width - beforeSize.width,
        3 * 2,
      );
    },
  );

  testWidgets('alt + arrowLeft shortcuts 을 등록하여 right 탭뷰의 넓이를 증가',
      (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
            PlutoLayoutActions.toggleTabView(
          PlutoLayoutContainerDirection.right,
          'tab1',
        ),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowLeft):
            PlutoLayoutActions.increaseTabView(
          containerDirection: PlutoLayoutContainerDirection.right,
        ),
      },
      body: const PlutoLayoutContainer(child: Text('body container')),
      right: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        items: [
          PlutoLayoutTabItem(
            id: 'tab1',
            title: 'tab1',
            tabViewBuilder: (c) => const Text('tab1 view'),
          ),
        ],
      )),
    );

    await tester.tap(find.text('body container'));

    expect(find.text('tab1 view'), findsNothing);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final beforeSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    // 두번 증가
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final afterSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    expect(
      afterSize.width - beforeSize.width,
      PlutoLayoutHasInDecreaseTabViewEvent.defaultSize * 2,
    );
  });

  testWidgets(
    'reverseByDirection 가 true 인 상태에서, '
    'alt + arrowLeft shortcuts 을 등록하여 right 탭뷰 넓이 감소는 반대로 증가 되어야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayout(
        tester,
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
              PlutoLayoutActions.toggleTabView(
            PlutoLayoutContainerDirection.right,
            'tab1',
          ),
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowLeft):
              PlutoLayoutActions.decreaseTabView(
            containerDirection: PlutoLayoutContainerDirection.right,
            reverseByDirection: true,
          ),
        },
        body: const PlutoLayoutContainer(child: Text('body container')),
        right: PlutoLayoutContainer(
            child: PlutoLayoutTabs(
          items: [
            PlutoLayoutTabItem(
              id: 'tab1',
              title: 'tab1',
              tabViewBuilder: (c) => const Text('tab1 view'),
            ),
          ],
        )),
      );

      await tester.tap(find.text('body container'));

      expect(find.text('tab1 view'), findsNothing);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
      await tester.pumpAndSettle();

      final beforeSize = tester.getSize(find.ancestor(
        of: find.text('tab1 view'),
        matching: find.byType(PlutoLayoutContainer),
      ));

      // 두번 증가
      await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
      await tester.pumpAndSettle();

      final afterSize = tester.getSize(find.ancestor(
        of: find.text('tab1 view'),
        matching: find.byType(PlutoLayoutContainer),
      ));

      expect(
        afterSize.width - beforeSize.width,
        PlutoLayoutHasInDecreaseTabViewEvent.defaultSize * 2,
      );
    },
  );

  testWidgets(
    'reverseByDirection 가 true 인 상태에서, '
    'alt + arrowRight shortcuts 을 등록하여 right 탭뷰 넓이 증가는 반대로 감소 되어야 한다.',
    (tester) async {
      await BuildWidgetHelper.plutoLayout(
        tester,
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
              PlutoLayoutActions.toggleTabView(
            PlutoLayoutContainerDirection.right,
            'tab1',
          ),
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowRight):
              PlutoLayoutActions.increaseTabView(
            containerDirection: PlutoLayoutContainerDirection.right,
            reverseByDirection: true,
          ),
        },
        body: const PlutoLayoutContainer(child: Text('body container')),
        right: PlutoLayoutContainer(
            child: PlutoLayoutTabs(
          items: [
            PlutoLayoutTabItem(
              id: 'tab1',
              title: 'tab1',
              tabViewBuilder: (c) => const Text('tab1 view'),
            ),
          ],
        )),
      );

      await tester.tap(find.text('body container'));

      expect(find.text('tab1 view'), findsNothing);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
      await tester.pumpAndSettle();

      final beforeSize = tester.getSize(find.ancestor(
        of: find.text('tab1 view'),
        matching: find.byType(PlutoLayoutContainer),
      ));

      // 두번 감소
      await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
      await tester.pumpAndSettle();

      final afterSize = tester.getSize(find.ancestor(
        of: find.text('tab1 view'),
        matching: find.byType(PlutoLayoutContainer),
      ));

      expect(
        beforeSize.width - afterSize.width,
        PlutoLayoutHasInDecreaseTabViewEvent.defaultSize * 2,
      );
    },
  );

  testWidgets('alt + arrowUp shortcuts 을 등록하여 top 탭뷰의 넓이를 축소', (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
            PlutoLayoutActions.toggleTabView(
          PlutoLayoutContainerDirection.top,
          'tab1',
        ),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowUp):
            PlutoLayoutActions.decreaseTabView(
          containerDirection: PlutoLayoutContainerDirection.top,
        ),
      },
      body: const PlutoLayoutContainer(child: Text('body container')),
      top: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        items: [
          PlutoLayoutTabItem(
            id: 'tab1',
            title: 'tab1',
            tabViewBuilder: (c) => const Text('tab1 view'),
          ),
        ],
      )),
    );

    await tester.tap(find.text('body container'));

    expect(find.text('tab1 view'), findsNothing);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final beforeSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    // 두번 감소
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final afterSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    expect(
      beforeSize.height - afterSize.height,
      PlutoLayoutHasInDecreaseTabViewEvent.defaultSize * 2,
    );
  });

  testWidgets(
      'reverseByDirection 가 true 인 상태에서, '
      'alt + arrowUp shortcuts 을 등록하여 top 탭뷰의 넓이를 축소', (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
            PlutoLayoutActions.toggleTabView(
          PlutoLayoutContainerDirection.top,
          'tab1',
        ),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowUp):
            PlutoLayoutActions.decreaseTabView(
          containerDirection: PlutoLayoutContainerDirection.top,
          reverseByDirection: true,
        ),
      },
      body: const PlutoLayoutContainer(child: Text('body container')),
      top: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        items: [
          PlutoLayoutTabItem(
            id: 'tab1',
            title: 'tab1',
            tabViewBuilder: (c) => const Text('tab1 view'),
          ),
        ],
      )),
    );

    await tester.tap(find.text('body container'));

    expect(find.text('tab1 view'), findsNothing);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final beforeSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    // 두번 감소
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final afterSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    expect(
      beforeSize.height - afterSize.height,
      PlutoLayoutHasInDecreaseTabViewEvent.defaultSize * 2,
    );
  });

  testWidgets('alt + arrowDown shortcuts 을 등록하여 top 탭뷰의 넓이를 증가',
      (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
            PlutoLayoutActions.toggleTabView(
          PlutoLayoutContainerDirection.top,
          'tab1',
        ),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowDown):
            PlutoLayoutActions.increaseTabView(
          containerDirection: PlutoLayoutContainerDirection.top,
        ),
      },
      body: const PlutoLayoutContainer(child: Text('body container')),
      top: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        items: [
          PlutoLayoutTabItem(
            id: 'tab1',
            title: 'tab1',
            tabViewBuilder: (c) => const Text('tab1 view'),
          ),
        ],
      )),
    );

    await tester.tap(find.text('body container'));

    expect(find.text('tab1 view'), findsNothing);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final beforeSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    // 두번 증가
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final afterSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    expect(
      afterSize.height - beforeSize.height,
      PlutoLayoutHasInDecreaseTabViewEvent.defaultSize * 2,
    );
  });

  testWidgets(
      'reverseByDirection 가 true 인 상태에서, '
      'alt + arrowDown shortcuts 을 등록하여 top 탭뷰의 넓이를 증가', (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
            PlutoLayoutActions.toggleTabView(
          PlutoLayoutContainerDirection.top,
          'tab1',
        ),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowDown):
            PlutoLayoutActions.increaseTabView(
          containerDirection: PlutoLayoutContainerDirection.top,
          reverseByDirection: true,
        ),
      },
      body: const PlutoLayoutContainer(child: Text('body container')),
      top: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        items: [
          PlutoLayoutTabItem(
            id: 'tab1',
            title: 'tab1',
            tabViewBuilder: (c) => const Text('tab1 view'),
          ),
        ],
      )),
    );

    await tester.tap(find.text('body container'));

    expect(find.text('tab1 view'), findsNothing);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final beforeSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    // 두번 증가
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final afterSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    expect(
      afterSize.height - beforeSize.height,
      PlutoLayoutHasInDecreaseTabViewEvent.defaultSize * 2,
    );
  });

  testWidgets('alt + arrowDown shortcuts 을 등록하여 bottom 탭뷰의 넓이를 축소',
      (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
            PlutoLayoutActions.toggleTabView(
          PlutoLayoutContainerDirection.bottom,
          'tab1',
        ),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowDown):
            PlutoLayoutActions.decreaseTabView(
          containerDirection: PlutoLayoutContainerDirection.bottom,
        ),
      },
      body: const PlutoLayoutContainer(child: Text('body container')),
      bottom: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        items: [
          PlutoLayoutTabItem(
            id: 'tab1',
            title: 'tab1',
            tabViewBuilder: (c) => const Text('tab1 view'),
          ),
        ],
      )),
    );

    await tester.tap(find.text('body container'));

    expect(find.text('tab1 view'), findsNothing);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final beforeSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    // 두번 감소
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final afterSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    expect(
      beforeSize.height - afterSize.height,
      PlutoLayoutHasInDecreaseTabViewEvent.defaultSize * 2,
    );
  });

  testWidgets(
      'reverseByDirection 가 true 인 상태에서, '
      'alt + arrowUp shortcuts 을 등록하여 bottom 탭뷰의 넓이를 축소하면 반대로 증가 되어야 한다.',
      (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
            PlutoLayoutActions.toggleTabView(
          PlutoLayoutContainerDirection.bottom,
          'tab1',
        ),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowUp):
            PlutoLayoutActions.decreaseTabView(
          containerDirection: PlutoLayoutContainerDirection.bottom,
          reverseByDirection: true,
        ),
      },
      body: const PlutoLayoutContainer(child: Text('body container')),
      bottom: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        items: [
          PlutoLayoutTabItem(
            id: 'tab1',
            title: 'tab1',
            tabViewBuilder: (c) => const Text('tab1 view'),
          ),
        ],
      )),
    );

    await tester.tap(find.text('body container'));

    expect(find.text('tab1 view'), findsNothing);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final beforeSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    // 두번 증가
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final afterSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    expect(
      afterSize.height - beforeSize.height,
      PlutoLayoutHasInDecreaseTabViewEvent.defaultSize * 2,
    );
  });

  testWidgets('alt + arrowUp shortcuts 을 등록하여 bottom 탭뷰의 넓이를 증가',
      (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
            PlutoLayoutActions.toggleTabView(
          PlutoLayoutContainerDirection.bottom,
          'tab1',
        ),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowUp):
            PlutoLayoutActions.increaseTabView(
          containerDirection: PlutoLayoutContainerDirection.bottom,
        ),
      },
      body: const PlutoLayoutContainer(child: Text('body container')),
      bottom: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        items: [
          PlutoLayoutTabItem(
            id: 'tab1',
            title: 'tab1',
            tabViewBuilder: (c) => const Text('tab1 view'),
          ),
        ],
      )),
    );

    await tester.tap(find.text('body container'));

    expect(find.text('tab1 view'), findsNothing);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final beforeSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    // 두번 증가
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final afterSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    expect(
      afterSize.height - beforeSize.height,
      PlutoLayoutHasInDecreaseTabViewEvent.defaultSize * 2,
    );
  });

  testWidgets(
      'reverseByDirection 가 true 인 상태에서, '
      'alt + arrowDown shortcuts 을 등록하여 bottom 탭뷰의 넓이를 증가하면 반대로 감소 되어야 한다.',
      (tester) async {
    await BuildWidgetHelper.plutoLayout(
      tester,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1):
            PlutoLayoutActions.toggleTabView(
          PlutoLayoutContainerDirection.bottom,
          'tab1',
        ),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowDown):
            PlutoLayoutActions.increaseTabView(
          containerDirection: PlutoLayoutContainerDirection.bottom,
          reverseByDirection: true,
        ),
      },
      body: const PlutoLayoutContainer(child: Text('body container')),
      bottom: PlutoLayoutContainer(
          child: PlutoLayoutTabs(
        items: [
          PlutoLayoutTabItem(
            id: 'tab1',
            title: 'tab1',
            tabViewBuilder: (c) => const Text('tab1 view'),
          ),
        ],
      )),
    );

    await tester.tap(find.text('body container'));

    expect(find.text('tab1 view'), findsNothing);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final beforeSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    // 두번 감소
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pumpAndSettle();

    final afterSize = tester.getSize(find.ancestor(
      of: find.text('tab1 view'),
      matching: find.byType(PlutoLayoutContainer),
    ));

    expect(
      beforeSize.height - afterSize.height,
      PlutoLayoutHasInDecreaseTabViewEvent.defaultSize * 2,
    );
  });
}
