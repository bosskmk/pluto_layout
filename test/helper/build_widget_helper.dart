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
    ThemeData? theme,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
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

  static Future<void> plutoLayoutWithTabs(
    WidgetTester tester, {
    PlutoLayoutContainer body = const PlutoLayoutContainer(
      child: Text('body container'),
    ),
    List<PlutoLayoutTabItem>? topItems,
    List<PlutoLayoutTabItem>? leftItems,
    List<PlutoLayoutTabItem>? rightItems,
    List<PlutoLayoutTabItem>? bottomItems,
    bool draggableTop = true,
    bool draggableLeft = true,
    bool draggableRight = true,
    bool draggableBottom = true,
    PlutoLayoutTabMode topMode = PlutoLayoutTabMode.showSelected,
    PlutoLayoutTabMode leftMode = PlutoLayoutTabMode.showSelected,
    PlutoLayoutTabMode rightMode = PlutoLayoutTabMode.showSelected,
    PlutoLayoutTabMode bottomMode = PlutoLayoutTabMode.showSelected,
    PlutoLayoutShortcuts? shortcuts,
    ThemeData? theme,
  }) {
    return plutoLayout(
      tester,
      body: body,
      shortcuts: shortcuts,
      theme: theme,
      top: PlutoLayoutContainer(
        child: PlutoLayoutTabs(
          mode: topMode,
          items: topItems ?? [],
          draggable: draggableTop,
        ),
      ),
      left: PlutoLayoutContainer(
        child: PlutoLayoutTabs(
          mode: leftMode,
          items: leftItems ?? [],
          draggable: draggableLeft,
        ),
      ),
      right: PlutoLayoutContainer(
        child: PlutoLayoutTabs(
          mode: rightMode,
          items: rightItems ?? [],
          draggable: draggableRight,
        ),
      ),
      bottom: PlutoLayoutContainer(
        child: PlutoLayoutTabs(
          mode: bottomMode,
          items: bottomItems ?? [],
          draggable: draggableBottom,
        ),
      ),
    );
  }
}
