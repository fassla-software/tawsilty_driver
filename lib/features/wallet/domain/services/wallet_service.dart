

import 'package:ride_sharing_user_app/features/wallet/domain/repositories/wallet_repository_interface.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/services/wallet_service_interface.dart';

class WalletService implements WalletServiceInterface{
  final WalletRepositoryInterface walletRepositoryInterface;
  WalletService({required this.walletRepositoryInterface});

  @override
  Future convertPoint(String point) {
    return walletRepositoryInterface.convertPoint(point);
  }

  @override
  Future getDynamicWithdrawMethodList() {
    return walletRepositoryInterface.getDynamicWithdrawMethodList();
  }

  @override
  Future getLoyaltyPointList(int offset) {
    return walletRepositoryInterface.getLoyaltyPointList(offset);
  }

  @override
  Future getTransactionList(int offset) {
    return walletRepositoryInterface.getTransactionList(offset);
  }

  @override
  Future withdrawBalance(List<String> typeKey, List<String> typeValue, int id, String balance, String note) {
   return walletRepositoryInterface.withdrawBalance(typeKey, typeValue, id, balance, note);
  }

  @override
  Future getWithdrawMethodInfoList(int offset) {
    return walletRepositoryInterface.getWithdrawMethodInfoList(offset);
  }

  @override
  Future createWithdrawMethodInfo(List <String> typeKey, List<String> typeValue,int id) {
    return walletRepositoryInterface.createWithdrawMethodInfo(typeKey, typeValue, id);
  }

  @override
  Future updateWithdrawMethodInfo(List <String> typeKey, List<String> typeValue,int methodId,String methodInfoId) {
    return walletRepositoryInterface.updateWithdrawMethodInfo(typeKey, typeValue, methodId,methodInfoId);
  }

  @override
  Future deleteWithdrawMethodInfo(String methodId) {
    return walletRepositoryInterface.deleteWithdrawMethodInfo(methodId);
  }

  @override
  Future getIncomeStatement(int offset) {
   return walletRepositoryInterface.getIncomeStatement(offset);
  }

  @override
  Future getPayableHistoryList(int offset) {
    return walletRepositoryInterface.getPayableHistoryList(offset);
  }

  @override
  Future getWithdrawPendingList(int offset) {
    return walletRepositoryInterface.getWithdrawPendingList(offset);
  }

  @override
  Future getWithdrawSettledList(int offset) {
    return walletRepositoryInterface.getWithdrawSettledList(offset);
  }

  @override
  Future getWalletHistoryList(int offset) {
    return walletRepositoryInterface.getWalletHistoryList(offset);
  }

  @override
  Future getCashCollectHistoryList(int offset) {
    return walletRepositoryInterface.getCashCollectHistoryList(offset);
  }


}