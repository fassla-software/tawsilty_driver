import 'package:get/get.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';

class Dimensions {
  static double fontSizeExtraSmall = Get.context!.width >= 1300 ? 14 : 10;
  static double fontSizeSmall = Get.context!.width >= 1300 ? 16 : 12;
  static double fontSizeDefault = Get.context!.width >= 1300 ? 18 : 14;
  static double fontSizeLarge = Get.context!.width >= 1300 ? 20 : 16;
  static double fontSizeExtraLarge = Get.context!.width >= 1300 ? 22 : 18;
  static double fontSizeOverLarge = Get.context!.width >= 1300 ? 28 : 24;

  static const double paddingSizeTiny = 3.0;
  static const double paddingSizeExtraSmall = 5.0;
  static const double paddingSizeSeven = 7.0;
  static const double paddingSizeSmall = 10.0;
  static const double paddingSize = 12.0;
  static const double paddingSizeDefault = 15.0;
  static const double paddingSizeLarge = 20.0;
  static const double paddingSizeExtraLarge = 25.0;
  static const double paddingSizeSignUp = 35.0;
  static const double paddingSizeOverLarge = 30.0;
  static const double paddingSizeOver = 50.0;
  static  double splashLogoWidth = Get.context!.width <= 400 ?120 : 150.0;

  static const double radiusSmall = 5.0;
  static const double radiusDefault = 10.0;
  static const double radiusLarge = 15.0;
  static const double radiusExtraLarge = 20.0;

  static const double webMaxWidth = 1170;
  static const double identityImageWidth = 130;
  static const double identityImageHeight = 80;
  static const double menuIconSize = 25;
  static const double appBarHeight = 250;
  static const double androidAppBarHeight = 200;

  static const double iconSizeSmall = 15;
  static const double iconSizeMedium = 20;
  static const double rewardImageSize = 70;
  static const double rewardImageSizeOfferPage = 150;
  static const double customerReactionSize = 100;
  static const double iconSizeLarge = 25;
  static const double iconSizeExtraLarge = 30;
  static const double iconSizeOnline = 100;
  static const double iconSizeOffline = 50;
  static const double iconSizeDoubleExtraLarge = 40;
  static const double iconSizeDialog = 60;
  static const double roadArrowHeight = 50;
  static const double weatherIconSize = 60;
  static const double dropDownWidth = 140;
  static const double compassPadding = 50;
  static const double topSpace = 100;
  static const double topBelowSpace = 40;


  static const double orderStatusIconHeight = 70;
  static double headerCardHeight = Get.find<LocalizationController>().isLtr? 45 : 53;

}
