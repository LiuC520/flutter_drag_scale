import 'package:flutter/src/gestures/events.dart' show PointerEvent;

/// Signature for callback when the user has tapped the screen at the same
/// location twice in quick succession.
typedef GestureDoubleTapCallback = void Function(DoubleDetails details);

/// double tap callback details
/// 双击的回调信息
class DoubleDetails {
  DoubleDetails({this.pointerEvent});
  final PointerEvent pointerEvent;
  @override
  String toString() => 'DoubleDetails(pointerEvent: $pointerEvent)';
}
