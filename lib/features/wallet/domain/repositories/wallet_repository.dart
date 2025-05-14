import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/repositories/wallet_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class WalletRepository implements WalletRepositoryInterface{
  final ApiClient apiClient;

  WalletRepository({required this.apiClient});

  @override
  Future<Response?> getTransactionList(int offset) async {
    return await apiClient.getData('${AppConstants.transactionListUri}$offset');
  }

  @override
  Future<Response?> getLoyaltyPointList(int offset) async {
    return await apiClient.getData('${AppConstants.loyaltyPointListUri}$offset');
  }

  @override
  Future<Response?> convertPoint(String point) async {
    return await apiClient.postData(AppConstants.pointConvert,{
      'points' : point
    });
  }

  @override
  Future<Response?> getDynamicWithdrawMethodList() async {
    return await apiClient.getData(AppConstants.dynamicWithdrawMethodList);
  }

  @override
  Future<Response?> getWithdrawMethodInfoList(int offset) async{
    return await apiClient.getData('${AppConstants.getWithdrawMethodInfoList}$offset');
  }

  @override
  Future<Response?> createWithdrawMethodInfo(List <String> typeKey, List<String> typeValue,int id) async{
    Map<String, String> fields = {};

    for(var i = 0; i < typeKey.length; i++){
      fields.addAll(<String, String>{
        typeKey[i] : typeValue[i]
      });
      if (kDebugMode) {
        print('--here is type key =${typeKey.toList()}/${typeValue.toList()}');
      }
    }
    fields.addAll(<String, String>{
      'withdraw_method': id.toString(),
    });

    Response response = await apiClient.postData(
        AppConstants.withdrawMethodCreate, fields);

    return response;
  }

  @override
  Future<Response?> updateWithdrawMethodInfo(List <String> typeKey, List<String> typeValue,int methodId, String methodInfoId) async{
    Map<String, String> fields = {};

    for(var i = 0; i < typeKey.length; i++){
      fields.addAll(<String, String>{
        typeKey[i] : typeValue[i]
      });
      if (kDebugMode) {
        print('--here is type key =${typeKey.toList()}/${typeValue.toList()}');
      }
    }
    fields.addAll(<String, String>{
      'withdraw_method': methodId.toString(),
    });

    Response response = await apiClient.postData(
        '${AppConstants.withdrawMethodUpdate}$methodInfoId', fields);

    return response;
  }

  @override
  Future<Response?> deleteWithdrawMethodInfo(String methodId) async{
    Response response = await apiClient.postData(
        '${AppConstants.withdrawMethodDelete}$methodId',{});

    return response;
  }

  @override
  Future<Response?> withdrawBalance(List <String> typeKey, List<String> typeValue,int id, String balance, String note) async {

      Map<String, String> fields = {};

      for(var i = 0; i < typeKey.length; i++){
        fields.addAll(<String, String>{
          typeKey[i] : typeValue[i]
        });
        if (kDebugMode) {
          print('--here is type key =${typeKey.toList()}/${typeValue.toList()}');
        }
      }
      fields.addAll(<String, String>{
        'amount': balance,
        'withdraw_method': id.toString(),
        'note': note
      });

      Response response = await apiClient.postData(
          AppConstants.withdrawRequestUri, fields);

      return response;

  }

  @override
  Future<Response> getIncomeStatement(int offset) async{
    return await apiClient.getData('${AppConstants.incomeStatementUri}$offset');
  }

  @override
  Future<Response> getPayableHistoryList(int offset) async{
    return await apiClient.getData('${AppConstants.payableListUri}$offset');
  }

  @override
  Future<Response> getWithdrawPendingList(int offset) async{
    return await apiClient.getData('${AppConstants.withdrawPendingListUri}$offset');
  }

  @override
  Future<Response> getWithdrawSettledList(int offset) async{
    return await apiClient.getData('${AppConstants.withdrawSettledListUri}$offset');
  }

  @override
  Future<Response> getCashCollectHistoryList(int offset) async{
    return await apiClient.getData('${AppConstants.cashCollectHistoryList}$offset');
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

  @override
  Future<Response> getWalletHistoryList(int offset) async {
    return await apiClient.getData('${AppConstants.walletListUri}$offset');
  }


}