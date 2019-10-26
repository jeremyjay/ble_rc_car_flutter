import 'package:flutter/widgets.dart';

class SizeConfig{
    // static MediaQueryData _mediaQueryData;
  // double size = _mediaQueryData.size.longestSide *
  //               _mediaQueryData.devicePixelRatio;
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
 
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    // print(screenHeight);
    // print(screenWidth);
  }   


}
