
abstract class TripServiceInterface {
  Future<dynamic> getTripList(String tripType, String from, String to, int offset, String filter,String status);
  Future<dynamic> paymentSubmit(String tripId, String paymentMethod );
  Future<dynamic> getTripOverView(String filter);
  Future<dynamic> rideCancellationReasonList();
  Future<dynamic> parcelCancellationReasonList();
  Future<dynamic> resendReturnedOtp(String tripId);
  Future<dynamic> parcelReturnSubmitOtp(String tripId, String otp);
}