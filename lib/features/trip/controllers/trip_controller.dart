import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/trip/domain/models/trip_cancellation_cause_list_model.dart';
import 'package:ride_sharing_user_app/features/trip/domain/services/trip_service_interface.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/trip/domain/models/trip_model.dart';
import 'package:ride_sharing_user_app/features/trip/domain/models/trip_overview_model.dart';

class TripController extends GetxController implements GetxService{
  final TripServiceInterface tripServiceInterface;

  TripController({required this.tripServiceInterface});

   bool customerReviewed = false;
  List<TripDetail> tripList = [];
  bool isLoading = false;


   void toggleReviewed(){
     customerReviewed = true;
     update();
   }


   List<String> activityTypeList = ['trips', 'over_view'];
   int activityTypeIndex = 0;
   void setActivityTypeIndex(int index){
     activityTypeIndex = index;
     update();
   }


  List<String> selectedFilterType = ['today', 'this_month', 'this_year','all_time'];
  List<String> selectedStatus = ['all', 'ongoing', 'cancelled', 'completed','returned'];
  String selectedStatusName = 'all';
  String _selectedFilterTypeName = 'today';
  String get selectedFilterTypeName => _selectedFilterTypeName;
  void setFilterTypeName(String name){
    tripModel = null;
    _selectedFilterTypeName = name;
    getTripList(1, '', '', 'ride_request', selectedFilterTypeName,selectedStatusName);
    update();
  }

  void setStatusIndex(int index){
    tripModel = null;
    selectedStatusName = selectedStatus[index];
    getTripList(1, '', '', 'ride_request', selectedFilterTypeName,selectedStatusName);
    update();
  }




  TripModel? tripModel;
  Future<Response> getTripList(int offset, String from, String to, String tripType, String filter,String status) async {
    isLoading = true;

    Response response = await tripServiceInterface.getTripList(tripType, from, to, offset, filter,status);
    if (response.statusCode == 200) {
      isLoading = false;
      if(offset == 1){
        tripModel = TripModel.fromJson(response.body);
        update();
      }else{
        tripModel!.data!.addAll(TripModel.fromJson(response.body).data!);
        tripModel!.offset = TripModel.fromJson(response.body).offset;
        tripModel!.totalSize = TripModel.fromJson(response.body).totalSize;
      }


    } else {
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  List<String> selectedOverviewType = ['today', 'this_week', 'last_week'];
  String selectedOverview = 'today';
  String get selectedOverviewIndex => selectedOverview;
  void setOverviewType(String name){
    selectedOverview = name;
    getTripOverView(selectedOverview);
    update();
  }

  List<double> weekList = [];
  List<FlSpot> earningChartList = [];
  double maxValue = 0;

  TripOverView? tripOverView;
  Future<void> getTripOverView(String filter) async {
    Response response = await tripServiceInterface.getTripOverView(filter);
    if (response.statusCode == 200) {
      weekList = [];
      earningChartList = [];
      weekList.clear();
      earningChartList.clear();
      tripOverView = TripOverView.fromJson(response.body);
      bool isToday = selectedOverview == 'today';



      weekList.insert(0, 0);
      weekList.insert(1, double.parse((isToday ? tripOverView?.incomeStat?.sixAm ?? 0 : tripOverView?.incomeStat?.sun ?? 0).toStringAsFixed(2)));
      weekList.insert(2, double.parse((isToday ? tripOverView?.incomeStat?.temAM ?? 0 : tripOverView?.incomeStat?.mon ?? 0).toStringAsFixed(2)));
      weekList.insert(3, double.parse((isToday ? tripOverView?.incomeStat?.twoPm ?? 0 : tripOverView?.incomeStat?.tues ?? 0).toStringAsFixed(2)));
      weekList.insert(4, double.parse((isToday ? tripOverView?.incomeStat?.sixPm ?? 0 : tripOverView?.incomeStat?.wed ?? 0).toStringAsFixed(2)));
      weekList.insert(5, double.parse((isToday ? tripOverView?.incomeStat?.temPm ?? 0 : tripOverView?.incomeStat?.thu ?? 0).toStringAsFixed(2)));
      weekList.insert(6, double.parse((isToday ? tripOverView?.incomeStat?.twoAm ?? 0 : tripOverView?.incomeStat?.fri ?? 0).toStringAsFixed(2)));
      if(!isToday) {
        weekList.insert(7, double.parse((tripOverView?.incomeStat?.sat ?? 0).toStringAsFixed(2)));
      }

      earningChartList = weekList.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value);
      }).toList();
      maxValue = weekList.reduce(max);

    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }




  Future<Response> paymentSubmit(String tripId, String paymentMethod , {fromParcel = false}) async {
    Get.back();
    isLoading = true;
    update();
    Response response = await tripServiceInterface.paymentSubmit(tripId, paymentMethod);
    if (response.statusCode == 200 ) {

      if(fromParcel && Get.find<RideController>().tripDetail?.parcelInformation?.payer == 'sender'){
        Get.back();
        showCustomSnackBar('payment_successful'.tr, isError: false);
        Get.find<RideController>().getRideDetails(tripId).then((value){
          Get.find<RiderMapController>().setMarkersInitialPosition();
          Get.find<RideController>().updateRoute(false, notify: true);
        });

      }else{
        Get.offAll(()=> const DashboardScreen());
      }
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  TripCancellationCauseList? rideCancellationCauseList;
  TripCancellationCauseList? parcelCancellationCauseList;
  TextEditingController othersCancellationController = TextEditingController();

  int rideCancellationCurrentIndex = 0;
  int parcelCancellationCurrentIndex = 0;


  void rideCancellationReasonList() async{
    Response response = await tripServiceInterface.rideCancellationReasonList();

    if(response.statusCode == 200){
      rideCancellationCauseList = TripCancellationCauseList.fromJson(response.body);
    }else{
      ApiChecker.checkApi(response);
    }
  }

  void setCancellationCurrentIndex(int index){
    rideCancellationCurrentIndex = index;
  }

  void setParcelCancellationCurrentIndex(int index){
    parcelCancellationCurrentIndex = index;
  }

  void parcelCancellationReasonList() async{
    Response response = await tripServiceInterface.parcelCancellationReasonList();

    if(response.statusCode == 200){
      parcelCancellationCauseList = TripCancellationCauseList.fromJson(response.body);
      parcelCancellationCauseList?.data?.ongoingRide?.add('other'.tr);
      parcelCancellationCauseList?.data?.acceptedRide?.add('other'.tr);
    }else{
      ApiChecker.checkApi(response);
    }
  }

  String? parcelReturnDate;
  String? parcelReturnTime;
  void setParcelReturnDate(String date){
    parcelReturnDate = date;
  }

  void setParcelReturnTime(String time){
    parcelReturnTime = time;
  }

  void resendReturnedOtp(String tripId)async{
    Response response = await tripServiceInterface.resendReturnedOtp(tripId);

    if(response.statusCode == 200){
      showCustomSnackBar('otp_sent_successfully'.tr,isError: false);
    }else{
      ApiChecker.checkApi(response);
    }
  }

  Future<Response> parcelReturnSubmitOtp(String tripId, String otp)async{
    isLoading = true;
    update();
    Response response = await tripServiceInterface.parcelReturnSubmitOtp(tripId, otp);
    if(response.statusCode == 200){
      Get.find<RideController>().getOngoingParcelList();
      Get.find<RideController>().getRideDetails(tripId);
    }else{
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response;
  }

}