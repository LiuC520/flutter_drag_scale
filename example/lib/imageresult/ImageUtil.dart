import 'dart:async';
import 'dart:ui' as flutterUi;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'OldImage.dart';
import 'package:flutter/services.dart';

class ImageUtil {
  static double scale = 1;
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
    canvas.drawImageRect(image, Rect.fromLTWH(0, 0, width, height),
        Rect.fromLTWH(0, 0, newWidth, newHeight), paint);

    return recorder.endRecording().toImage(newWidth.toInt(), newHeight.toInt());
  }

  static Future<flutterUi.Image> drawImage(
      String oldImageUrl, String datoudingImage, Offset offset) {
    Completer<flutterUi.Image> completer = new Completer<flutterUi.Image>();
    Future.wait([
      load(datoudingImage),
      OldImage.getInstance().loadImage(oldImageUrl),
    ]).then((result) {
      Paint paint = new Paint();
      PictureRecorder recorder = PictureRecorder();
      Canvas canvas = Canvas(recorder);

      int width = result[1].width;
      int height = result[1].height;
      paint.filterQuality = FilterQuality.high;
      paint.isAntiAlias = true;

      canvas.drawImage(result[1], Offset(0, 0), paint);
      double dtdWidth = result[0].width / scale;
      double dtdHeight = result[0].height / scale;

      canvas.drawImageRect(
          result[0],
          Rect.fromLTWH(
              0, 0, result[0].width.toDouble(), result[0].height.toDouble()),
          Rect.fromLTWH(offset.dx, offset.dy, dtdWidth, dtdHeight),
          paint);
      recorder.endRecording().toImage(width, height).then((image) {
        completer.complete(image);
      });
    }).catchError((e) {
      print("加载error:" + e);
    });
    return completer.future;
  }
}
