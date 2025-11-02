import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
class AppSizes {

  /// Get percentage of screen width
  double getWidthPercentage(double percentage) {
    return Get.width * (percentage / 100);
  }
  /// Get percentage of screen height
  double getHeightPercentage(double percentage) {
    return Get.height * (percentage / 100);
  }
  /// Method to get horizontal padding based on screen width percentage
  EdgeInsets getCustomPadding({double right = 4,double left = 4,double top = 2, double bottom = 2}) {
    return EdgeInsets.only(
      right: getWidthPercentage(right),
      left: getWidthPercentage(left),
      top: getHeightPercentage(top),
      bottom: getHeightPercentage(bottom),
    );
  }
}