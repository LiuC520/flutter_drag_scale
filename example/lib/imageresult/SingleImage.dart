import 'dart:math';
import 'dart:ui' as flutterUi;
import 'dart:ui';
import 'package:flutter_drag_scale/flutter_drag_scale.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'ImageUtil.dart';
import 'DrawWidget.dart';
import 'OldImage.dart';
import 'model.dart';

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

  List<Model> datas = new List();
  List<Offset> offsets = [
    Offset(10, 60),
    Offset(40, 60),
    Offset(80, 60),
    Offset(120, 60),
    Offset(160, 60),
    Offset(200, 60),
    Offset(240, 60),
    Offset(280, 60),
  ];
  int currentIndex = 0;
  flutterUi.Image _bigImage;
  flutterUi.Image _datoudingImage;
  String datouding = "images/datouding.png";
  String datouding_blue = "images/datouding_blue.png";
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < offsets.length; i++) {
      Model model = new Model(
          index: i,
          isRed: i % 2 == 0 ? true : false,
          img: i % 2 == 0 ? datouding : datouding_blue,
          offset: offsets[i]);
      datas.add(model);
    }
    reLoad();
  }

  @override
  void dispose() {
    super.dispose();
    OldImage.getInstance().destroy();
  }

  void reLoad() {
    String oldImageUrl = "images/lctest.jpg";
    Future.wait([
      OldImage.getInstance().loadImage(oldImageUrl),
    ]).then((results) {
      _bigImage = results[0];
      Future.wait([ImageUtil.drawImage(oldImageUrl, datas)]).then((results) {
        _datoudingImage = results[0];
        if (mounted) {
          setState(() {});
        }
      });
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
            Model m1 = datas[0];
            Model m2 = datas[6];
            Model model0 = Model(
                index: m1.index,
                isRed: !m1.isRed,
                img: m1.img == "images/datouding_blue.png"
                    ? "images/datouding.png"
                    : "images/datouding_blue.png",
                offset: m1.offset);
            datas[0] = model0;
            Model model3 = Model(
                index: m2.index,
                isRed: !m2.isRed,
                img: m2.img == "images/datouding_blue.png"
                    ? "images/datouding.png"
                    : "images/datouding_blue.png",
                offset: m2.offset);
            datas[6] = model3;

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
