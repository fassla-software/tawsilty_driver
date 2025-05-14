import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class AppVersionWarningScreen extends StatelessWidget {
  const AppVersionWarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(children: [
              const SizedBox(height: Dimensions.topSpace),

              Image.asset(Get.isDarkMode
                                            ? Images.logoNameWhite
                                            : Images.logoNameBlack, height: 75),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Image.asset(Images.appVersionWarningIcon, height: 150),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('new_update_is_available'.tr,style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: RichText(text: TextSpan(
                    text: '${'you_are_using_old_version'.tr} ',
                    style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).colorScheme.secondaryFixedDim
                    ),
                    children: [
                      TextSpan(
                        text: '(${AppConstants.appVersion}).',
                        style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                      ),
                      TextSpan(
                          text: 'added_some_new_feature'.tr,
                          style: textRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).colorScheme.secondaryFixedDim
                          )
                      )
                    ]
                ),textAlign: TextAlign.center),
              ),

              const Spacer(),

              ButtonWidget(
                buttonText: '${'download_new_version'.tr} (${Platform.isAndroid ? Get.find<SplashController>().config?.androidAppMinimumVersion : Get.find<SplashController>().config?.iosAppMinimumVersion})',
                onPressed: (){
                  if(Platform.isAndroid){
                    launchUrl(Uri.parse(Get.find<SplashController>().config?.androidAppUrl ?? ''));
                  }else if(Platform.isIOS){
                    launchUrl(Uri.parse(Get.find<SplashController>().config?.iosAppUrl ?? ''));
                  }
                },
              ),

            ]),
          ),
        ),
      ),
    );
  }
}