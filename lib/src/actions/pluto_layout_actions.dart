import 'package:flutter/cupertino.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../events/events.dart';
import '../pluto_layout_event_stream_controller.dart';

/// [Intent] collection for performing specific actions
/// by registering keyboard shortcuts.
///
/// {@macro pluto_layout_shortcuts_example}
abstract class PlutoLayoutActions {
  /// {@macro pluto_layout_action_rotate_focused_container_intent}
  static PlutoLayoutActionRotateFocusedContainerIntent rotateFocusedContainer({
    bool reverse = false,
    List<PlutoLayoutId> order = PlutoLayoutId.values,
  }) {
    return PlutoLayoutActionRotateFocusedContainerIntent(
      reverse: reverse,
      order: order,
    );
  }

  /// {@macro pluto_layout_action_rotate_focused_tab_item_intent}
  static PlutoLayoutActionRotateFocusedTabItemIntent rotateFocusedTabItem({
    bool reverse = false,
    PlutoLayoutId? layoutId,
  }) {
    return PlutoLayoutActionRotateFocusedTabItemIntent(
      layoutId: layoutId,
      reverse: reverse,
    );
  }

  /// {@macro pluto_layout_action_hide_all_tab_view_intent}
  static PlutoLayoutActionHideAllTabViewIntent hideAllTabView({
    bool afterFocusToBody = true,
  }) {
    return PlutoLayoutActionHideAllTabViewIntent(
      afterFocusToBody: afterFocusToBody,
    );
  }

  /// {@macro pluto_layout_action_toggle_tab_view_intent}
  static PlutoLayoutActionToggleTabViewIntent toggleTabView({
    PlutoLayoutId? layoutId,
    Object? itemId,
  }) {
    return PlutoLayoutActionToggleTabViewIntent(
      layoutId: layoutId,
      itemId: itemId,
    );
  }

  /// {@macro pluto_layout_action_rotate_tab_view_intent}
  static PlutoLayoutActionRotateTabViewIntent rotateTabView(
    PlutoLayoutId layoutId,
  ) {
    return PlutoLayoutActionRotateTabViewIntent(layoutId);
  }

  /// {@macro pluto_layout_action_increase_tab_view_intent}
  static PlutoLayoutActionIncreaseTabViewIntent increaseTabView({
    PlutoLayoutId? layoutId,
    double size = PlutoLayoutInDecreaseTabViewEvent.defaultSize,
    bool reverseByDirection = false,
  }) {
    assert(size > 0);

    return PlutoLayoutActionIncreaseTabViewIntent(
      layoutId,
      size: size,
      reverseByDirection: reverseByDirection,
    );
  }

  /// {@macro pluto_layout_action_decrease_tab_view_intent}
  static PlutoLayoutActionDecreaseTabViewIntent decreaseTabView({
    PlutoLayoutId? layoutId,
    double size = PlutoLayoutInDecreaseTabViewEvent.defaultSize,
    bool reverseByDirection = false,
  }) {
    assert(size > 0);

    return PlutoLayoutActionDecreaseTabViewIntent(
      layoutId,
      size: size,
      reverseByDirection: reverseByDirection,
    );
  }

  /// {@macro pluto_layout_action_increase_tab_item_view_intent}
  static PlutoLayoutActionIncreaseTabItemViewIntent increaseTabItemView({
    PlutoLayoutId? layoutId,
    Object? itemId,
    double size = PlutoLayoutInDecreaseTabItemViewEvent.defaultSize,
    bool reverseByDirection = false,
  }) {
    assert(size > 0);

    return PlutoLayoutActionIncreaseTabItemViewIntent(
      layoutId: layoutId,
      itemId: itemId,
      size: size,
      reverseByDirection: reverseByDirection,
    );
  }

  /// {@macro pluto_layout_action_decrease_tab_item_view_intent}
  static PlutoLayoutActionDecreaseTabItemViewIntent decreaseTabItemView({
    PlutoLayoutId? layoutId,
    Object? itemId,
    double size = PlutoLayoutInDecreaseTabItemViewEvent.defaultSize,
    bool reverseByDirection = false,
  }) {
    assert(size > 0);

    return PlutoLayoutActionDecreaseTabItemViewIntent(
      layoutId: layoutId,
      itemId: itemId,
      size: size,
      reverseByDirection: reverseByDirection,
    );
  }

  /// {@macro pluto_layout_action_remove_tab_item_intent}
  static PlutoLayoutActionRemoveTabItemIntent removeTabItem({
    PlutoLayoutId? layoutId,
    Object? itemId,
  }) {
    return PlutoLayoutActionRemoveTabItemIntent(layoutId, itemId);
  }

