import 'package:pluto_layout/pluto_layout.dart';

class PlutoHideAllTabViewEvent extends PlutoLayoutEvent {
  const PlutoHideAllTabViewEvent({
    this.afterFocusToBody = true,
  });

  final bool afterFocusToBody;
}
