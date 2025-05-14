

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/interface/repository_interface.dart';

abstract class WalletRepositoryInterface implements RepositoryInterface{

  Future<Response?> getTransactionList(int offset);
  Future<Response?> getLoyaltyPointList(int offset);
  Future<Response?> convertPoint(String point);
  Future<Response?> getDynamicWithdrawMethodList();
  Future<Response?> getWithdrawMethodInfoList(int offset);
  Future<Response?> createWithdrawMethodInfo(List <String> typeKey, List<String> typeValue,int id);
  Future<Response?> updateWithdrawMethodInfo(List <String> typeKey, List<String> typeValue,int methodId, String methodInfoId);
  Future<Response?> deleteWithdrawMethodInfo(String methodId);
  Future<Response?> withdrawBalance(List <String> typeKey, List<String> typeValue,int id, String balance, String note);
  Future<Response> getPayableHistoryList(int offset);
  Future<Response> getWalletHistoryList(int offset);
  Future<Response> getIncomeStatement(int offset);
  Future<Response> getWithdrawPendingList(int offset);
  Future<Response> getCashCollectHistoryList(int offset);
  Future<Response> getWithdrawSettledList(int offset);
}