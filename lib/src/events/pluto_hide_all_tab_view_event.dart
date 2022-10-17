import 'events.dart';

class PlutoHideAllTabViewEvent extends PlutoLayoutEvent {
  const PlutoHideAllTabViewEvent({
    this.afterFocusToBody = true,
  });

  final bool afterFocusToBody;
}
