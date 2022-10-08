import 'package:flutter/cupertino.dart';
import 'package:pluto_layout/pluto_layout.dart';

import 'controllers/controllers.dart';

class PlutoLayoutController extends ChangeNotifier
    with MenuControllerMixin, LayoutControllerMixin {
  PlutoLayoutController({
    List<PlutoLayoutMenuItem>? leftMenus,
    List<PlutoLayoutMenuItem>? rightMenus,
    this.minTabViewWidth = 32.0,
  })  : _leftMenus = leftMenus ?? const [],
        _rightMenus = rightMenus ?? const [];

  final List<PlutoLayoutMenuItem> _leftMenus;

  final List<PlutoLayoutMenuItem> _rightMenus;

  @override
  final double minTabViewWidth;

  @override
  List<PlutoLayoutMenuItem> get leftMenus => _leftMenus;

  @override
  List<PlutoLayoutMenuItem> get rightMenus => _rightMenus;
}
