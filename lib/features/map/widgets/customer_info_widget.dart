import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';

class CustomerInfoWidget extends StatelessWidget {
  final Customer? customer;
  final bool fromTripDetails;
  final String? fare;
  final String? customerRating;
  const CustomerInfoWidget({super.key,  this.fromTripDetails = false, required this.customer, this.fare, this.customerRating});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(
      builder: (riderController) {
        return Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeSmall),
          child: Row(children: [

            Stack(children: [
                Container(transform: Matrix4.translationValues(Get.find<LocalizationController>().isLtr ? -3 : 3, -3, 0),
                    child: CircularPercentIndicator(radius: 28, percent: .75,lineWidth: 1,
                      backgroundColor: Colors.transparent, progressColor: Theme.of(Get.context!).primaryColor,)),


                ClipRRect(borderRadius : BorderRadius.circular(100),
                    child: ImageWidget(width: 50,height: 50, image: customer?.profileImage != null?
                        '${Get.find<SplashController>().config!.imageBaseUrl!.profileImageCustomer}/${customer?.profileImage??''}':''))]),


            const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
            if(customer != null)
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if(customer!.firstName != null && customer!.lastName != null)
                Text('${customer!.firstName!} ${customer!.lastName!}'),

              if(customerRating != null && customerRating!.isNotEmpty)
                Row(children: [
                  Icon(Icons.star_rate_rounded, color: Theme.of(Get.context!).primaryColor,size: Dimensions.iconSizeMedium,),
                  Text(double.parse(customerRating!).toStringAsFixed(1), style: textRegular.copyWith())])],)),


            fromTripDetails? const SizedBox():
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('estimated_fare'.tr, style: textMedium.copyWith(color: Theme.of(Get.context!).primaryColor),),
                Text(PriceConverter.convertPrice(Get.context!, fare != null? double.parse(fare!):0),
                    style: textRobotoMedium.copyWith(color: Theme.of(Get.context!).primaryColor))])]));
      }
    );
  }
}
