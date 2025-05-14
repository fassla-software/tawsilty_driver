import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class LoyaltyPointConvertedSuccessfullyDialogWidget extends StatelessWidget {
  const LoyaltyPointConvertedSuccessfullyDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: SizedBox(width: 70,child: Image.asset(Images.loyaltyPoint)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
            child: Text.rich(
              TextSpan(

                children: [
                  TextSpan(text: 'loyalty_point_converted_to_wallet_money'.tr, style: textBold.copyWith()),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: 'successfully'.tr,
                    style: textBold.copyWith(color: Theme.of(context).primaryColor),
                  ),

                ],
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Get.back();
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
              child: Text('check_wallet'.tr,
                style: textRegular.copyWith(decoration: TextDecoration.underline,
                    color: Theme.of(context).primaryColor.withOpacity(.75)),),
            ),
          )
        ],),
      ),
    );
  }
}
