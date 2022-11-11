import 'package:flutter/widgets.dart';
import 'package:pluto_layout/pluto_layout.dart';

class BottomTab extends StatelessWidget {
  const BottomTab({super.key});

  @override
  Widget build(BuildContext context) {
    return PlutoLayoutTabs(
      mode: PlutoLayoutTabMode.showSelected,
      draggable: true,
    );
  }
}
