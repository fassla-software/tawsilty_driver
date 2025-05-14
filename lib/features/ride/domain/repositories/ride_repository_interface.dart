

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/interface/repository_interface.dart';

abstract class RideRepositoryInterface implements RepositoryInterface{

  Future<Response> bidding(String tripId, String amount);
  Future<Response> getRideDetails(String tripId);
  Future<Response> uploadScreenShots(String id, XFile? file);
  Future<Response> getRideDetailBeforeAccept(String tripId);
  Future<Response> tripAcceptOrReject(String tripId, String type);
  Future<Response> ignoreMessage(String tripId);
  Future<Response> matchOtp(String tripId, String otp);
  Future<Response> remainDistance(String id);
  Future<dynamic> tripStatusUpdate(String id, String status,String cancellationCause,String dateTime);
  Future<Response> getPendingRideRequestList(int offset, {int limit = 10});
  Future<Response> ongoingTripRequest();
  Future<Response> getFinalFare(String tripId);
  Future<Response> currentRideStatus();
  Future<Response> arrivalPickupPoint(String tripId);
  Future<Response> arrivalDestination(String tripId, String destination);
  Future<Response> waitingForCustomer (String tripId, String status);
  Future<Response> getOnGoingParcelList(int offset);
  Future<Response> getUnpaidParcelList(int offset);
}