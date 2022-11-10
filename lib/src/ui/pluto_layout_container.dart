import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../pluto_layout.dart';
import '../pluto_layout_provider.dart';
import 'pluto_layout_container_provider.dart';

/// Widgets passed as children of properties such as [PlutoLayout.body] or [PlutoLayout.top].
///
/// You can set the background color with the [backgroundColor] property.
///
/// {@macro pluto_layout_example}
class PlutoLayoutContainer extends ConsumerStatefulWidget {
  const PlutoLayoutContainer({
    this.backgroundColor,
    required this.child,
    super.key,
  });

  final Color? backgroundColor;

  final Widget child;

  @override
  ConsumerState<PlutoLayoutContainer> createState() =>
      _PlutoLayoutContainerState();
}

class _PlutoLayoutContainerState extends ConsumerState<PlutoLayoutContainer> {
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();

    super.dispose();
  }

  PlutoLayoutContainerDirection _getDirection(PlutoLayoutId id) {
    switch (id) {
      case PlutoLayoutId.top:
        return PlutoLayoutContainerDirection.top;
      case PlutoLayoutId.left:
        return PlutoLayoutContainerDirection.left;
      case PlutoLayoutId.right:
        return PlutoLayoutContainerDirection.right;
      case PlutoLayoutId.bottom:
        return PlutoLayoutContainerDirection.bottom;
      case PlutoLayoutId.body:
        return PlutoLayoutContainerDirection.top;
    }
  }

  @override
  Widget build(BuildContext context) {
    final layoutId = ref.read(layoutIdProvider);

    final layoutShortcuts = ref.read(layoutShortcutsProvider);

    PlutoLayoutContainerDirection direction = _getDirection(layoutId);

    gestureOnTap() {
      focusNode.requestFocus();
      ref.read(layoutFocusedIdProvider.notifier).state = layoutId;
    }

    Widget containerWidget = Focus(
      focusNode: focusNode,
      child: ProviderScope(
        overrides: [
          layoutContainerDirectionProvider.overrideWithValue(direction),
        ],
        child: GestureDetector(
          onTap: gestureOnTap,
          child: _FocusedContainer(
            layoutId: layoutId,
            backgroundColor: widget.backgroundColor,
            child: widget.child,
          ),
        ),
      ),
    );

    if (layoutShortcuts != null) {
      final layoutEvents = ref.read(layoutEventsProvider);

      containerWidget = Actions(
        actions: PlutoLayoutActions.getActionsByShortcuts(
          layoutShortcuts,
          layoutEvents,
        ),
        child: containerWidget,
      );
    }

    return containerWidget;
  }
}

class _FocusedContainer extends ConsumerWidget {
  const _FocusedContainer({
    required this.layoutId,
    this.backgroundColor,
    required this.child,
  });

  final PlutoLayoutId layoutId;

  final Color? backgroundColor;

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final layoutFocusedId = ref.watch(layoutFocusedIdProvider);

    final bool focused = layoutFocusedId == layoutId;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: focused
            ? Border.all(
                strokeAlign: StrokeAlign.outside,
                color: focused ? theme.highlightColor : theme.dividerColor,
              )
            : null,
      ),
      child: child,
    );
  }
}

/// Indicates the position of each side container of [PlutoLayout].
///
/// Used internally.
enum PlutoLayoutContainerDirection {
  top,
  left,
  right,
  bottom;

  bool get isTop => this == PlutoLayoutContainerDirection.top;
  bool get isLeft => this == PlutoLayoutContainerDirection.left;
  bool get isRight => this == PlutoLayoutContainerDirection.right;
  bool get isBottom => this == PlutoLayoutContainerDirection.bottom;
  bool get isHorizontal => isLeft || isRight;
  bool get isVertical => isTop || isBottom;
  bool get isIncreasedOffset => isTop || isLeft;
}
