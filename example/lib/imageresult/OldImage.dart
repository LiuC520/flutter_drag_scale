import 'dart:ui' as flutterUi;

import 'ImageUtil.dart';

class OldImage {
  String _url;
  flutterUi.Image _image;

  OldImage._();

  static OldImage _instance;

  static OldImage getInstance() {
    if (_instance == null) {
      _instance = OldImage._();
    }
    return _instance;
  }

  Future<flutterUi.Image> loadImage(String url) {
    if (_url != null && _url.endsWith(url) && _image != null) {
      return Future.value(_image);
    }

    _url = url;
    return ImageUtil.load(url).then((getImage) {
      return ImageUtil.clipImage(getImage).then((clipImage) {
        _image = clipImage;
        return _image;
      });
    });
  }

  void destroy() {
    _image = null;
    _url = null;
  }
}
