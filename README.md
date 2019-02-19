# flutter_drag_scale

A new flutter plugin project.


```
可缩放可拖拽的功能，可实现图片或者其他widget的缩放已经拖拽
并支持双击放大的功能
```
wechat ：674668211 加微信进flutter微信群

掘金： https://juejin.im/user/581206302f301e005c60cd2f

简书：https://www.jianshu.com/u/4a5dce56807b

csdn：https://me.csdn.net/liu__520

github : https://github.com/LiuC520/


我们知道官方提供了双击缩放，但是不支持拖拽的功能，我们要实现向百度地图那样可以缩放又可以拖拽的功能，官方的方法就不支持了。
下面先演示下功能：
![sample.gif](https://upload-images.jianshu.io/upload_images/3463020-7823ae1e8d9bf0f9.gif?imageMogr2/auto-orient/strip)

参数只有两个：
1、child ，是一个widget，可以是图片或者任意的widget
2、doubleTapStillScale，默认是true，意思是双击一直放大，还是只放大一次，再次双击缩小到原图片的大小，如果为false，第一次双击放大图片2倍，再次双击回位。

用法很简单：
1、导入依赖库
```
dependencies:
  flutter:
    sdk: flutter
  flutter_drag_scale:
    git: https://github.com/LiuC520/flutter_drag_scale.git
```
2、引入库：
```
import 'package:flutter_drag_scale/flutter_drag_scale.dart';
```
3、如下的用法：
```
import 'package:flutter/material.dart';
import 'package:flutter_drag_scale/flutter_drag_scale.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.0,
      width: 400,
      child: Center(
        child: DragScaleContainer(
          doubleTapStillScale: true,
          child: new Image(
            image: new NetworkImage(
                'http://h.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=0d023672312ac65c67506e77cec29e27/9f2f070828381f30dea167bbad014c086e06f06c.jpg'),
          ),
        ),
      ),
    );
  }
}

```