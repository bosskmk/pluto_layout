import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_layout/pluto_layout.dart';
import 'package:pluto_layout/src/ui/pluto_layout_container.dart';

final layoutIdProvider = Provider<PlutoLayoutId>(
  (ref) => throw UnimplementedError(),
);

final layoutFocusedIdProvider = StateProvider<PlutoLayoutId>(
  (ref) => PlutoLayoutId.top,
);

final layoutDataProvider = Provider((ref) => PlutoLayoutData());

class PlutoLayout extends StatefulWidget {
  const PlutoLayout({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.body,
    super.key,
  });

  final PlutoLayoutContainer? top;
  final PlutoLayoutContainer? left;
  final PlutoLayoutContainer? right;
  final PlutoLayoutContainer? bottom;
  final PlutoLayoutContainer body;

  @override
  State<PlutoLayout> createState() => _PlutoLayoutState();
}

class _PlutoLayoutState extends State<PlutoLayout> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (c, r, w) {
          final layoutData = r.read(layoutDataProvider);

          final frontId = r.watch(layoutFocusedIdProvider);

          return CustomMultiChildLayout(
            delegate: _PlutoLayoutDelegate(layoutData),
            children: <LayoutId>[
              LayoutId(
                id: PlutoLayoutId.body,
                child: _LayoutIdProviderScope(
                  id: PlutoLayoutId.body,
                  child: widget.body,
                ),
              ),
              if (widget.right != null)
                LayoutId(
                  id: PlutoLayoutId.right,
                  child: _LayoutIdProviderScope(
                    id: PlutoLayoutId.right,
                    child: widget.right!,
                  ),
                ),
              if (widget.left != null)
                LayoutId(
                  id: PlutoLayoutId.left,
                  child: _LayoutIdProviderScope(
                    id: PlutoLayoutId.left,
                    child: widget.left!,
                  ),
                ),
              if (widget.bottom != null)
                LayoutId(
                  id: PlutoLayoutId.bottom,
                  child: _LayoutIdProviderScope(
                    id: PlutoLayoutId.bottom,
                    child: widget.bottom!,
                  ),
                ),
              if (widget.top != null)
                LayoutId(
                  id: PlutoLayoutId.top,
                  child: _LayoutIdProviderScope(
                    id: PlutoLayoutId.top,
                    child: widget.top!,
                  ),
                ),
            ]..sort((a, b) => a.id == frontId ? 1 : -1),
          );
        },
      ),
    );
  }
}

class _PlutoLayoutDelegate extends MultiChildLayoutDelegate {
  _PlutoLayoutDelegate(this._size);

  final PlutoLayoutData _size;

  @override
  void performLayout(Size size) {
    _size.size = size;

    PlutoLayoutId id = PlutoLayoutId.top;
    if (hasChild(id)) {
      _size.topSize = layoutChild(id, BoxConstraints.loose(size));
      positionChild(id, Offset.zero);
    }

    id = PlutoLayoutId.bottom;
    if (hasChild(id)) {
      _size.bottomSize = layoutChild(id, BoxConstraints.loose(size));
      positionChild(id, Offset(0, size.height - _size.bottomSize.height));
    }

    id = PlutoLayoutId.left;
    if (hasChild(id)) {
      _size.leftSize = layoutChild(
        id,
        BoxConstraints.loose(
          Size(
            size.width,
            max(size.height - _size.topSize.height - _size.bottomSize.height,
                0),
          ),
        ),
      );
      positionChild(id, Offset(0, _size.topSize.height));
    }

    id = PlutoLayoutId.right;
    if (hasChild(id)) {
      _size.rightSize = layoutChild(
        id,
        BoxConstraints.loose(
          Size(
            size.width,
            max(size.height - _size.topSize.height - _size.bottomSize.height,
                0),
          ),
        ),
      );
      positionChild(
        id,
        Offset(size.width - _size.rightSize.width, _size.topSize.height),
      );
    }

    id = PlutoLayoutId.body;
    if (hasChild(id)) {
      _size.bodySize = layoutChild(
        id,
        BoxConstraints.tight(Size(
          max(size.width - _size.leftSize.width - _size.rightSize.width, 0),
          max(size.height - _size.topSize.height - _size.bottomSize.height, 0),
        )),
      );
      positionChild(id, Offset(_size.leftSize.width, _size.topSize.height));
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}

class _LayoutIdProviderScope extends StatelessWidget {
  const _LayoutIdProviderScope({
    required this.id,
    required this.child,
  });

  final PlutoLayoutId id;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [layoutIdProvider.overrideWithValue(id)],
      child: child,
    );
  }
}

class PlutoLayoutData {
  Size size = Size.zero;

  Size topSize = Size.zero;

  Size leftSize = Size.zero;

  Size rightSize = Size.zero;

  Size bottomSize = Size.zero;

  Size bodySize = Size.zero;

  double get defaultTabWidth => size.width / 4;

  double get defaultTabHeight => size.height / 6;
}

enum PlutoLayoutId {
  top,
  left,
  right,
  bottom,
  body;

  bool get isTop => this == PlutoLayoutId.top;
  bool get isLeft => this == PlutoLayoutId.left;
  bool get isRight => this == PlutoLayoutId.right;
  bool get isBottom => this == PlutoLayoutId.bottom;
  bool get isBody => this == PlutoLayoutId.body;
}
