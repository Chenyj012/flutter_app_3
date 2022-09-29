//import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
//import 'package:extended_image_library/extended_image_library.dart';
class ExtendImage extends StatelessWidget {

  final String imageUrl;

  const ExtendImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Container(
          child:  /*ExtendedImage.network(
            '${imageUrl}',
            fit: BoxFit.contain,
            //enableLoadState: false,
            mode: ExtendedImageMode.Gesture,
            gestureConfig: GestureConfig (
                minScale: 0.9,
                animationMinScale: 0.7,
                maxScale: 3.0,
                animationMaxScale: 3.5,
                speed: 1.0,
                inertialSpeed: 100.0,
                initialScale: 1.0,
                inPageView: false),
          )*/
          /*ExtendedImage.network(
            '${imageUrl}',
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: (state) {
              return GestureConfig(
                minScale: 1.0,
                animationMinScale: 1.0,
                maxScale: 3.0,
                animationMaxScale: 3.5,
                speed: 1.0,
                inertialSpeed: 100.0,
                initialScale: 1.0,
              );
            },
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          )*/
      ),
    );
  }
}