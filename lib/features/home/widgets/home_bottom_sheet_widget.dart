import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/home/screens/vehicle_add_screen.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class HomeBottomSheetWidget extends StatelessWidget {
  const HomeBottomSheetWidget({super.key});

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
          horizontal: Dimensions.paddingSizeSmall,
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

            Text('congratulations'.tr, style: textSemiBold.copyWith(
                color: Theme.of(context).primaryColor,fontSize: 22
            )),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text('home_no_vehicle_note'.tr, style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)
              ),
              child: Column(children: [
                Text('in_the_mean_time_you_can'.tr),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text('after_admin_approval_trip'.tr),
              ]),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
              child: ButtonWidget(
                buttonText: 'setup_vehicle_info'.tr,
                onPressed: ()=> Get.to(()=> const VehicleAddScreen()),
              ),
            )

          ]),
        ),
      ),
    );
  }
}
