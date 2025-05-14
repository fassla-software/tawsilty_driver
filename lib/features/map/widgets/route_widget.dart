

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/divider_widget.dart';

class RouteWidget extends StatelessWidget {
  final String pickupAddress;
  final String destinationAddress;
  final String? extraOne;
  final String? extraTwo;
  final String? entrance;
  final bool fromCard;
  const RouteWidget({super.key,
    required this.pickupAddress,
    required this.destinationAddress,
    this.extraOne, this.extraTwo,
    this.entrance,
    this.fromCard = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (riderController) {
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
          child: Column(children:  [
            SizedBox(width: Dimensions.iconSizeMedium,child: Image.asset(Images.currentLocation)),

            if((extraOne != null && extraOne!.isNotEmpty) || (extraTwo != null && extraTwo!.isNotEmpty))
              SizedBox(height: 65 ,width: 10,child: DividerWidget(
                height: 2,dashWidth: 1,axis: Axis.vertical,
                color: Theme.of(context).textTheme.bodyMedium!.color!,
              )),

            if((extraOne != null && extraOne!.isNotEmpty) || (extraTwo != null && extraTwo!.isNotEmpty))
              SizedBox(width: Dimensions.iconSizeMedium,child: Image.asset(Images.customerRouteIcon)),

            SizedBox(height: 65 ,width: 10,child: DividerWidget(
              height: 2,dashWidth: 1,axis: Axis.vertical,
              color: Theme.of(context).textTheme.bodyMedium!.color!,
            )),

            SizedBox(width: Dimensions.iconSizeMedium,child: Image.asset(Images.customerDestinationIcon)),
          ]),
        ),

        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 40, child: Text(
            pickupAddress,
            style: textRegular.copyWith(),maxLines: 2,overflow: TextOverflow.ellipsis,
          )),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          if(extraOne != null && extraOne!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
              child: Text(extraOne!, style: textRegular.copyWith(
                color: Theme.of(Get.context!).primaryColor.withOpacity(.75),
                fontSize: Dimensions.fontSizeSmall,
              ),overflow: TextOverflow.ellipsis),
            ),

          if((extraOne != null && extraOne!.isNotEmpty) || (extraTwo != null && extraTwo!.isNotEmpty))
            const Padding(
              padding: EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
              child: SizedBox(
                height:20 ,width: 10,
                child: DividerWidget(height: 2,dashWidth: 1,axis: Axis.vertical),
              ),
            ),

          if(extraTwo != null && extraOne!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
              child: Text(extraTwo!, style: textRegular.copyWith(
                color: Theme.of(Get.context!).primaryColor.withOpacity(.75),
                fontSize: Dimensions.fontSizeSmall,
              ),overflow: TextOverflow.ellipsis),
            ),

          if(extraOne != null || extraTwo != null)
            const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: EdgeInsets.only(
              top: fromCard? Dimensions.paddingSizeSmall:Dimensions.paddingSizeLarge,
            ),
            child: Text(destinationAddress,  style: textRegular.copyWith()),
          ),

          if(entrance != null && entrance!.isNotEmpty)
            Divider(color: Theme.of(context).hintColor),

          if(entrance != null && entrance!.isNotEmpty)
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              SizedBox(height: 25, child: Image.asset(Images.curvedArrow)),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Container(
                transform: Matrix4.translationValues(0, 10, 0),
                child: Text(entrance!, style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
              ),
            ]),
        ])),
      ]);
    });
  }
}
