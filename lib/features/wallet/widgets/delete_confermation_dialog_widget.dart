import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class DeleteConfirmationDialogWidget extends StatelessWidget {
  final bool fromFailed;
  final String? methodId;
  const DeleteConfirmationDialogWidget({super.key,this.fromFailed = false,this.methodId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: Column(mainAxisSize: MainAxisSize.min,children: [
          const SizedBox(height: Dimensions.paddingSizeSignUp),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(100)
            ),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Icon(CupertinoIcons.delete_solid, size: 30.0,color: Theme.of(context).cardColor),
              ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          if(!fromFailed)...[
            Text('delete_this_payment_method'.tr),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text('delete_note'.tr,textAlign: TextAlign.center),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              InkWell(
                onTap: ()=> Get.back(),
                child: Container(
                  width: Get.width * 0.3,
                  height: Get.height * 0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      color: Theme.of(context).hintColor.withOpacity(0.25)
                  ),
                  child: Center(child: Text('no'.tr,style: textRegular)),
                ),
              ),

              InkWell(onTap: ()=> Get.find<WalletController>().deleteWithdrawMethodInfo(methodId ?? ''),
                child: Container(
                  width: Get.width * 0.3,
                  height: Get.height * 0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      color: Theme.of(context).colorScheme.error
                  ),
                  child: Center(child: Text(
                    'yes,delete'.tr,
                    style: textRegular.copyWith(color: Theme.of(context).cardColor),
                  )),
                ),
              )
            ]),
          ],

          if(fromFailed)...[
            Text('sorry_cannot_delete'.tr),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text('delete_failed_note'.tr,textAlign: TextAlign.center),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            InkWell(onTap: ()=> Get.back(),
              child: Container(
                  width: Get.width * 0.3,
                  height: Get.height * 0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      color: Theme.of(context).hintColor.withOpacity(0.25)
                  ),
                  child: Center(child: Text('okay'.tr, style: textRegular,textAlign: TextAlign.center)),
                ),
            )

          ],
          const SizedBox(height: Dimensions.paddingSizeSignUp),
        ]),
      ),
    );
  }
}
