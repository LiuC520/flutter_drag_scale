import 'dart:ui' as flutterUi;

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DrawWidget extends StatefulWidget {
  flutterUi.Image _oldImage;
  flutterUi.Image _image;

  DrawWidget(this._oldImage, this._image);

  @override
  State<StatefulWidget> createState() {
    return new DrawState();
  }
}

class DrawState extends State<DrawWidget> {
  double _width;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: _width,
        height: _width,
        color: Colors.lightBlue,
        child: new Stack(
          children: <Widget>[
            CustomPaint(
                painter: DrawPainter(widget._oldImage), size: Size(360, 360)),
            CustomPaint(
                painter: DrawPainter(widget._image), size: Size(360, 360)),
          ],
        ));
  }
}

class DrawPainter extends CustomPainter {
  DrawPainter(this._image);

  flutterUi.Image _image;
  Paint _paint = new Paint();

  @override
  void paint(Canvas canvas, Size size) {
    if (_image != null) {
      _paint.filterQuality = FilterQuality.high;
      _paint.isAntiAlias = true;

      canvas.drawImageRect(
          _image,
          Rect.fromLTWH(
              0, 0, _image.width.toDouble(), _image.height.toDouble()),
          Rect.fromLTWH(
              0, 0, _image.width.toDouble(), _image.height.toDouble()),
          _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
