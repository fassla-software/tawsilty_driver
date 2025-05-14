
abstract class ReferEarnRepositoryInterface {
  Future<dynamic> getEarningHistoryList (int offset);
  Future<dynamic> getReferralDetails();
}