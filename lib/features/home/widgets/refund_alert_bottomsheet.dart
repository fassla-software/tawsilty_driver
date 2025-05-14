import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_alart_dialog_shape.dart';
import 'package:ride_sharing_user_app/features/trip/screens/trip_details_screen.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class RefundAlertBottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final String tripId;
  const RefundAlertBottomSheet({super.key, required this.title, required this.description, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialogShape(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Image.asset(Images.refundAlertBottomsheetIcon,height: 100,width: 100),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Text(title,style: textBold),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Text(description,style: textRegular.copyWith(color: Theme.of(context).colorScheme.secondaryFixedDim,fontSize: Dimensions.fontSizeSmall)),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
            child: ButtonWidget(
              buttonText: 'parcel_details'.tr,
              onPressed: (){
                Get.back();
                Get.to(()=> TripDetails(tripId: tripId));
              },
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

        ]),
      ),
    );
  }
}
