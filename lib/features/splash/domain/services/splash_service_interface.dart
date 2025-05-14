abstract class SplashServiceInterface {
  Future<dynamic> getConfigData();
  Future<bool> initSharedData();
  Future<bool> removeSharedData();
  bool haveOngoingRides();
  void saveOngoingRides(bool value);
  void addLastReFoundData(Map<String, dynamic>? data);
  Map<String, dynamic>? getLastRefundData();
  Future<void> uploadCachedFiles();
}
