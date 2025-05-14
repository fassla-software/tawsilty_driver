

import 'package:ride_sharing_user_app/features/trip/domain/repositories/trip_repository_interface.dart';
import 'package:ride_sharing_user_app/features/trip/domain/services/trip_service_interface.dart';

class TripService implements TripServiceInterface{

  final TripRepositoryInterface tripRepositoryInterface;
  TripService({required this.tripRepositoryInterface});

  @override
  Future getTripList(String tripType, String from, String to, int offset, String filter, String status) {
    return tripRepositoryInterface.getTripList(tripType, from, to, offset, filter,status);
  }

  @override
  Future getTripOverView(String filter) {
    return tripRepositoryInterface.getTripOverView(filter);
  }

  @override
  Future paymentSubmit(String tripId, String paymentMethod) {
    return tripRepositoryInterface.paymentSubmit(tripId, paymentMethod);
  }
  @override
  Future rideCancellationReasonList() async{
    return await tripRepositoryInterface.rideCancellationReasonList();
  }

  @override
  Future parcelCancellationReasonList() async{
    return await tripRepositoryInterface.parcelCancellationReasonList();
  }

  @override
  Future resendReturnedOtp(String tripId) async{
    return await tripRepositoryInterface.resendReturnedOtp(tripId);
  }

  @override
  Future parcelReturnSubmitOtp(String tripId, String otp) async{
    return await tripRepositoryInterface.parcelReturnSubmitOtp(tripId, otp);
  }

}