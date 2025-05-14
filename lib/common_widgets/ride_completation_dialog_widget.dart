import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class RideCompletationDialogWidget extends StatelessWidget {
  const RideCompletationDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(surfaceTintColor: Theme.of(context).cardColor,
      child: SizedBox(width: 500,
        child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Align(alignment: Alignment.topRight,
                child: InkWell(onTap: ()=> Get.back(),
                    child: Icon(Icons.highlight_remove_rounded,color: Theme.of(context).hintColor,))),

            const SizedBox(height: Dimensions.paddingSizeSmall,),
            Image.asset(Get.find<RiderMapController>().isInside ? Images.completationDialogIcon : Images.completationDialogIcon2,height: 60,width: 60,),

            const SizedBox(height: Dimensions.paddingSizeSmall,),
            Text(Get.find<RiderMapController>().isInside ? 'seems_you_reached_near_your'.tr : 'seems_you_are_not_reached_near_your'.tr),
            Text('destination'.tr),

            const SizedBox(height: Dimensions.paddingSizeSmall,),
            Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly, children: [
              InkWell(onTap: () => Get.back(),
                child: Container(decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    border: Border.all(color: Theme.of(context).primaryColor)),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  width: Get.width * 0.3,
                  child: Center(child: Text('continue'.tr,style: textRegular.copyWith(color: Theme.of(context).primaryColor),)),),
              ),

              InkWell(onTap: (){
                  Get.back();
                  Get.find<RideController>().remainingDistance(Get.find<RideController>().tripDetail!.id!, mapBound: true);
                  Get.find<RiderMapController>().setRideCurrentState(RideState.end);
              },
                child: Container(decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    border: Border.all(color: Theme.of(context).primaryColor)),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  width: Get.width * 0.3,
                  child: Center(child: Text('complete'.tr,style: textRegular.copyWith(color: Theme.of(context).cardColor),)),),
              )
            ],),

            const SizedBox(height: Dimensions.paddingSizeDefault,)
          ],),
        ),
      ),
    );
  }
}


