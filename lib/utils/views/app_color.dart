import 'package:flutter/material.dart';

class AppColor{

  static final Color? _secondaryBackgroundColorLight = Colors.grey[100];
  static final Color? _secondaryBackgroundColorDark = Colors.grey[600];

  static Color getSecondaryBackgroundColor(BuildContext context){
    Color? backgroundColor;
    if(MediaQuery.platformBrightnessOf(context) == Brightness.light) {
      backgroundColor = _secondaryBackgroundColorLight;
    }
    else{
      backgroundColor = _secondaryBackgroundColorDark;
    }
    return backgroundColor ?? Colors.red;
  }
}
