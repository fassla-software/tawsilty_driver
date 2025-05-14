import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class WithdrawSuccessfulDialogWidget extends StatelessWidget {
  const WithdrawSuccessfulDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(surfaceTintColor: Theme.of(context).cardColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(onTap: ()=> Get.back(), child: Container(
              decoration: BoxDecoration(color: Theme.of(context).hintColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Image.asset(
                Images.crossIcon,
                height: Dimensions.paddingSizeSmall,
                width: Dimensions.paddingSizeSmall,
                color: Theme.of(context).cardColor,
              ),
            )),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
          
          Image.asset(Images.withdrawSuccessIcon,width: 80,height: 80),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
        
          Text('withdraw_request_sent_successfully'.tr,style: textBold, textAlign: TextAlign.center),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text('request_just_send_to_admin'.tr,style: textRegular, textAlign: TextAlign.center),
          const SizedBox(height: Dimensions.paddingSizeOver),
        ]),
      ),
    );
  }
}
