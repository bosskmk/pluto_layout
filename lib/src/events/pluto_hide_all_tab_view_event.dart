import 'package:pluto_layout/pluto_layout.dart';

class PlutoHideAllTabViewEvent extends PlutoLayoutEvent {
  PlutoHideAllTabViewEvent({
    this.afterFocusToBody = true,
  });

  final bool afterFocusToBody;
}
