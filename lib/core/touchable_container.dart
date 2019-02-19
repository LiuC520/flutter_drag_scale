import 'package:flutter/material.dart';
import './custom_gesture_detector.dart' as gd;

class ScaleChangedModel {
  double scale;
  Offset offset;
  ScaleChangedModel({this.scale, this.offset});

  @override
  String toString() {
    return 'ScaleChangedModel(scale: $scale, offset:$offset)';
  }
}

class TouchableContainer extends StatefulWidget {
  final Widget child;
  final bool doubleTapStillScale;

  ///用来约束图和坐标轴的
  ///因为坐标轴和图是堆叠起来的，图在坐标轴的内部，需要制定margin，否则放大后图会超出坐标轴
  final EdgeInsets margin;
  ValueChanged<ScaleChangedModel> scaleChanged;

  TouchableContainer(
      {this.child,
      EdgeInsets margin,
      this.scaleChanged,
      this.doubleTapStillScale})
      : this.margin = margin ?? EdgeInsets.all(0);
  _TouchableContainerState createState() => _TouchableContainerState();
}

class _TouchableContainerState extends State<TouchableContainer>
    with SingleTickerProviderStateMixin {
  double _kMinFlingVelocity = 800.0;
  AnimationController _controller;
  Animation<Offset> _flingAnimation;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;
  Offset doubleDownPositon;
  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(vsync: this)
      ..addListener(_handleFlingAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // The maximum offset value is 0,0. If the size of this renderer's box is w,h
  // then the minimum offset value is w - _scale * w, h - _scale * h.
  //也就是最小值是原点0，0，点从最大值到0的区间，也就是这个图可以从最大值移动到原点
  Offset _clampOffset(Offset offset) {
    final Size size = context.size; //容器的大小
    final Offset minOffset =
        new Offset(size.width, size.height) * (1.0 - _scale);
    return new Offset(
        offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
  }

  void _handleFlingAnimation() {
    setState(() {
      _offset = _flingAnimation.value;
    });
  }

  void _handleOnScaleStart(gd.ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      // The fling animation stops if an input gesture starts.
      _controller.stop();
    });
  }

  void _handleOnScaleUpdate(gd.ScaleUpdateDetails details) {
    setState(() {
      if (details.pointCount > 1) {
        _scale = (_previousScale * details.scale).clamp(1.0, double.infinity);
      }
      // Ensure that image location under the focal point stays in the same place despite scaling.
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
    });
    ScaleChangedModel model =
        new ScaleChangedModel(scale: _scale, offset: _offset);
    if (widget.scaleChanged != null) widget.scaleChanged(model);
  }

  void _handleOnScaleEnd(gd.ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity) return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    final double distance = (Offset.zero & context.size).shortestSide;
    _flingAnimation = new Tween<Offset>(
            begin: _offset, end: _clampOffset(_offset + direction * distance))
        .animate(_controller);
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
  }

  void _onDoubleTap(gd.DoubleDetails details) {
    _normalizedOffset = (details.pointerEvent.position - _offset) / _scale;
    if (!widget.doubleTapStillScale && _scale != 1.0) {
      setState(() {
        _scale = 1.0;
        _offset = Offset.zero;
      });
      return;
    }
    setState(() {
      if (widget.doubleTapStillScale) {
        _scale *= (1 + 0.2);
      } else {
        _scale *= (2);
      }
      // Ensure that image location under the focal point stays in the same place despite scaling.
      // _offset = doubleDownPositon;
      _offset = _clampOffset(
          details.pointerEvent.position - _normalizedOffset * _scale);
    });

    ScaleChangedModel model =
        new ScaleChangedModel(scale: _scale, offset: _offset);
    if (widget.scaleChanged != null) widget.scaleChanged(model);
  }

  @override
  Widget build(BuildContext context) {
    return new gd.GestureDetector(
      // onPanDown: _onPanDown,
      onDoubleTap: _onDoubleTap,
      onScaleStart: _handleOnScaleStart,
      onScaleUpdate: _handleOnScaleUpdate,
      // onScaleEnd: _handleOnScaleEnd,
      child: Container(
        margin: widget.margin,
        constraints: const BoxConstraints(
          minWidth: double.maxFinite,
          minHeight: double.infinity,
        ),
        child: new Transform(
            transform: new Matrix4.identity()
              ..translate(_offset.dx, _offset.dy)
              ..scale(_scale, _scale, 1.0),
            child: widget.child),
      ),
    );
  }
}
