import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/controllers/refer_and_earn_controller.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/widgets/referral_earn_bottomsheet_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:share_plus/share_plus.dart';

class ReferralDetailsScreen extends StatelessWidget {
  const ReferralDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReferAndEarnController>(builder: (referAndEarnController){
      return (Get.find<SplashController>().config?.referralEarningStatus ?? false) ?
      SingleChildScrollView(
        child: Column(children: [
          Image.asset(Images.homeReferralIcon,height: 120,width: 120),
          const SizedBox(height: Dimensions.paddingSizeSmall),
        
          Text('invite_friend_getRewards'.tr,style: textSemiBold.copyWith(fontSize: 16)),
          const SizedBox(height: Dimensions.paddingSizeSmall),
        
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSignUp),
            child: RichText(text: TextSpan(
                text: 'referral_bottom_sheet_note'.tr,
                style: textRegular.copyWith(color: Theme.of(context).colorScheme.secondaryFixedDim,fontSize: Dimensions.fontSizeSmall),
                children: [TextSpan(
                  text: '  ${PriceConverter.convertPrice(context, referAndEarnController.referralDetails?.data?.shareCodeEarning ?? 0)}  ',
                  style: textRobotoBold.copyWith(color: Theme.of(context).colorScheme.secondaryFixedDim,fontSize: Dimensions.fontSizeSmall),
                ),
                  TextSpan(
                    text: 'wallet_balance'.tr,
                    style: textRegular.copyWith(color: Theme.of(context).colorScheme.secondaryFixedDim,fontSize: Dimensions.fontSizeSmall),
                  )
                ]
            ),textAlign: TextAlign.center),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
        
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              width: Get.width * 0.25,
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall,right: Dimensions.paddingSizeSmall,bottom: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
              ),
              child: Column(children: [
                Align(alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.75),
                        shape: BoxShape.circle
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        
                    child: const Text('1'),
                  ),
                ),
        
                Image.asset(Images.referralIcon1,height: 24,width: 24,color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color : Theme.of(context).textTheme.bodyLarge!.color),
                const SizedBox(height: Dimensions.paddingSizeSmall),
        
                Text('invite_or_share_the_code'.tr, textAlign: TextAlign.center,style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,
                  color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.6) : Theme.of(context).colorScheme.secondaryFixedDim,
                ))
              ]),
            ),
        
            Container(
              width: Get.width * 0.25,
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall,right: Dimensions.paddingSizeSmall,bottom: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
              ),
              child: Column(children: [
                Align(alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.75),
                        shape: BoxShape.circle
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        
                    child: const Text('2'),
                  ),
                ),
        
                Image.asset(Images.referralIcon2,height: 24,width: 24,color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color : Theme.of(context).textTheme.bodyLarge!.color),
                const SizedBox(height: Dimensions.paddingSizeSmall),
        
                Text('your_friend_sign_up'.tr,textAlign: TextAlign.center,style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.6) : Theme.of(context).colorScheme.secondaryFixedDim,
                ))
              ]),
            ),
        
            Container(
              width: Get.width * 0.25,
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall,right: Dimensions.paddingSizeSmall,bottom: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
              ),
              child: Column(children: [
                Align(alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.75),
                        shape: BoxShape.circle
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        
                    child: const Text('3'),
                  ),
                ),
        
                Image.asset(Images.referralIcon3,height: 24,width: 24,color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color : Theme.of(context).textTheme.bodyLarge!.color),
                const SizedBox(height: Dimensions.paddingSizeSmall),
        
                Text('both_you_and_friend_will'.tr,textAlign: TextAlign.center,style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.6) : Theme.of(context).colorScheme.secondaryFixedDim,
                ))
              ]),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
        
          Container(
            width: Get.width * 0.9,
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
                color: Theme.of(context).highlightColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.25))
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(referAndEarnController.referralDetails?.data?.referralCode ?? '',style: textBold),
        
              InkWell(
                onTap: (){
                  Clipboard.setData(ClipboardData(text: referAndEarnController.referralDetails?.data?.referralCode ?? '')).then((_){
                    showCustomSnackBar('copied'.tr,isError: false);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.radiusDefault), bottomRight: Radius.circular(Dimensions.radiusDefault)),
                  ),
                  child: Icon(Icons.copy_rounded,color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color : Theme.of(context).primaryColor),
                ),
              )
            ]),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        
          ButtonWidget(
              onPressed: () async{
                await Share.share(
                    'Greetings, \n ${Get.find<SplashController>().config?.businessName} is the best ride share & parcel delivery platform in the country.'
                        ' If you are new to this don’t forget to use \n "${referAndEarnController.referralDetails?.data?.referralCode ?? ''}" \n as the referral code while sign up into ${Get.find<SplashController>().config?.businessName} & you will get rewarded.'
                        '\n\n ${AppConstants.baseUrl}'
                );
              },
              width: Get.width * 0.5,
              buttonText: 'invite_friends'.tr
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        
          InkWell(
            onTap: () => Get.bottomSheet(const ReferralEarnBottomsheetWidget(),isDismissible: false),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('how_it_works'.tr,style: textRegular.copyWith(
                decoration: TextDecoration.underline,
                color: Theme.of(context).colorScheme.surfaceContainer,
                decorationColor: Theme.of(context).colorScheme.surfaceContainer ,
              )),
              const SizedBox(width: Dimensions.paddingSizeSmall),
        
              const Icon(Icons.help_outline)
            ]),
          )
        
        ]),
      ) :
      Column(children: [
        const SizedBox(height: Dimensions.topSpace),

        Image.asset(Images.homeReferralIcon,height: 140,width: 140),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text('stay_tuned_to_earn_big'.tr,style: textSemiBold.copyWith(color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.9) : null)),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
          child: Text(
              'our_refer_and_earn_program_is_temporarily_paused'.tr,textAlign: TextAlign.center,
              style: textRegular.copyWith(color: Theme.of(context).colorScheme.secondaryFixedDim,fontSize: Dimensions.fontSizeSmall)
          ),
        ),
      ]);
    });
  }
}