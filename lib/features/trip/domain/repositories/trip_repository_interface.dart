

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/interface/repository_interface.dart';

abstract class TripRepositoryInterface implements RepositoryInterface {

  Future<Response> getTripList(String tripType, String from, String to, int offset, String filter,String status);
  Future<Response> paymentSubmit(String tripId, String paymentMethod );
  Future<Response> getTripOverView(String filter);
  Future<dynamic> rideCancellationReasonList();
  Future<dynamic> parcelCancellationReasonList();
  Future<dynamic> resendReturnedOtp(String tripId);
  Future<dynamic> parcelReturnSubmitOtp(String tripId, String otp);
}