  static PlutoLayoutActionInsertTabItemIntent insertTabItem({
    PlutoLayoutId? layoutId,
    required PlutoLayoutActionInsertTabItemResolver itemResolver,
  }) {
    return PlutoLayoutActionInsertTabItemIntent(
      layoutId: layoutId,
      itemResolver: itemResolver,
    );
  }

  static Map<Type, Action<Intent>> getActionsByShortcuts(
    Map<ShortcutActivator, PlutoLayoutIntent> shortcuts,
    PlutoLayoutEventStreamController layoutEvents,
    FocusNode layoutFocusNode,
  ) {
    final actions = <Type, Action<Intent>>{};

    for (final shortcut in shortcuts.entries) {
      switch (shortcut.value.runtimeType) {
        case PlutoLayoutActionRotateFocusedContainerIntent:
          actions[PlutoLayoutActionRotateFocusedContainerIntent] =
              PlutoLayoutActionRotateFocusedContainerAction(
            layoutEvents,
            layoutFocusNode,
          );
          break;
        case PlutoLayoutActionRotateFocusedTabItemIntent:
          actions[PlutoLayoutActionRotateFocusedTabItemIntent] =
              PlutoLayoutActionRotateFocusedTabItemAction(
            layoutEvents,
            layoutFocusNode,
          );
          break;
        case PlutoLayoutActionHideAllTabViewIntent:
          actions[PlutoLayoutActionHideAllTabViewIntent] =
              PlutoLayoutActionHideAllTabViewAction(
            layoutEvents,
            layoutFocusNode,
          );
          break;
        case PlutoLayoutActionToggleTabViewIntent:
          actions[PlutoLayoutActionToggleTabViewIntent] =
              PlutoLayoutActionToggleTabViewAction(
            layoutEvents,
            layoutFocusNode,
          );
          break;
        case PlutoLayoutActionRotateTabViewIntent:
          actions[PlutoLayoutActionRotateTabViewIntent] =
              PlutoLayoutActionRotateTabViewAction(
            layoutEvents,
            layoutFocusNode,
          );
          break;
        case PlutoLayoutActionIncreaseTabViewIntent:
          actions[PlutoLayoutActionIncreaseTabViewIntent] =
              PlutoLayoutActionIncreaseTabViewAction(
            layoutEvents,
            layoutFocusNode,
          );
          break;
        case PlutoLayoutActionDecreaseTabViewIntent:
          actions[PlutoLayoutActionDecreaseTabViewIntent] =
              PlutoLayoutActionDecreaseTabViewAction(
            layoutEvents,
            layoutFocusNode,
          );
          break;
        case PlutoLayoutActionIncreaseTabItemViewIntent:
          actions[PlutoLayoutActionIncreaseTabItemViewIntent] =
              PlutoLayoutActionIncreaseTabItemViewAction(
            layoutEvents,
            layoutFocusNode,
          );
          break;
        case PlutoLayoutActionDecreaseTabItemViewIntent:
          actions[PlutoLayoutActionDecreaseTabItemViewIntent] =
              PlutoLayoutActionDecreaseTabItemViewAction(
            layoutEvents,
            layoutFocusNode,
          );
          break;
        case PlutoLayoutActionRemoveTabItemIntent:
          actions[PlutoLayoutActionRemoveTabItemIntent] =
              PlutoLayoutActionRemoveTabItemAction(
            layoutEvents,
            layoutFocusNode,
          );
          break;
        case PlutoLayoutActionInsertTabItemIntent:
          actions[PlutoLayoutActionInsertTabItemIntent] =
              PlutoLayoutActionInsertTabItemAction(
            layoutEvents,
            layoutFocusNode,
          );
          break;
      }
    }

    return actions;
  }
}

abstract class PlutoLayoutIntent extends Intent {
  const PlutoLayoutIntent({required this.actionsOnlyPrimaryFocus});

  final bool actionsOnlyPrimaryFocus;
}

abstract class PlutoLayoutAction<T extends PlutoLayoutIntent>
    extends Action<T> {
  @mustCallSuper
  PlutoLayoutAction(this.events, this.focusNode);

  final PlutoLayoutEventStreamController events;

  final FocusNode focusNode;

  bool canInvoke(T intent) {
    return !intent.actionsOnlyPrimaryFocus || focusNode.hasPrimaryFocus;
  }

  @override
  bool isEnabled(T intent) {
    return canInvoke(intent);
  }
}
