

abstract class WalletServiceInterface {
  Future<dynamic> getTransactionList(int offset);
  Future<dynamic> getLoyaltyPointList(int offset);
  Future<dynamic> convertPoint(String point);
  Future<dynamic> getDynamicWithdrawMethodList();
  Future<dynamic> getWithdrawMethodInfoList(int offset);
  Future<dynamic> createWithdrawMethodInfo(List <String> typeKey, List<String> typeValue,int id);
  Future<dynamic> updateWithdrawMethodInfo(List <String> typeKey, List<String> typeValue,int methodId,String methodInfoId);
  Future<dynamic> deleteWithdrawMethodInfo(String methodId);
  Future<dynamic> withdrawBalance(List <String> typeKey, List<String> typeValue,int id, String balance, String note);
  Future<dynamic> getPayableHistoryList(int offset);
  Future<dynamic> getWalletHistoryList(int offset);
  Future<dynamic> getIncomeStatement(int offset);
  Future<dynamic> getWithdrawPendingList(int offset);
  Future<dynamic> getCashCollectHistoryList(int offset);
  Future<dynamic> getWithdrawSettledList(int offset);
}