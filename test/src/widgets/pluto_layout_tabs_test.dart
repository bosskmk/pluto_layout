import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../../helper/test_helper_util.dart';

void main() {
  late PlutoLayoutEventStreamController events;

  const defaultScreenSize = Size(800, 600);

  setUp(() {
    events = PlutoLayoutEventStreamController();
  });

  tearDown(() {
    events.dispose();
  });

  Future<void> buildWidget(
    WidgetTester tester, {
    List<PlutoLayoutTabItem>? items,
    PlutoLayoutTabMode mode = PlutoLayoutTabMode.showOne,
    PlutoLayoutTabViewSizeResolver? tabViewSizeResolver,
    Size? screenSize,
    required PlutoLayoutId layoutId,
    required PlutoLayoutContainerDirection direction,
  }) async {
    await TestHelperUtil.changeWidth(
      tester: tester,
      width: screenSize?.width ?? defaultScreenSize.width,
      height: screenSize?.height ?? defaultScreenSize.height,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ProviderScope(
          overrides: [
            layoutIdProvider.overrideWithValue(layoutId),
            layoutEventsProvider.overrideWithValue(events),
            layoutContainerDirectionProvider.overrideWithValue(direction),
          ],
          child: PlutoLayoutTabs(
            items: items ?? [],
            mode: mode,
            tabViewSizeResolver: tabViewSizeResolver,
          ),
        ),
      ),
    );
  }

  group('메뉴 버튼 렌더링 테스트', () {
    group('left', () {
      const layoutId = PlutoLayoutId.left;

      const direction = PlutoLayoutContainerDirection.left;

      final List<PlutoLayoutTabItem> items = [
        PlutoLayoutTabItem(id: 'id1', title: 'title1'),
        PlutoLayoutTabItem(id: 'id2', title: 'title2'),
        PlutoLayoutTabItem(
          id: 'id3',
          title: 'title3',
          icon: const Icon(Icons.add),
        ),
      ];

      testWidgets('메뉴의 title 이 렌더링 되어야 한다.', (tester) async {
        await buildWidget(
          tester,
          items: items,
          layoutId: layoutId,
          direction: direction,
        );

        expect(find.text('title1'), findsOneWidget);
        expect(find.text('title2'), findsOneWidget);
        expect(find.text('title3'), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets(
        '_Menus 는 layoutId 가 left 인 경우 높이가 화면 사이즈만큼 설정 되어야 한다.',
        (tester) async {
          await buildWidget(
            tester,
            items: items,
            layoutId: layoutId,
            direction: direction,
          );

          final menus = find.byKey(const ValueKey('_Menus'));

          final size = tester.getSize(menus);

          expect(size.height, defaultScreenSize.height);
        },
      );

      testWidgets(
        '활성화 된 메뉴가 없는 경우 _TabView 위젯의 사이즈가 0 이어야 한다.',
        (tester) async {
          await buildWidget(
            tester,
            items: items,
            layoutId: layoutId,
            direction: direction,
          );

          final tabView = find.byKey(const ValueKey('_TabView'));

          expect(tester.getSize(tabView), Size.zero);
        },
      );
    });

    group('right', () {
      const layoutId = PlutoLayoutId.right;

      const direction = PlutoLayoutContainerDirection.right;

      final List<PlutoLayoutTabItem> items = [
        PlutoLayoutTabItem(id: 'id1', title: 'title1'),
        PlutoLayoutTabItem(id: 'id2', title: 'title2'),
        PlutoLayoutTabItem(
          id: 'id3',
          title: 'title3',
          icon: const Icon(Icons.add),
        ),
      ];

      testWidgets('메뉴의 title 이 렌더링 되어야 한다.', (tester) async {
        await buildWidget(
          tester,
          items: items,
          layoutId: layoutId,
          direction: direction,
        );

        expect(find.text('title1'), findsOneWidget);
        expect(find.text('title2'), findsOneWidget);
        expect(find.text('title3'), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets(
        '_Menus 는 layoutId 가 right 인 경우 높이가 화면 사이즈만큼 설정 되어야 한다.',
        (tester) async {
          await buildWidget(
            tester,
            items: items,
            layoutId: layoutId,
            direction: direction,
          );

          final menus = find.byKey(const ValueKey('_Menus'));

          final size = tester.getSize(menus);

          expect(size.height, defaultScreenSize.height);
        },
      );

      testWidgets(
        '활성화 된 메뉴가 없는 경우 _TabView 위젯의 사이즈가 0 이어야 한다.',
        (tester) async {
          await buildWidget(
            tester,
            items: items,
            layoutId: layoutId,
            direction: direction,
          );

          final tabView = find.byKey(const ValueKey('_TabView'));

          expect(tester.getSize(tabView), Size.zero);
        },
      );
    });

    group('top', () {
      const layoutId = PlutoLayoutId.top;

      const direction = PlutoLayoutContainerDirection.top;

      final List<PlutoLayoutTabItem> items = [
        PlutoLayoutTabItem(id: 'id1', title: 'title1'),
        PlutoLayoutTabItem(id: 'id2', title: 'title2'),
        PlutoLayoutTabItem(
          id: 'id3',
          title: 'title3',
          icon: const Icon(Icons.add),
        ),
      ];

      testWidgets('메뉴의 title 이 렌더링 되어야 한다.', (tester) async {
        await buildWidget(
          tester,
          items: items,
          layoutId: layoutId,
          direction: direction,
        );

        expect(find.text('title1'), findsOneWidget);
        expect(find.text('title2'), findsOneWidget);
        expect(find.text('title3'), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets(
        '_Menus 는 layoutId 가 top 인 경우 녋이가 화면 사이즈만큼 설정 되어야 한다.',
        (tester) async {
          await buildWidget(
            tester,
            items: items,
            layoutId: layoutId,
            direction: direction,
          );

          final menus = find.byKey(const ValueKey('_Menus'));

          final size = tester.getSize(menus);

          expect(size.width, defaultScreenSize.width);
        },
      );

      testWidgets(
        '활성화 된 메뉴가 없는 경우 _TabView 위젯의 사이즈가 0 이어야 한다.',
        (tester) async {
          await buildWidget(
            tester,
            items: items,
            layoutId: layoutId,
            direction: direction,
          );

          final tabView = find.byKey(const ValueKey('_TabView'));

          expect(tester.getSize(tabView), Size.zero);
        },
      );
    });

    group('bottom', () {
      const layoutId = PlutoLayoutId.bottom;

      const direction = PlutoLayoutContainerDirection.bottom;

      final List<PlutoLayoutTabItem> items = [
        PlutoLayoutTabItem(id: 'id1', title: 'title1'),
        PlutoLayoutTabItem(id: 'id2', title: 'title2'),
        PlutoLayoutTabItem(
          id: 'id3',
          title: 'title3',
          icon: const Icon(Icons.add),
        ),
      ];

      testWidgets('메뉴의 title 이 렌더링 되어야 한다.', (tester) async {
        await buildWidget(
          tester,
          items: items,
          layoutId: layoutId,
          direction: direction,
        );

        expect(find.text('title1'), findsOneWidget);
        expect(find.text('title2'), findsOneWidget);
        expect(find.text('title3'), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets(
        '_Menus 는 layoutId 가 bottom 인 경우 녋이가 화면 사이즈만큼 설정 되어야 한다.',
        (tester) async {
          await buildWidget(
            tester,
            items: items,
            layoutId: layoutId,
            direction: direction,
          );

          final menus = find.byKey(const ValueKey('_Menus'));

          final size = tester.getSize(menus);

          expect(size.width, defaultScreenSize.width);
        },
      );

      testWidgets(
        '활성화 된 메뉴가 없는 경우 _TabView 위젯의 사이즈가 0 이어야 한다.',
        (tester) async {
          await buildWidget(
            tester,
            items: items,
            layoutId: layoutId,
            direction: direction,
          );

          final tabView = find.byKey(const ValueKey('_TabView'));

          expect(tester.getSize(tabView), Size.zero);
        },
      );
    });
  });

  group('탭뷰 렌더링 테스트', () {
    group('PlutoLayoutTabMode.showOne', () {
      const mode = PlutoLayoutTabMode.showOne;

      const layoutId = PlutoLayoutId.left;

      const direction = PlutoLayoutContainerDirection.left;

      final List<PlutoLayoutTabItem> items = [
        PlutoLayoutTabItem(
          id: 'tab1',
          title: 'tab1',
          tabViewBuilder: (e) => const Text('tab1 view'),
        ),
        PlutoLayoutTabItem(
          id: 'tab2',
          title: 'tab2',
          tabViewBuilder: (e) => const Text('tab2 view'),
        ),
      ];

      test('두개의 탭이 활성화 된 경우 assertion 에러가 발생 되어야 한다.', () {
        expect(() {
          PlutoLayoutTabs(
            mode: mode,
            items: [
              PlutoLayoutTabItem(id: 'tab1', title: 'tab1', enabled: true),
              PlutoLayoutTabItem(id: 'tab2', title: 'tab2', enabled: true),
            ],
          );
        }, throwsAssertionError);
      });

      testWidgets(
        '탭뷰를 두번 탭하면 탭뷰가 렌더링 되었다 사라져야 한다.',
        (tester) async {
          await buildWidget(
            tester,
            items: items,
            layoutId: layoutId,
            direction: direction,
            mode: mode,
          );

          await tester.tap(find.text('tab1'));
          await tester.pump();

          expect(find.text('tab1 view'), findsOneWidget);

          await tester.tap(find.text('tab1'));
          await tester.pump();

          expect(find.text('tab1 view'), findsNothing);
        },
      );

      testWidgets(
        '두개의 탭을 탭하면 기존의 탭뷰는 사라지고 탭한 탭뷰가 렌더링 되어야 한다.',
        (tester) async {
          await buildWidget(
            tester,
            items: items,
            layoutId: layoutId,
            direction: direction,
            mode: mode,
          );

          await tester.tap(find.text('tab1'));
          await tester.pump();

          expect(find.text('tab1 view'), findsOneWidget);
          expect(find.text('tab2 view'), findsNothing);

          await tester.tap(find.text('tab2'));
          await tester.pump();

          expect(find.text('tab1 view'), findsNothing);
          expect(find.text('tab2 view'), findsOneWidget);
        },
      );
    });

    group('PlutoLayoutTabMode.showOneMust', () {
      const mode = PlutoLayoutTabMode.showOneMust;

      const layoutId = PlutoLayoutId.left;

      const direction = PlutoLayoutContainerDirection.left;

      final List<PlutoLayoutTabItem> items = [
        PlutoLayoutTabItem(
          id: 'tab1',
          title: 'tab1',
          tabViewBuilder: (e) => const Text('tab1 view'),
        ),
        PlutoLayoutTabItem(
          id: 'tab2',
          title: 'tab2',
          tabViewBuilder: (e) => const Text('tab2 view'),
        ),
      ];

      test('두개의 탭이 활성화 된 경우 assertion 에러가 발생 되어야 한다.', () {
        expect(() {
          PlutoLayoutTabs(
            mode: mode,
            items: [
              PlutoLayoutTabItem(id: 'tab1', title: 'tab1', enabled: true),
              PlutoLayoutTabItem(id: 'tab2', title: 'tab2', enabled: true),
            ],
          );
        }, throwsAssertionError);
      });

      testWidgets(
        '첫번째 탭뷰가 기본으로 활성화 되어 있어야 한다.',
        (tester) async {
          await buildWidget(
            tester,
            items: items,
            layoutId: layoutId,
            direction: direction,
            mode: mode,
          );

          expect(find.text('tab1 view'), findsOneWidget);
        },
      );

      testWidgets(
        '활성화된 첫번째 탭뷰를 탭해도 사라지지 않아야 한다.',
        (tester) async {
          await buildWidget(
            tester,
            items: items,
            layoutId: layoutId,
            direction: direction,
            mode: mode,
          );

          await tester.tap(find.text('tab1'));
          await tester.pump();

          expect(find.text('tab1 view'), findsOneWidget);
        },
      );

      testWidgets(
        '두번째 탭을 탭하면 첫번째는 사라지고 두번째 탭뷰가 나타나야 한다.',
        (tester) async {
          await buildWidget(
            tester,
            items: items,
            layoutId: layoutId,
            direction: direction,
            mode: mode,
          );

          expect(find.text('tab1 view'), findsOneWidget);

          await tester.tap(find.text('tab2'));
          await tester.pump();

          expect(find.text('tab1 view'), findsNothing);
          expect(find.text('tab2 view'), findsOneWidget);
        },
      );

      testWidgets(
        '두개의 탭을 탭하면 기존의 탭뷰는 사라지고 탭한 탭뷰가 렌더링 되어야 한다.',
        (tester) async {
          await buildWidget(
            tester,
            items: items,
            layoutId: layoutId,
            direction: direction,
            mode: mode,
          );

          await tester.tap(find.text('tab1'));
          await tester.pump();

          expect(find.text('tab1 view'), findsOneWidget);
          expect(find.text('tab2 view'), findsNothing);

          await tester.tap(find.text('tab2'));
          await tester.pump();

          expect(find.text('tab1 view'), findsNothing);
          expect(find.text('tab2 view'), findsOneWidget);
        },
      );
    });

    group('PlutoLayoutTabMode.showSelected', () {
      const mode = PlutoLayoutTabMode.showSelected;

      const layoutId = PlutoLayoutId.left;

      const direction = PlutoLayoutContainerDirection.left;

      final List<PlutoLayoutTabItem> items = [
        PlutoLayoutTabItem(
          id: 'tab1',
          title: 'tab1',
          tabViewBuilder: (e) => const Text('tab1 view'),
        ),
        PlutoLayoutTabItem(
          id: 'tab2',
          title: 'tab2',
          tabViewBuilder: (e) => const Text('tab2 view'),
        ),
      ];

      test('두개의 탭이 활성화 된 경우 assertion 에러가 발생 되지 않아야 한다.', () {
        final tabs = PlutoLayoutTabs(
          mode: mode,
          items: [
            PlutoLayoutTabItem(id: 'tab1', title: 'tab1', enabled: true),
            PlutoLayoutTabItem(id: 'tab2', title: 'tab2', enabled: true),
          ],
        );

        expect(tabs.items.where((e) => e.enabled).length, 2);
      });

      testWidgets(
        '두개의 탭뷰를 모두 활성화 한 상태에서 다시 한번씩 탭하면 탭뷰가 사라져야 한다.',
        (tester) async {
          await buildWidget(
            tester,
            items: items,
            layoutId: layoutId,
            direction: direction,
            mode: mode,
          );

          await tester.tap(find.text('tab1'));
          await tester.pump();
          await tester.tap(find.text('tab2'));
          await tester.pump();

          expect(find.text('tab1 view'), findsOneWidget);
          expect(find.text('tab2 view'), findsOneWidget);

          await tester.tap(find.text('tab1'));
          await tester.pump();
          await tester.tap(find.text('tab2'));
          await tester.pump();

          expect(find.text('tab1 view'), findsNothing);
          expect(find.text('tab2 view'), findsNothing);
        },
      );
    });
  });

  group('PlutoLayoutTabViewSizeResolver', () {
    group('PlutoLayoutTabViewSizeFixed', () {
      test('size 가 0 인경우 asserting 에러가 발생 되어야 한다.', () {
        expect(() => PlutoLayoutTabViewSizeFixed(0), throwsAssertionError);
      });

      test('size 가 -0.01 인경우 asserting 에러가 발생 되어야 한다.', () {
        expect(() => PlutoLayoutTabViewSizeFixed(-0.01), throwsAssertionError);
      });

      test('size 가 0.1 인 경우 resolve 메서드가 0.1 을 리턴해야 한다.', () {
        const resolver = PlutoLayoutTabViewSizeFixed(0.1);

        expect(
          resolver.resolve(
            maxSize: 100,
            sizeToSet: null,
            defaultSize: 50,
          ),
          0.1,
        );
      });
    });

    group('PlutoLayoutTabViewSizeConstrains', () {
      test(
        'minSize, maxSize, initialSize 가 모두 null 인 경우, '
        'assertion 에러가 발생 되어야 한다.',
        () {
          expect(
            () => PlutoLayoutTabViewSizeConstrains(),
            throwsAssertionError,
          );
        },
      );

      test('minSize 가 maxSize 보다 큰 경우, assertion 에러가 발생 되어야 한다.', () {
        expect(
          () => PlutoLayoutTabViewSizeConstrains(
            minSize: 100,
            maxSize: 99,
          ),
          throwsAssertionError,
        );
      });

      test('initialSize 가 minSize 보다 작은 경우 assertion 에러가 발생 되어야 한다.', () {
        expect(
          () => PlutoLayoutTabViewSizeConstrains(
            initialSize: 99,
            minSize: 100,
          ),
          throwsAssertionError,
        );
      });

      test('initialSize 가 maxSize 보다 큰 경우 assertion 에러가 발생 되어야 한다.', () {
        expect(
          () => PlutoLayoutTabViewSizeConstrains(
            initialSize: 101,
            maxSize: 100,
          ),
          throwsAssertionError,
        );
      });

      test('sizeToSet 가 null 인 경우 resolve 메서드는 initialSize 가 리턴 해야 한다.', () {
        const resolver = PlutoLayoutTabViewSizeConstrains(
          initialSize: 30,
        );

        expect(
          resolver.resolve(maxSize: 100, sizeToSet: null, defaultSize: 50),
          30,
        );
      });

      test(
          'sizeToSet, initialSize 가 null 인 경우 resolve 메서드는 defaultSize 가 리턴 해야 한다.',
          () {
        const resolver = PlutoLayoutTabViewSizeConstrains(minSize: 30);

        expect(
          resolver.resolve(maxSize: 100, sizeToSet: null, defaultSize: 50),
          50,
        );
      });

      test('sizeToSet 이 maxSize 보다 큰 경우 resolve 메서드는 maxSize 가 리턴 해야 한다.', () {
        const resolver = PlutoLayoutTabViewSizeConstrains(maxSize: 80);

        expect(
          resolver.resolve(maxSize: 100, sizeToSet: 120, defaultSize: 50),
          80,
        );
      });

      test('sizeToSet 이 minSize 보다 작은 경우 resolve 메서드는 minSize 가 리턴 해야 한다.', () {
        const resolver = PlutoLayoutTabViewSizeConstrains(minSize: 20);

        expect(
          resolver.resolve(maxSize: 100, sizeToSet: 10, defaultSize: 50),
          20,
        );
      });
    });

    group('PlutoLayoutTabViewSizeRatio', () {
      test('radio 가 마이너스인 경우 assertion 에러가 발생 되어야 한다.', () {
        expect(
          () => PlutoLayoutTabViewSizeRatio(-0.1),
          throwsAssertionError,
        );
      });

      test('radio 가 1 을 초과 하는 경우 assertion 에러가 발생 되어야 한다.', () {
        expect(
          () => PlutoLayoutTabViewSizeRatio(1.1),
          throwsAssertionError,
        );
      });

      test('radio 가 0.5 이고 maxSize 가 100 이면 resolve 메서드가 50을 리턴해야 한다.', () {
        const resolver = PlutoLayoutTabViewSizeRatio(0.5);

        expect(
          resolver.resolve(maxSize: 100, sizeToSet: null, defaultSize: 20),
          50,
        );
      });
    });
  });

  group('PlutoLayoutTabItemSizeResolver', () {
    group('PlutoLayoutTabItemSizeFlexible', () {
      test('flex 가 음수인 경우 assertion 에러가 발생 되어야 한다.', () {
        expect(() {
          PlutoLayoutTabItemSizeFlexible(-0.1);
        }, throwsAssertionError);
      });

      test('flex 가 1보다 큰 경우 assertion 에러가 발생 되어야 한다.', () {
        expect(() {
          PlutoLayoutTabItemSizeFlexible(1.1);
        }, throwsAssertionError);
      });

      test('flex 가 0 인 경우 resolve 메서드가 0 을 리턴 해야 한다.', () {
        const resolver = PlutoLayoutTabItemSizeFlexible(0);

        expect(resolver.resolve(maxSize: 100, minSize: 20), 0);
      });

      test('flex 가 0.5 인 경우 resolve 메서드가 0.5 을 리턴 해야 한다.', () {
        const resolver = PlutoLayoutTabItemSizeFlexible(0.5);

        expect(resolver.resolve(maxSize: 100, minSize: 20), 0.5);
      });

      test('flex 가 1 인 경우 resolve 메서드가 1 을 리턴 해야 한다.', () {
        const resolver = PlutoLayoutTabItemSizeFlexible(1);

        expect(resolver.resolve(maxSize: 100, minSize: 20), 1);
      });
    });

    group('PlutoLayoutTabItemSizeInitial', () {
      test('size 가 음수인 경우 assertion 에러가 발생 되어야 한다.', () {
        expect(() {
          PlutoLayoutTabItemSizeInitial(-0.1);
        }, throwsAssertionError);
      });

      test('size 가 0.1 인 경우 resolve 메서드가 0.1 을 리턴 해야 한다.', () {
        const resolver = PlutoLayoutTabItemSizeInitial(0.1);

        expect(resolver.resolve(maxSize: 100, minSize: 20), 0.1);
      });

      test('size 가 1 인 경우 resolve 메서드가 1 을 리턴 해야 한다.', () {
        const resolver = PlutoLayoutTabItemSizeInitial(1);

        expect(resolver.resolve(maxSize: 100, minSize: 20), 1);
      });
    });
  });
}
