import 'dart:async';
import 'dart:ui' as flutterUi;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/services.dart';

import 'model.dart';

class ImageUtil {
  static double scale = 1;
  static Size size = Size(0, 0);
  static AssetBundle getAssetBundle() => (rootBundle != null)
      ? rootBundle
      : new NetworkAssetBundle(new Uri.directory(Uri.base.origin));

  static Future<flutterUi.Image> load(String url) async {
    ImageStream stream = new AssetImage(url, bundle: getAssetBundle())
        .resolve(ImageConfiguration.empty);
    Completer<flutterUi.Image> completer = new Completer<flutterUi.Image>();
    void listener(ImageInfo frame, bool synchronousCall) {
      final flutterUi.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(new ImageStreamListener(listener));
    }

    stream.addListener(new ImageStreamListener(listener));
    return completer.future;
  }

  /// 裁剪图片
  static Future<flutterUi.Image> clipImage(flutterUi.Image image) {
    PictureRecorder recorder = PictureRecorder();
    Paint paint = new Paint();
    Canvas canvas = Canvas(recorder);
    double screenWidth = window.physicalSize.width / window.devicePixelRatio;
    double width = image.width.toDouble();
    double height = image.height.toDouble();
    double newWidth = width;
    double newHeight = height;

    if (width > screenWidth) {
      newWidth = screenWidth;
      newHeight = height * newWidth / width;
    }
    scale = width / newWidth;
    paint.filterQuality = FilterQuality.high;
    paint.isAntiAlias = true;
    size = Size(newWidth, newHeight);
    canvas.drawImageRect(image, Rect.fromLTWH(0, 0, width, height),
        Rect.fromLTWH(0, 0, newWidth, newHeight), paint);

    return recorder.endRecording().toImage(newWidth.toInt(), newHeight.toInt());
  }

  static Future<flutterUi.Image> drawImage(
      String oldImageUrl, List<Model> models) {
    Completer<flutterUi.Image> completer = new Completer<flutterUi.Image>();
    List<Future<flutterUi.Image>> imgs = new List();
    for (int i = 0; i < models.length; i++) {
      imgs.add(load(models[i].img));
    }
    print(imgs.length);

    Future.wait(imgs).then((result) {
      print("shadingl ${result.length}");
      Paint paint = new Paint();
      PictureRecorder recorder = PictureRecorder();
      Canvas canvas = Canvas(recorder);

      int width = size.width.toInt();
      int height = size.height.toInt();
      print(size);
      paint.filterQuality = FilterQuality.high;
      paint.isAntiAlias = true;
      double dtdWidth = result[1].width / scale;
      double dtdHeight = result[1].height / scale;
      for (int i = 0; i < models.length; i++) {
        print(models[i].offset);
        canvas.drawImageRect(
            result[i],
            Rect.fromLTWH(
                0, 0, result[i].width.toDouble(), result[i].height.toDouble()),
            Rect.fromLTWH(
                models[i].offset.dx, models[i].offset.dy, dtdWidth, dtdHeight),
            paint);
      }

      recorder.endRecording().toImage(width, height).then((image) {
        completer.complete(image);
      });
    }).catchError((e) {
      print("加载error:" + e);
    });
    return completer.future;
  }
}
