import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_layout/pluto_layout.dart';

void main() {
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
}
