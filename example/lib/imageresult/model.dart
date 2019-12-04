import 'dart:ui';

class Model {
  final int index;
  final bool isRed;

  final String img;

  final Offset offset;

  const Model(
      {this.index = 0, this.isRed = true, this.img = '', this.offset = null});

  @override
  String toString() {
    return 'Model{序号：$index，是否是红色的:$isRed, img: $img, 坐标便宜: $offset}';
  }
}
