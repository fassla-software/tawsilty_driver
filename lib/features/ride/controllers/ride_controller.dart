import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/location/screens/access_location_screen.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/otp_time_count_Controller.dart';
import 'package:ride_sharing_user_app/features/map/screens/map_screen.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/final_fare_model.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/on_going_trip_model.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/parcel_list_model.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/pending_ride_request_model.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/remaining_distance_model.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/ride/domain/services/ride_service_interface.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/features/trip/screens/payment_received_screen.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/pusher_helper.dart';
import 'package:ride_sharing_user_app/helper/route_helper.dart';
import 'package:video_thumbnail/video_thumbnail.dart';



class RideController extends GetxController implements GetxService{
  final RideServiceInterface rideServiceInterface;
  RideController({required this.rideServiceInterface});

  int _orderStatusSelectedIndex = 0;
  int get orderStatusSelectedIndex => _orderStatusSelectedIndex;
  bool isLoading = false;
  bool isPinVerificationLoading = false;
  String? _rideid;
  String? get rideId => _rideid;
  List<String>? _thumbnailPaths;
  List<String>? get thumbnailPaths => _thumbnailPaths;


  void setRideId(String id){
    _rideid = id;
  }


  void setOrderStatusTypeIndex(int index){
    _orderStatusSelectedIndex = index;
    update();
  }



