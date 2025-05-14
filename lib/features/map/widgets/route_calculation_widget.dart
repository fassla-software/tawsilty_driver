import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class RouteCalculationWidget extends StatelessWidget {
  final bool fromEnd;
  const RouteCalculationWidget({super.key,  this.fromEnd = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal : Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeDefault,
      ),
      child: GetBuilder<RiderMapController>(builder: (riderController) {
        return GetBuilder<RideController>(builder: (rideController) {
          int hour = 0, min = 0, sec = 0;
          double remainingPercent = 0;
          if(rideController.matchedMode != null){
            int duration = rideController.matchedMode?.durationSec??0;
            if(duration>= 3600){
              hour = (duration/3600).floor();
            }
            if(duration>= 60){
              min = ((duration % 3600)/60).floor();
            }
            sec = (duration % 60);
            remainingPercent = (rideController.matchedMode != null)?
            (double.parse(rideController.matchedMode!.distance.toString())/1000) / rideController.tripDetail!.estimatedDistance! : 0;
          }

          return Column(children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal : Dimensions.paddingSizeSmall,vertical: Dimensions.paddingSizeExtraSmall,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).colorScheme.onSecondary.withOpacity(.085),
                  ),
                  child: Text(
                    '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}',
                    style: textBold.copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(children: [
                  SizedBox(height: Dimensions.roadArrowHeight, child: Image.asset(Images.roadLineArrow)),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child:  Text(
                        '${rideController.matchedMode?.distanceText}',
                        style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                    ),
                  ]),
                ]),
              ])),

              const SizedBox(width: Dimensions.paddingSizeExtraLarge),
              Stack(children: [
                Positioned(left: 0,right: 0,top: 0,bottom: 0, child: CircularPercentIndicator(
                  radius: 40,
                  progressColor: Theme.of(context).colorScheme.onSecondary.withOpacity(.435),
                  percent: remainingPercent>1? 1:remainingPercent,
                )),

                Column(children: [
                  if(rideController.matchedMode != null)
                    Padding(
                      padding:  const EdgeInsets.only(top: 45),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text(
                          rideController.matchedMode!.distanceText!.replaceAll(" km", ''),
                          style: textSemiBold.copyWith(
                            color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge,
                          ),
                        ),

                        Text('km',style: textRegular.copyWith(color: Theme.of(context).primaryColor)),
                      ],
                      ),
                    ),

                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Padding(
                    padding: EdgeInsets.only(top:(rideController.matchedMode != null) ? 10 : 80),
                    child: Text(
                      'destination'.tr,
                      style: textMedium.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ]),
              ]),
            ]),

            if(rideController.tripDetail!.type == 'ride_request' && !fromEnd)
              Padding(
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge),
                child: ButtonWidget(
                  buttonText: rideController.tripDetail!.isPaused! ?
                  'resume_trip_from_here'.tr : 'pause_trip_for_a_moment'.tr,
                  transparent: true,
                  icon: rideController.tripDetail!.isPaused!? Icons.play_arrow_rounded : Icons.pause,
                  borderWidth: .5,
                  showBorder: true,
                  textColor: rideController.tripDetail!.isPaused!?
                  Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(.75),
                  radius: Dimensions.paddingSizeSmall,
                  borderColor: Theme.of(Get.context!).primaryColor,
                  onPressed: (){
                    rideController.waitingForCustomer(
                      rideController.tripDetail!.id!,
                      rideController.tripDetail!.isPaused!? 'resume':'pause',
                    ).then((value){
                      if(value.statusCode == 200){
                        rideController.getRideDetails(rideController.tripDetail!.id!);
                      }
                    });
                  },
                ),
              )
          ]);
        });
      }),
    );
  }
}
