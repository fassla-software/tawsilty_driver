import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/trip/domain/repositories/trip_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class TripRepository implements TripRepositoryInterface{
  final ApiClient apiClient;
  TripRepository({required this.apiClient});



  @override
  Future<Response> getTripList(String tripType, String from, String to, int offset, String filter,String status) async {
    return await apiClient.getData('${AppConstants.tripList}?type=$tripType&limit=10&offset=$offset&filter=$filter&status=$status');
  }

  @override
  Future<Response> paymentSubmit(String tripId, String paymentMethod ) async {
    return await apiClient.getData('${AppConstants.paymentUri}?trip_request_id=$tripId&payment_method=$paymentMethod');
  }

  @override
  Future<Response> getTripOverView(String filter) async {
    return await apiClient.getData('${AppConstants.tripOverView}?filter=$filter');
  }

  @override
  Future rideCancellationReasonList() async{
    return await apiClient.getData(AppConstants.rideCancellationReasonList);
  }
  @override
  Future parcelCancellationReasonList() async{
    return await apiClient.getData(AppConstants.parcelCancellationReasonList);
  }

  @override
  Future resendReturnedOtp(String tripId) async{
    return await apiClient.postData(
        AppConstants.parcelResendOtp,
      {
        "trip_request_id" : tripId,
        "_method" : 'put'
      }
    );
  }

  @override
  Future parcelReturnSubmitOtp(String tripId,String otp) async{
    return await apiClient.postData(
        AppConstants.parcelCancellationOtp,
      {
        "trip_request_id" : tripId,
        "otp" : otp,
        "_method" : 'put'
      }
    );
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