import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/common_widgets/loader_widget.dart';
import 'package:ride_sharing_user_app/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/widgets/calculating_sub_total_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/accepted_rider_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/custom_icon_card_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/customer_ride_request_card_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/end_trip_dialog_widget.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/screens/ride_request_list_screen.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'stay_online_widget.dart';
import 'ride_ongoing_widget.dart';



class RiderBottomSheetWidget extends StatelessWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const RiderBottomSheetWidget({super.key, required this.expandableKey});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiderMapController>(builder: (riderController) {
      return GetBuilder<RideController>(builder: (rideController) {
        return GetBuilder<ProfileController>(builder: (profileController) {
          return Column(children: [
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor,
                borderRadius : const BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.paddingSizeDefault),
                  topRight : Radius.circular(Dimensions.paddingSizeDefault),
                ),
                boxShadow: [BoxShadow(
                    color: Theme.of(context).hintColor,
                    blurRadius: 5, spreadRadius: 1, offset: const Offset(0,2)
                )],
              ),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                  padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                  child : Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(height: 5, width: 30, decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(.25),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    )),

                    if(riderController.currentRideState == RideState.initial)
                      const StayOnlineWidget(),

                    if(riderController.currentRideState == RideState.pending)
                      GetBuilder<RideController>(builder: (rideController) {
                        return  CustomerRideRequestCardWidget(rideRequest: rideController.tripDetail!);
                      }),

                    if(riderController.currentRideState == RideState.accepted)
                      RideAcceptedWidget(expandableKey: expandableKey),

                    if(riderController.currentRideState == RideState.ongoing)
                      RideOngoingWidget(tripId: rideController.tripDetail?.id ?? '',expandableKey: expandableKey),

                    if(riderController.currentRideState == RideState.end)
                      const EndTripWidget(),

                    if(riderController.currentRideState == RideState.completed)
                      const CalculatingSubTotalWidget(),

                    if(riderController.currentRideState == RideState.initial)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          Dimensions.paddingSizeDefault,Dimensions.paddingSizeSmall,
                          Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:  [
                          rideController.isLoading ?
                          const LoaderWidget() :
                          CustomIconCardWidget(title: 'refresh'.tr, index: 0,icon: Images.mIcon3,
                            onTap: () {
                              rideController.getPendingRideRequestList(1,isUpdate: true);
                            },
                          ),

                          CustomIconCardWidget(
                            title: 'leader_board'.tr,
                            index: 1,icon: Images.mIcon2,
                            onTap: () => Get.to(()=> const LeaderboardScreen()),
                          ),

                          CustomIconCardWidget(
                            title: 'trip_request'.tr,
                            index: 2,icon: Images.mIcon1,
                            onTap: () => Get.to(()=> const RideRequestScreen()),
                          ),
                        ]),
                      ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  ])
              ),
            ),
          ]);
        });
      });
    });
  }
}