import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_layout/pluto_layout.dart';

class BuildWidgetHelper {
  static Future<void> plutoLayout(
    WidgetTester tester, {
    required PlutoLayoutContainer body,
    PlutoLayoutContainer? top,
    PlutoLayoutContainer? left,
    PlutoLayoutContainer? right,
    PlutoLayoutContainer? bottom,
    PlutoLayoutShortcuts? shortcuts,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PlutoLayout(
          body: body,
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          shortcuts: shortcuts,
        ),
      ),
    );
  }
}