  Future<Response> bidding(String tripId, String amount) async {
    isLoading = true;
    update();
    Response response = await rideServiceInterface.bidding(tripId, amount);
    if (response.statusCode == 200) {
      Get.back();
      isLoading = false;
     showCustomSnackBar('bid_submitted_successfully'.tr, isError: false);
     getPendingRideRequestList(1);
     getRideDetailBeforeAccept(tripId);
    } else {
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


  bool notSplashRoute= false;
  void updateRoute(bool showHideIcon, {bool notify = false}){
    notSplashRoute = showHideIcon;
    if(notify){
      update();
    }

  }


  String currentRideStatus = 'fresh';
  bool getResult = false;
  Future<Response> getCurrentRideStatus({bool fromRefresh = false, froDetails = false, isUpdate = true, fromMapScreen = false}) async {
    isLoading = true;
    if(froDetails){
      getResult = true;

      if(isUpdate) {
        update();
      }
    }
    Response response = await rideServiceInterface.currentRideStatus();
    if (response.statusCode == 200 ) {
      getResult = false;
      isLoading = false;
      if(response.body['data'] != null){
        tripDetail = TripDetailsModel.fromJson(response.body).data!;
        currentRideStatus = tripDetail!.currentStatus!;
        polyline = tripDetail!.encodedPolyline!;
        if(Get.find<AuthController>().getZoneId() != '') {
          if (Get.find<RideController>().currentRideStatus == 'fresh') {
            Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
            Get.offNamed(RouteHelper.getHomeRoute());
          } else if (Get.find<RideController>().currentRideStatus == 'accepted') {
            Get.find<RiderMapController>().setRideCurrentState(RideState.accepted);
            Get.find<RideController>().remainingDistance(tripDetail!.id!,mapBound: true);
            Get.find<RideController>().updateRoute(false, notify: true);
            if(!fromMapScreen){
              Get.to(() => const MapScreen(fromScreen: 'splash'));
            }
          }
          else if (Get.find<RideController>().currentRideStatus == 'ongoing') {
            Get.find<RiderMapController>().setRideCurrentState(RideState.ongoing);
            Get.find<RideController>().remainingDistance(tripDetail!.id!,mapBound: true);
            Get.find<RideController>().updateRoute(false, notify: true);
            if(!fromMapScreen){
              Get.to(() => const MapScreen(fromScreen: 'splash'));
            }
          }else if (Get.find<RideController>().currentRideStatus == 'completed' || Get.find<RideController>().currentRideStatus == 'cancelled') {
            Get.find<RideController>().getFinalFare(Get.find<RideController>().tripDetail!.id!);
            Get.offAll(() =>  const PaymentReceivedScreen());
          }

        }else{
          Get.to(()=> const AccessLocationScreen());
        }
      }
    }else if(response.statusCode == 403){
      isLoading = false;
      getResult = false;
      if(Get.find<AuthController>().getZoneId() != '') {
        if(!fromRefresh){
          Get.offNamed(RouteHelper.getHomeRoute());
        }
      }else{
        Get.to(()=> const AccessLocationScreen());
      }

    }else{
      print("ddddddddddddddd${response.statusCode}");
      // getResult = false;
      // isLoading = false;
      // Get.offNamed(RouteHelper.getHomeRoute());
      Get.to(()=> const AccessLocationScreen());
    }
    update();
    return response;
  }


  TripDetail? tripDetail;

  Future<Response> getRideDetails(String tripId, {bool fromHomeScreen = false}) async {
    isLoading = true;
    _thumbnailPaths = null;
    if (kDebugMode) {
      print('details api call-====> $tripId');
    }
    Response response = await rideServiceInterface.getRideDetails(tripId);
    if (response.statusCode == 200) {
      tripDetail = TripDetailsModel.fromJson(response.body).data!;
      polyline = tripDetail!.encodedPolyline!;
      isLoading = false;

      List<Attachments> attachments = tripDetail?.parcelRefund?.attachments ?? [];
      _thumbnailPaths = List.filled(attachments.length, '');

      Future.forEach(attachments, (element) async{
        if(element.file?.contains('.mp4') ?? false){
          String? path = await generateThumbnail(element.file!);
          _thumbnailPaths?[tripDetail!.parcelRefund!.attachments!.indexOf(element)] =  path ?? '';

          update();
        }
      });

    }else{
      isLoading = false;
      fromHomeScreen ? null : ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> uploadScreenShots(String tripId, XFile file) async {
    Response response = await rideServiceInterface.uploadScreenShots(tripId, file);
    if (response.statusCode == 200) {
    }
    update();
    return response;
  }


  String polyline = '';

  Future<Response> getRideDetailBeforeAccept(String tripId) async {
    isLoading = true;
    update();
    Response response = await rideServiceInterface.getRideDetailBeforeAccept(tripId);
    if (response.statusCode == 200) {
      tripDetail = TripDetailsModel.fromJson(response.body).data!;
      isLoading = false;
      polyline = tripDetail!.encodedPolyline!;
      Get.find<RideController>().remainingDistance(tripId,mapBound: true);
      Get.find<RiderMapController>().getPickupToDestinationPolyline();
      if (kDebugMode) {
        print('polyline is ====> $polyline');
      }
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }

    update();
    return response;
  }


  List<TripDetail>? ongoingTrip;
  List<TripDetail>? get ongoingTripDetails => ongoingTrip;

  void clearLastRideDetails(){
    ongoingTrip = [];
    update();
  }



  Future<Response> getLastTrip() async {
    Response response = await rideServiceInterface.ongoingTripRequest();
    if (response.statusCode == 200) {
      ongoingTrip = [];
      if(response.body['data'] != null){
        ongoingTrip!.addAll(OngoingTripModel.fromJson(response.body).data!);
      }

    }else{
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


  bool accepting = false;
  String? onPressedTripId ;
  Future<Response> tripAcceptOrRejected(String tripId, String type, {bool fromList = true, int index = 0}) async {
    onPressedTripId = tripId;

      accepting = true;
      update();
    Response response = await rideServiceInterface.tripAcceptOrReject(tripId, type);
    if (response.statusCode == 200) {

      accepting = false;
      Get.find<RiderMapController>().getPickupToDestinationPolyline();
      if(type == 'rejected'){
        await rideServiceInterface.ignoreMessage(tripId);
        showCustomSnackBar('trip_is_rejected'.tr, isError: false);
      }else{
        showCustomSnackBar('trip_is_accepted'.tr, isError: false);
        Get.find<OtpTimeCountController>().initialCounter();
        await remainingDistance(tripId,mapBound: true);
        getPendingRideRequestList(1);
      }

    }else{

      accepting = false;
      ApiChecker.checkApi(response);
    }
    accepting = false;
    onPressedTripId = null;
    update();
    return response;
  }


  String _verificationCode = '';
  String _otp = '';
  String get otp => _otp;
  String get verificationCode => _verificationCode;

  void updateVerificationCode(String query) {
    _verificationCode = query;
    if(_verificationCode.isNotEmpty){
      _otp = _verificationCode;
    }
    update();
  }

  void clearVerificationCode() {
    _verificationCode = '';
    update();
  }


  Uint8List? imageFile;

  Future<Response> matchOtp(String tripId, String otp) async {
    isPinVerificationLoading = true;
    update();
    if (kDebugMode) {
      print('otp and id ===> $tripId/$otp');
    }
    Response response = await rideServiceInterface.matchOtp(tripId, otp);
    if (response.statusCode == 200) {

      clearVerificationCode();
      if(tripDetail!.type! == 'parcel' &&  tripDetail?.parcelInformation?.payer == 'sender'){
        Get.find<RiderMapController>().setRideCurrentState(RideState.ongoing);
        getFinalFare(tripId).then((value) {
          if(value.statusCode == 200){
            Get.to(()=> const PaymentReceivedScreen(fromParcel: true,));
          }
        });
      }else{
        remainingDistance(tripDetail!.id!,mapBound: true);
        getRideDetails(tripDetail!.id!);
        Get.find<RiderMapController>().setRideCurrentState(RideState.ongoing);
      }
      showCustomSnackBar('otp_verified_successfully'.tr, isError: false);
      isPinVerificationLoading = false;
      Future.delayed(const Duration(seconds: 12)).then((value) async{
      imageFile = await Get.find<RiderMapController>().mapController!.takeSnapshot();
          if(imageFile!= null)
      {
        uploadScreenShots(tripDetail!.id!, XFile.fromData(imageFile!));
      }
      });
      PusherHelper().tripCancelAfterOngoing(tripDetail!.id!);
      PusherHelper().tripPaymentSuccessful(tripDetail!.id!);
    }else{
      isPinVerificationLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }



  String myDriveMode = '';
  RemainingDistanceModel? matchedMode;
  List<RemainingDistanceModel>? remainingDistanceItem = [];
  Future<Response> remainingDistance(String tripId,{bool mapBound = false}) async {
    myDriveMode = Get.find<ProfileController>().profileInfo!.vehicle!.category!.type!;
    isLoading = true;
    Response response = await rideServiceInterface.remainDistance(tripId);
     List<String> status = ['accepted','ongoing'];
    if (response.statusCode == 200) {
      isLoading = false;
      if(status.contains(Get.find<RiderMapController>().currentRideState.name)){
        Get.find<RiderMapController>().getDriverToPickupOrDestinationPolyline(response.body[0]['encoded_polyline'],mapBound: mapBound);
      }

      remainingDistanceItem = [];
      response.body.forEach((distance) {
        remainingDistanceItem!.add(RemainingDistanceModel.fromJson(distance));

      });
      if(remainingDistanceItem != null && remainingDistanceItem!.isNotEmpty){
        matchedMode =  remainingDistanceItem![0];
      }

      if(matchedMode != null && (matchedMode!.distance! * 1000) <= 100 && tripDetail != null && tripDetail!.currentStatus == 'pending' ){
        arrivalPickupPoint(tripId);
      }

      if(tripDetail != null && tripDetail!.currentStatus == 'ongoing' && !tripDetail!.isPaused! && matchedMode != null &&  Get.find<RiderMapController>().isInside && matchedMode!.isPicked!){
        arrivalDestination(tripId, "destination");
        getRideDetails(tripId);
        AudioPlayer audio = AudioPlayer();
        audio.play(AssetSource('notification.wav'));

      }

    }else{
      isLoading = false;
    }
    update();
    return response;
  }

  bool isStatusUpdating = false;

  Future<Response> tripStatusUpdate(String status,String id, String message, String cancellationCause,{String? dateTime}) async {
    isLoading = true;
    isStatusUpdating = true;
    update();
    Response response = await rideServiceInterface.tripStatusUpdate(status, id,cancellationCause,dateTime ?? '');

    if (response.statusCode == 200) {
      Get.find<TripController>().othersCancellationController.clear();
      showCustomSnackBar(message.tr, isError: false);
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    isStatusUpdating = false;
    update();
    return response;
  }


  PendingRideRequestModel? pendingRideRequestModel;
  PendingRideRequestModel? get getPendingRideRequestModel => pendingRideRequestModel;

  Future<Response> getPendingRideRequestList(int offset, {int limit =10, bool isUpdate = false}) async {
    isLoading = true;
    if(isUpdate){
      update();
    }
    Response response = await rideServiceInterface.getPendingRideRequestList(offset, limit: limit);
    if (response.statusCode == 200) {
      pendingRideRequestModel?.data = [];
      pendingRideRequestModel?.totalSize = 0;
      pendingRideRequestModel?.offset = '1';
      if(response.body['data'] != null && response.body['data'] != ''){
        if(offset == 1 ){
          pendingRideRequestModel = PendingRideRequestModel.fromJson(response.body);
        }else{
          pendingRideRequestModel!.totalSize =  PendingRideRequestModel.fromJson(response.body).totalSize;
          pendingRideRequestModel!.offset =  PendingRideRequestModel.fromJson(response.body).offset;
          pendingRideRequestModel!.data!.addAll(PendingRideRequestModel.fromJson(response.body).data!);
        }
      }

      isLoading = false;
    }
    else{
      pendingRideRequestModel?.data = [];
      pendingRideRequestModel?.totalSize = 0;
      pendingRideRequestModel?.offset = '1';
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


  FinalFare? finalFare;
  Future<Response> getFinalFare(String tripId) async {
    isLoading = true;
    update();
    Response response = await rideServiceInterface.getFinalFare(tripId);
    if (response.statusCode == 200 ) {
      Get.find<RiderMapController>().initializeData();
      if(response.body['data'] != null){
        finalFare = FinalFareModel.fromJson(response.body).data!;

      }
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  DateFormat get dateFormat => _dateFormat;

  void selectDate(String type, BuildContext context){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),

      lastDate: DateTime(2030),
    ).then((date) {
      if (type == 'start'){
        _startDate = date!;
      }else{
        _endDate = date!;
      }

      update();
    });
  }



  Future<Response> arrivalPickupPoint(String tripId) async {
    isLoading = true;
    if (kDebugMode) {
      print('details api call-====> $tripId');
    }
    Response response = await rideServiceInterface.arrivalPickupPoint(tripId);
    if (response.statusCode == 200) {
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> arrivalDestination(String tripId, String type) async {
    Response response = await rideServiceInterface.arrivalDestination(tripId, type);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("===Arrived destination aria===");
      }
    }else{

      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> waitingForCustomer (String tripId, String waitingStatus) async {
    isLoading = true;
    Response response = await rideServiceInterface.waitingForCustomer(tripId, waitingStatus);
    if (response.statusCode == 200) {
      getRideDetails(tripId);
      isLoading = false;
      showCustomSnackBar('trip_status_updated_successfully'.tr, isError: false);
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<void> focusOnBottomSheet(GlobalKey<ExpandableBottomSheetState> key) async {
    if(key.currentState?.expansionStatus == ExpansionStatus.expanded) {
      // ignore: invalid_use_of_protected_member
      key.currentState?.reassemble();
      await Future.delayed(const Duration(milliseconds: 500));
    }
    key.currentState?.expand();
  }

  ParcelListModel? parcelListModel;
  Future<Response> getOngoingParcelList() async {
    isLoading = true;
    Response? response = await rideServiceInterface.getOnGoingParcelList(1);
    if(response!.statusCode == 200 ){
      isLoading = false;
      if(response.body['data'] != null){
        parcelListModel = ParcelListModel.fromJson(response.body);
      }
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response;
  }

  ParcelListModel? unpaidParcelListModel;
  Future<Response> getUnpaidParcelList() async {
    isLoading = true;
    Response? response = await rideServiceInterface.getUnpaidParcelList(1);
    if(response!.statusCode == 200 ){
      isLoading = false;
      if(response.body['data'] != null){
        unpaidParcelListModel = ParcelListModel.fromJson(response.body);
      }
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response;
  }

  Future<String?> generateThumbnail(String filePath) async {
    final directory = await getTemporaryDirectory();

    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: filePath, // Replace with your video URL
      thumbnailPath: directory.path,
      imageFormat: ImageFormat.PNG,  // You can use JPEG or WEBP too
      maxHeight: 100,                 // Specify the height of the thumbnail
      maxWidth: 200,                 // Specify the Width of the thumbnail
      quality: 1,                    // Quality of the thumbnail
    );

    return thumbnailPath;
  }

  int getOnGoingRideCount() {
    if (ongoingTrip == null || ongoingTrip!.isEmpty) {
      return 0;
    }

    final trip = ongoingTrip![0];

    bool isOngoingOrAccepted() => trip.currentStatus == 'ongoing' || trip.currentStatus == 'accepted';

    bool isUnpaidCompleted() => trip.currentStatus == 'completed' && trip.paymentStatus == 'unpaid';

    bool isUnpaidCancelledByCustomer() => trip.currentStatus == 'cancelled' && trip.paymentStatus == 'unpaid' && trip.cancelledBy == 'customer';

    if (isOngoingOrAccepted() || isUnpaidCompleted() || (isUnpaidCancelledByCustomer() && trip.type != 'parcel')) {
      return 1;
    }

    return 0;
  }



}