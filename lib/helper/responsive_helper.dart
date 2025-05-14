import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';

class ResponsiveHelper {

  static bool get isMobilePhone => !kIsWeb;

  static bool get isWeb => kIsWeb;

  static bool get isMobile => Get.context!.width < 650 || !kIsWeb;

  static bool get isTab => Get.context!.width < 1300 && Get.context!.width >= 650;

  static bool get isDesktop => Get.context!.width >= 1300;

}