import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


void configLoading(BuildContext context) {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 17.0
    ..progressColor =  Color.fromARGB(255, 64, 135, 193)
    ..indicatorColor = const Color.fromARGB(255, 64, 135, 193)
    ..backgroundColor = Colors.transparent
    ..textColor = Colors.white 
    ..userInteractions = false
    ..dismissOnTap = false;
}


class LoadingIndicator {
  static void show() {
    EasyLoading.show();
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }
}
