import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/ride/domain/repositories/ride_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class RideRepository implements RideRepositoryInterface{
  ApiClient apiClient;
  RideRepository({required this.apiClient});


  @override
  Future<Response> bidding(String tripId, String amount) async {
    return await apiClient.postData(AppConstants.bidding,{
      "trip_request_id" : tripId,
      "bid_fare" : amount
    });
  }


  @override
  Future<Response> getRideDetails(String tripId) async {
    return await apiClient.getData('${AppConstants.tripDetails}$tripId');
  }

  @override
  Future<Response> uploadScreenShots(String id, XFile? file) async {
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'trip_request_id': id
    });

    return await apiClient.postMultipartData(AppConstants.uploadScreenShots,
      fields,
      [],
        MultipartBody('file', file),
      []
    );
  }

  @override
  Future<Response> getRideDetailBeforeAccept(String tripId) async {
    return await apiClient.getData('${AppConstants.tripDetails}$tripId?type=overview');
  }

  @override
  Future<Response> tripAcceptOrReject(String tripId, String type) async {
    return await apiClient.postData(AppConstants.tripAcceptOrReject,{
      "trip_request_id": tripId,
      "action" : type
    });
  }

  @override
  Future<Response> ignoreMessage(String tripId) async {
    return await apiClient.postData(AppConstants.tripAcceptOrReject,{
      "trip_request_id": tripId
    });
  }

  @override
  Future<Response> matchOtp(String tripId, String otp) async {
    return await apiClient.postData(AppConstants.matchOtp,{
      "trip_request_id": tripId,
      "otp" : otp
    });
  }

  @override
  Future<Response> remainDistance(String id) async {
    return await apiClient.postData(AppConstants.remainDistance,
    {
      "trip_request_id": id,
    });
  }

  @override
  Future<Response> tripStatusUpdate(String status, String id,String cancellationCause,String dateTime) async {
    return await apiClient.postData(AppConstants.tripStatusUpdate,
        {
          "status": status,
          "cancel_reason": cancellationCause,
          "trip_request_id" : id,
          "_method" : 'put',
          "return_time" : dateTime
        });
  }

  @override
  Future<Response> getPendingRideRequestList(int offset, {int limit = 10}) async {
    return await apiClient.getData('${AppConstants.rideRequestList}?limit=$limit&offset=$offset');
  }

  @override
  Future<Response> ongoingTripRequest() async {
    return await apiClient.postData(AppConstants.ongoingTrip, {
      'status' : 'last_trip',
      'trip_type' : 'ride_request'
    });
  }

  @override
  Future<Response> getFinalFare(String tripId) async {
    return await apiClient.getData('${AppConstants.finalFare}?trip_request_id=$tripId');
  }

  @override
  Future<Response> currentRideStatus() async {
    return await apiClient.getData(AppConstants.currentRideStatus);
  }

  @override
  Future<Response> arrivalPickupPoint(String tripId) async {
    return await apiClient.postData(AppConstants.arrivalPickupPoint,
        {
          "trip_request_id" : tripId,
          "_method" : "put"
        });
  }

  @override
  Future<Response> arrivalDestination(String tripId, String destination) async {
    return await apiClient.postData(AppConstants.arrivedDestination,
        {
          "trip_request_id" : tripId,
          "is_reached": destination,
          "_method" : "put"
        });
  }

  @override
  Future<Response> waitingForCustomer (String tripId, String status) async {
    return await apiClient.postData(AppConstants.waitingUri,
        {
          "waiting_status": status,
          "trip_request_id" : tripId,
          "_method" : "put"
        });
  }

  @override
  Future<Response> getOnGoingParcelList(int offset) async {
    return await apiClient.getData(AppConstants.parcelOngoingList);
  }

  @override
  Future<Response> getUnpaidParcelList(int offset) async {
    return await apiClient.getData(AppConstants.parcelUnpaidList);
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

}