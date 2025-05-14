import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/custom_arrow_icon_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/custom_menu_driving_status_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/last_trip_shimmer_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/trip/screens/trip_details_screen.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class OngoingRideCardWidget extends StatelessWidget {
  const OngoingRideCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
    return GetBuilder<RideController>(
        builder: (rideController) {
          String tripDate = '0', suffix = 'st';
          List<dynamic> extraRoute =[];
          int onGoingMin = 0, onGoingHr = 0, count = 1;
        if(rideController.ongoingTrip != null && rideController.ongoingTrip!.isNotEmpty){
           tripDate = DateConverter.dateTimeStringToDateOnly(rideController.ongoingTrip![0].createdAt!);
           if(tripDate == "1"){
             suffix = "st";
           }else if(tripDate == "2"){
             suffix = "nd";
           }else if(tripDate == "3"){
             suffix = "rd";
           }else{
             suffix = "th";
           }

           onGoingHr = DateTime.now().difference(DateTime.parse(rideController.ongoingTrip![0].createdAt!)).inHours;
           onGoingMin = DateTime.now().difference(DateTime.parse(rideController.ongoingTrip![0].createdAt!)).inHours;

           for(int i =0; i< extraRoute.length; i++){
             if(extraRoute[i] != ''){
               count ++;
               if (kDebugMode) {
                 print(count);
               }
             }
           }
        }
          return rideController.ongoingTrip != null? rideController.ongoingTrip!.isNotEmpty?
          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Container(decoration: BoxDecoration(border: Border.all(width: .25, color: Theme.of(context).primaryColor),
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
              child: Column(children: [
                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Row(children: [
                    Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                      child: Column(children: [
                        Text('$tripDate $suffix', style: textBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),),
                         Text(DateConverter.dateTimeStringToMonthAndYear(rideController.ongoingTrip![0].createdAt!), style: textRegular),
                      ],),
                    ),
                    const Spacer(),

                    Text(capitalize(rideController.ongoingTrip![0].currentStatus!.tr), style: textRegular.copyWith()),
                  ],),
                ),

                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

                    CustomArrowIconWidget(onTap: (){
                        if(rideController.orderStatusSelectedIndex != 0){
                          rideController.setOrderStatusTypeIndex(rideController.orderStatusSelectedIndex-1);
                        }
                      },
                      color: rideController.orderStatusSelectedIndex == 0 ?
                      Theme.of(context).hintColor.withOpacity(.35):
                      Theme.of(context).primaryColor.withOpacity(.25),
                        icon: CupertinoIcons.left_chevron,
                      iconColor: rideController.orderStatusSelectedIndex == 0 ?
                      Theme.of(context).hintColor.withOpacity(.7):Theme.of(context).primaryColor),
                    InkWell(onTap: (){
                        if(rideController.ongoingTrip![0].currentStatus == 'ongoing' || rideController.ongoingTrip![0].currentStatus == 'accepted' || (rideController.ongoingTrip![0].currentStatus =='completed' && rideController.ongoingTrip![0].paymentStatus == 'unpaid')  ){
                          Get.find<RideController>().getCurrentRideStatus(froDetails: true);
                        }else{
                          Get.to(()=> TripDetails(tripId: rideController.ongoingTrip![0].id!));
                        }
                      },
                      child: CircularPercentIndicator(
                        radius: 80.0,
                        lineWidth: 10.0,
                        percent: rideController.orderStatusSelectedIndex == 0
                            ? 0.70 : rideController.orderStatusSelectedIndex == 1
                            ?0.90:  0.70,
                        circularStrokeCap: CircularStrokeCap.round,
                        center:  Column(mainAxisSize: MainAxisSize.min, children: [
                            Text("estimated".tr,style: textRegular.copyWith(color: Theme.of(context).hintColor)),
                            Padding(padding: const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeExtraSmall),
                              child: Text(rideController.orderStatusSelectedIndex == 0
                                  ? "${rideController.ongoingTrip![0].estimatedTime} min":
                              rideController.orderStatusSelectedIndex == 1
                                  ? '${rideController.ongoingTrip![0].estimatedDistance!.toStringAsFixed(2)} km':
                              PriceConverter.convertPrice(context, double.parse(rideController.ongoingTrip![0].estimatedFare.toString())),
                                style: textRobotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge),),
                            ),
                            Text(rideController.orderStatusSelectedIndex == 0
                                ?"driving".tr:
                            rideController.orderStatusSelectedIndex == 1?
                            "derived".tr: "for_this_trip".tr,
                              style: textRegular.copyWith(color:Get.isDarkMode? Theme.of(context).hintColor : Theme.of(context).primaryColor),),
                          ],
                        ),
                        progressColor: Theme.of(context).primaryColor,
                        backgroundColor: Theme.of(context).hintColor.withOpacity(.18))),



                    CustomArrowIconWidget(onTap: (){
                      if(rideController.orderStatusSelectedIndex != 2){
                        rideController.setOrderStatusTypeIndex(rideController.orderStatusSelectedIndex+1);
                      }},
                      color : rideController.orderStatusSelectedIndex != 2 ?
                      Theme.of(context).primaryColor.withOpacity(.25):
                      Theme.of(context).hintColor.withOpacity(.35),
                      icon: CupertinoIcons.right_chevron,
                      iconColor: rideController.orderStatusSelectedIndex != 2 ?
                      Theme.of(context).primaryColor:Theme.of(context).hintColor.withOpacity(.7))])),


                Padding(padding: const EdgeInsets.only(top:Dimensions.paddingSizeSmall),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                    Text(rideController.orderStatusSelectedIndex == 0
                        ? '${'ongoing_trip_time'.tr}:':'${'ongoing_trip_distance'.tr}:',
                        style: textRegular.copyWith(color: Get.isDarkMode? Theme.of(context).hintColor : Theme.of(context).primaryColor.withOpacity(.5))),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Text(rideController.orderStatusSelectedIndex == 0?
                          '${onGoingHr.toString()}:$onGoingMin': rideController.ongoingTrip![0].estimatedDistance!.toStringAsFixed(2),
                          style: textBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge)),),
                    Text(rideController.orderStatusSelectedIndex == 0?'Hour'.tr:'km'.tr,
                        style: textRegular.copyWith(color:Get.isDarkMode? Theme.of(context).hintColor : Theme.of(context).primaryColor.withOpacity(.5))),
                  ],),
                ),

                const SizedBox(height: Dimensions.paddingSizeDefault),
                SizedBox(height: Dimensions.orderStatusIconHeight,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                    CustomMenuDrivingStatusWidget( index: 0, selectedIndex: rideController.orderStatusSelectedIndex,icon: Images.drivingIcon),
                    CustomMenuDrivingStatusWidget( index: 1, selectedIndex: rideController.orderStatusSelectedIndex,icon: Images.drivedIcon),
                    CustomMenuDrivingStatusWidget( index: 2, selectedIndex: rideController.orderStatusSelectedIndex,icon: Images.paymentIcon),

                  ],),
                )
              ],),),
          ): const NoDataWidget(title: 'no_trip_found', fromHome: true): const Padding(padding: EdgeInsets.only(top: 60.0),
            child: LastTripShimmerWidget());
        }
    );
  }
}
