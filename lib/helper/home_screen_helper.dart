import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/maintainance_mode/screens/maintainance_screen.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/pusher_helper.dart';

class HomeScreenHelper {

  void checkMaintanenceMode(){
    int ridingCount = (Get.find<RideController>().ongoingTrip == null || Get.find<RideController>().ongoingTrip!.isEmpty) ? 0 :
    (
        Get.find<RideController>().ongoingTrip![0].currentStatus == 'ongoing' ||
            Get.find<RideController>().ongoingTrip![0].currentStatus == 'accepted' ||
            (
                Get.find<RideController>().ongoingTrip![0].currentStatus =='completed' &&
                    Get.find<RideController>().ongoingTrip![0].paymentStatus == 'unpaid'
            ) ||
            (
                Get.find<RideController>().ongoingTrip![0].currentStatus =='cancelled' &&
                    Get.find<RideController>().ongoingTrip![0].paymentStatus == 'unpaid' &&
                    Get.find<RideController>().ongoingTrip![0].cancelledBy == 'customer'
            ) && Get.find<RideController>().ongoingTrip![0].type != 'parcel'
    ) ? 1 : 0;
    int parcelCount = Get.find<RideController>().parcelListModel?.totalSize?? 0;

    if(ridingCount == 0 && parcelCount == 0){
      Get.find<SplashController>().saveOngoingRides(false);
      if(Get.find<SplashController>().config!.maintenanceMode != null &&
          Get.find<SplashController>().config!.maintenanceMode!.maintenanceStatus == 1 &&
          Get.find<SplashController>().config!.maintenanceMode!.selectedMaintenanceSystem!.driverApp == 1
      ){
        Get.offAll(() => const MaintenanceScreen());
      }
    }else{
      Get.find<SplashController>().saveOngoingRides(true);
    }
  }


  void pendingParcelListPusherImplementation(){
    for(int i =0 ;i<Get.find<RideController>().getPendingRideRequestModel!.data!.length; i++){
      PusherHelper().customerInitialTripCancel(Get.find<RideController>().getPendingRideRequestModel!.data![i].id!,Get.find<ProfileController>().driverId);
      PusherHelper().anotherDriverAcceptedTrip(Get.find<RideController>().getPendingRideRequestModel!.data![i].id!,Get.find<ProfileController>().driverId);
      PusherHelper().customerCouponAppliedOrRemoved(Get.find<RideController>().getPendingRideRequestModel!.data![i].id!);
    }
  }


  void pendingLastRidePusherImplementation(){
    for(int i =0 ;i<Get.find<RideController>().ongoingTripDetails!.length; i++){

      List<String> data = ["ongoing","accepted"];
      if(data.contains(Get.find<RideController>().ongoingTripDetails![i].currentStatus)){
        PusherHelper().tripCancelAfterOngoing(Get.find<RideController>().ongoingTripDetails![i].id!);
        PusherHelper().tripPaymentSuccessful(Get.find<RideController>().ongoingTripDetails![i].id!);
        PusherHelper().customerCouponAppliedOrRemoved(Get.find<RideController>().ongoingTripDetails![i].id!);
      }
      if(Get.find<RideController>().ongoingTripDetails![i].currentStatus == 'completed' &&
          Get.find<RideController>().ongoingTripDetails![i].paymentStatus == 'unpaid'){
        PusherHelper().customerCouponAppliedOrRemoved(Get.find<RideController>().ongoingTripDetails![i].id!);
      }
    }
  }
}