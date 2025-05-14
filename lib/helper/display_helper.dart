import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/responsive_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

void customPrint(String message) {
  if(kDebugMode) {
    print(message);
  }
}

void showCustomSnackBar(String message, {bool isError = true, int seconds = 3,String? subMessage}) {
  Get.closeCurrentSnackbar();
  Get.showSnackbar(GetSnackBar(
    dismissDirection: DismissDirection.horizontal,
    margin: const EdgeInsets.all(Dimensions.paddingSizeSmall).copyWith(
      right: ResponsiveHelper.isDesktop ? Get.context!.width*0.7 : Dimensions.paddingSizeSmall,
    ),
    duration: Duration(seconds: seconds),
    backgroundColor: Get.isDarkMode ? Colors.white : Theme.of(Get.context!).textTheme.titleMedium!.color!,
    borderRadius: Dimensions.paddingSizeSmall,
    messageText: Row(children: [
      Image.asset(isError ? Images.errorMessageIcon : Images.successMessageIcon,height: 20,width: 20,),

      const SizedBox(width: Dimensions.paddingSize,),
      Expanded(child: SizedBox(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(message, style: textMedium.copyWith(color: Get.isDarkMode ? Theme.of(Get.context!).textTheme.bodySmall!.color : Colors.white)),
        subMessage != null ?
        Text(
            subMessage,
            style: textMedium.copyWith(color: Get.isDarkMode ?
            Theme.of(Get.context!).textTheme.bodySmall!.color!.withOpacity(0.75) :
            Colors.white.withOpacity(0.75),
            ),
        ) : const SizedBox(),

      ]))),

    ]),

  ));
}
