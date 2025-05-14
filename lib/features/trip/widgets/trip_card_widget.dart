import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/screens/map_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/trip/screens/trip_details_screen.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';

import '../screens/payment_received_screen.dart';

class TripCard extends StatelessWidget {
  final TripDetail tripModel;
  const TripCard({super.key, required this.tripModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(tripModel.currentStatus == 'accepted' || tripModel.currentStatus == 'ongoing'){
          if(tripModel.currentStatus == "accepted"){
            Get.find<RideController>().getRideDetails(tripModel.id!).then((value){
              if(value.statusCode == 200){
                Get.find<RiderMapController>().setRideCurrentState(RideState.accepted);
                Get.find<RiderMapController>().setMarkersInitialPosition();
                Get.find<RideController>().updateRoute(false, notify: true);
                Get.to(() => const MapScreen(fromScreen: 'splash'));
              }
            });
          }else if(tripModel.currentStatus == "completed" && tripModel.paymentStatus == 'unpaid'){
            Get.find<RideController>().getFinalFare(tripModel.id!).then((value){if(value.statusCode == 200){
              Get.to(()=> const PaymentReceivedScreen());
            }});
          } else{
            Get.find<RiderMapController>().setRideCurrentState(RideState.ongoing);
            Get.find<RideController>().getRideDetails(tripModel.id!).then((value){
              if(value.statusCode == 200){
                Get.find<RiderMapController>().setMarkersInitialPosition();
                Get.find<RideController>().updateRoute(false, notify: true);
                Get.to(() => const MapScreen(fromScreen: 'splash'));
              }
            });
          }
        }else{
          Get.to(()=> TripDetails(tripId: tripModel.id!));
        }
      },
      child: Column(children: [
        if(tripModel.currentStatus == 'ongoing' && tripModel.type != 'parcel')
        Padding(padding: const EdgeInsets.all(8.0),
          child:tripModel.screenshot != null ?
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
            child: ImageWidget(
              image: tripModel.screenshot,
              width: Get.width, height: Get.width/1.5,fit: BoxFit.fitWidth,
            ),
          ) :
          Image.asset(Images.mapSample),
        ),

        Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Row(children: [
            Stack(children: [
              Container(
                width: 90, height: Get.height * 0.105,
                decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(.15),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
                ),
                child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(children: [
                    tripModel.type == 'parcel' ?
                    Image.asset(Images.parcel,height: 50) :
                    Image.asset(height: 50,
                      tripModel.vehicleCategory != null ?
                      tripModel.vehicleCategory!.type == "car"?
                      Images.car :
                      Images.bike :
                      Images.car,
                    ),

                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text(
                      tripModel.type != 'parcel' ?
                      tripModel.vehicleCategory != null ?
                      tripModel.vehicleCategory!.name!
                          : '' :
                      'parcel'.tr,
                      style: textMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.4),
                      ),
                    ),
                  ]),
                ),
              ),

              Positioned(
                right: 0,
                child: Container(
                  height: 20,width: 20,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color:  tripModel.currentStatus == 'cancelled' ?
                      Theme.of(context).colorScheme.error.withOpacity(0.15) :
                      tripModel.currentStatus == 'completed' ?
                      Theme.of(context).colorScheme.surfaceTint.withOpacity(0.15) :
                      tripModel.currentStatus == 'returning' ?
                      Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.15) :
                      tripModel.currentStatus == 'returned' ?
                      Theme.of(context).colorScheme.surfaceTint.withOpacity(0.15) :
                      Theme.of(context).colorScheme.primaryContainer.withOpacity(0.15) ,
                      shape: BoxShape.circle
                  ),
                  child: tripModel.currentStatus == 'cancelled' ?
                  Image.asset(Images.crossIcon,color: Theme.of(context).colorScheme.error) :
                  tripModel.currentStatus == 'completed' ?
                  Image.asset(Images.selectedIcon,color: Theme.of(context).colorScheme.surfaceTint) :
                  tripModel.currentStatus == 'returning' ?
                  Image.asset(Images.returnIcon,color: Theme.of(context).colorScheme.surfaceContainer) :
                  tripModel.currentStatus == 'returned' ?
                  Image.asset(Images.returnIcon,color: Theme.of(context).colorScheme.surfaceTint) :
                  Image.asset(Images.ongoingMarkerIcon,color: Theme.of(context).colorScheme.primaryContainer),
                ),
              )
            ]),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
              Text(tripModel.type == 'parcel' ?
              tripModel.parcelInformation?.parcelCategoryName ?? '' :
              tripModel.destinationAddress ?? '',overflow: TextOverflow.ellipsis,style: textRegular),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(DateConverter.isoStringToDateTimeString(tripModel.createdAt!),
                style: textRegular.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(.85),
                  fontSize: Dimensions.fontSizeSmall,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(
                  '${'total'.tr} ${PriceConverter.convertPrice(context, double.parse(tripModel.paidFare!))}',
                style: textRobotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8)),
              ),
            ])),

          ]),
        ),
      ]),
    );
  }
}
