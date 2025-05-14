import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/animated_wifi/animated_wifi_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';

class StayOnlineWidget extends StatelessWidget {
  const StayOnlineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      initState: (val){
        Get.find<ProfileController>().getProfileInfo();
      },
      builder: (profileController) {
        log("=online==>${profileController.profileInfo!.details!.isOnline}");
        bool isOnline = profileController.profileInfo!.details!.isOnline! == "1";
        return Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault,top: Dimensions.paddingSize),
          child: Column(children: [

            /*SizedBox(width: isOnline?  Dimensions.iconSizeOnline: Dimensions.iconSizeOffline,
                child: Image.asset(isOnline? Get.isDarkMode? Images.darkWifi : Images.lightWifi : Images.offlineMode, color: isOnline? null :Get.isDarkMode?Colors.white:Theme.of(context).primaryColor,)),*/
            Container(padding: EdgeInsets.only(top: Get.height *0.005,left: Get.width * 0.03),
                height:80,width:100,child: const WifiAnimations()),

            Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeExtraSmall),
              child: Text(isOnline? 'stay_online'.tr : "you_are_in_offline_mode".tr,
                  style: textBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge))),

            Text(isOnline? 'customer_are_surrounding_you'.tr:"stay_online_mode_to_get_more_ride".tr,
                style: textMedium.copyWith()),

          ]),
        );
      }
    );
  }
}


