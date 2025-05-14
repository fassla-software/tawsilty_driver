import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/domain/repositories/refer_earn_repository_intertface.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/domain/services/refer_earn_service_interface.dart';

class ReferEarnService implements ReferEarnServiceInterface{
  ReferEarnRepositoryInterface referEarnRepositoryInterface;

  ReferEarnService({required this.referEarnRepositoryInterface});

  @override
  Future<Response> getEarningHistoryList(int offset) async{
    return await referEarnRepositoryInterface.getEarningHistoryList(offset);
  }

  @override
  Future<Response> getReferralDetails() async{
    return await referEarnRepositoryInterface.getReferralDetails();
  }
}