import 'dart:ui' as flutterUi;
import 'dart:ui';
import 'package:flutter_drag_scale/flutter_drag_scale.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'ImageUtil.dart';
import 'DrawWidget.dart';
import 'OldImage.dart';

class SingleImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new PreviewImageWidget();
  }
}

class PreviewImageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SingleImageState();
  }
}

class SingleImageState extends State<PreviewImageWidget> {
  final GlobalKey pipCaptureKey = new GlobalKey();

  List<Offset> datoudingOffset = [Offset(60, 60)]; //大头钉的位置

  int currentIndex = 0;
  flutterUi.Image _bigImage;
  flutterUi.Image _datoudingImage;
  Offset offset = Offset(0, 0);
  String datouding = "images/datouding.png";
  @override
  void initState() {
    super.initState();
    reLoad();
  }

  @override
  void dispose() {
    super.dispose();
    OldImage.getInstance().destroy();
  }

  void reLoad() {
    print(this.currentIndex);
    String oldImageUrl = "images/lctest.jpg";
    Future.wait([
      OldImage.getInstance().loadImage(oldImageUrl),
      ImageUtil.drawImage(oldImageUrl, this.datouding, datoudingOffset[0]),
    ]).then((results) {
      _datoudingImage = results[1];
      _bigImage = results[0];
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
          child: new Container(
              child: new Column(children: <Widget>[
        new Expanded(child: getImageWidget()),
        RaisedButton(
          child: Text("更换状态"),
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: () {
            this.setState(() {
              datouding = this.datouding == "images/datouding_blue.png"
                  ? "images/datouding.png"
                  : "images/datouding_blue.png";
            });

            reLoad();
          },
        )
      ]))),
    );
  }

  Widget getImageWidget() {
    return RepaintBoundary(
      key: pipCaptureKey,
      child: new Center(
        child: DragScaleContainer(
            doubleTapStillScale: true,
            child: new DrawWidget(_bigImage, _datoudingImage)),
      ),
    );
  }
}
