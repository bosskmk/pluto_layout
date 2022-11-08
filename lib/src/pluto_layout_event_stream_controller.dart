import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'events/events.dart';

/// Event controller in PlutoLayout
///
/// Listen for events to handle keyboard shortcut events, etc.
/// The received event is handled by listening to the event
/// in the widget that needs event handling.
class PlutoLayoutEventStreamController {
  final PublishSubject<PlutoLayoutEvent> _subject =
      PublishSubject<PlutoLayoutEvent>();

  /// Register event handlers in widgets that need to handle events.
  StreamSubscription<PlutoLayoutEvent> listen(
    void Function(PlutoLayoutEvent) handler,
  ) {
    return _subject.listen(handler);
  }

  void add(PlutoLayoutEvent event) {
    _subject.add(event);
  }

  void dispose() {
    _subject.close();
  }
}
