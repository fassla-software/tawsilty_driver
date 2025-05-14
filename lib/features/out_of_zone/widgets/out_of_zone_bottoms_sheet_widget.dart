import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/controllers/out_of_zone_controller.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/screens/out_of_zone_map_screen.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class OutOfZoneBottomSheetWidget extends StatelessWidget {
  const OutOfZoneBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.5),
        width: double.infinity,
        decoration: BoxDecoration(color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft:  Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeLarge,
          vertical: Dimensions.paddingSizeDefault,
        ),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.keyboard_arrow_down),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Image.asset(Images.refundAlertBottomsheetIcon,height: 100,width: 100),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text('you_are_out_of_zone'.tr,style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text('you_are_now_out_of_our_service'.tr, style: textRegular.copyWith(
              color: Theme.of(context).colorScheme.secondaryFixedDim,
              fontSize: Dimensions.fontSizeSmall,

            ),textAlign: TextAlign.center),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
              child: ButtonWidget(
                buttonText: 'view_map'.tr,
                onPressed: ()=> Get.to(()=> const OutOfZoneMapScreen()),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            InkWell(
                onTap: (){
                  Get.find<OutOfZoneController>().updateShowDialog(false);
                  Get.back();
                },
                child: Text('okay'.tr,style: textBold.copyWith(color: Theme.of(context).primaryColor))
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge)

          ]),
        ),
      ),
    );
  }
}
