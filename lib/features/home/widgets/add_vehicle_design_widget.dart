import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/home/screens/vehicle_add_screen.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class AddYourVehicleWidget extends StatelessWidget {
  const AddYourVehicleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault,left: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          border: Border.all(width: .5,color: Theme.of(context).primaryColor)
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          child: Text(
            'vehicle_information'.tr,
            style: textMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: Text(
            'add_your_vehicle_info_now_take_your_journey_to_the_next_level'.tr,
            style: textRegular.copyWith(color: Theme.of(context).hintColor),
            textAlign: TextAlign.center,
          ),
        ),

        Image.asset(Images.reward1),

        Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeOver),
          child: ButtonWidget(
            buttonText: 'add_vehicle_information'.tr,
            onPressed: ()=> Get.to(()=> const VehicleAddScreen()),
          ),
        )
      ],),
    );
  }
}
