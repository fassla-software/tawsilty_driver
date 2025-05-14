import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/trip/domain/models/trip_model.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/pending_settled_withdraw_model.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/withdraw_method_info_model.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/services/wallet_service_interface.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/delete_confermation_dialog_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/withdraw_successful_dialog_widget.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/loyalty_point_model.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/transaction_model.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/withdraw_model.dart';


class WalletController extends GetxController implements GetxService {
  final WalletServiceInterface walletServiceInterface;

  WalletController({required this.walletServiceInterface});


  List<String> walletTypeList = ['wallet_money', 'my_point', 'income_statements'];
  List<String> walletFilterType = ['select', 'today', 'this_month', 'this_year'];
  List<String> walletTransactionType = ['select', 'pending', 'withdrawn', 'cancelled'];
  List<String> selectedFilterType = ['select', 'today', 'this_month', 'this_year'];
  List<String> payableTypeList = ['payable_balance', 'cash_collect'];
  int _walletTypeIndex = 0;
  int payableTypeIndex = 0;

  int get walletTypeIndex => _walletTypeIndex;
  TransactionModel? transactionModel;
  Withdraw? selectedMethod;
  List<Withdraw> methodList = [];
  List<TextEditingController> inputFieldControllerList = [];
  List<int> isRequiredList = [];
  final List<int> suggestedAmount = [100, 200, 300, 400, 500, 1000, 1500, 2000];
  int selectedIndex = -1;
  LoyaltyPointModel? loyaltyPointModel;
  List<String> inputValueList = [];
  bool validityCheck = false;
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  List <String> keyList = [];
  WithdrawMethodInfoData? withdrawMethodInfoData;
  SingleMethodInfo? selectedMethodInfo;
  bool isHindShow = true;
  PendingSettledWithdrawModel? pendingSettledWithdrawModel;
  TripModel? incomeStatement;

  bool isMethodSelected = true;
  bool haveWithdrawAmount = true;
  int selectedHistoryIndex = 1;

  void setSelectedHistoryIndex(int index, bool notify) {
      selectedHistoryIndex = index;
      pendingSettledWithdrawModel = null;
      if (notify) {
        update();
      }
      if (index == 1) {
        getWithdrawPendingList(1);
      } else if(index == 2){
        getWithdrawSettledList(1);
      }else if(index == 3){
        getCashCollectHistoryList(1);
      }else{
        getWalletHistoryList(1);
      }
  }

  void toggleMethodSelected(bool action) {
    isMethodSelected = action;
    update();
  }

  void toggleHaveWithdrawAmount(bool action) {
    haveWithdrawAmount = action;
    update();
  }

  void toggleHintTextShow(bool action, bool isUpdate) {
    isHindShow = action;
    if (isUpdate) {
      update();
    }
  }


  void setMethodInfoTypeIndex(SingleMethodInfo methodInfo) {
    selectedMethodInfo = methodInfo;
    update();
  }

  bool isLoading = false;
  String selectedValue = 'select';

  String _selectedFilterTypeName = 'pending';

  String get selectedFilterTypeName => _selectedFilterTypeName;

  void setFilterTypeName(String name) {
    _selectedFilterTypeName = name;
    update();
  }

  bool isConvert = false;

  void toggleConvertCard(bool value) {
    isConvert = value;
    update();
  }

  void setWalletTypeIndex(int index) {
    _walletTypeIndex = index;
    update();
  }

  Future<Response> getLoyaltyPointList(int offset) async {
    isLoading = true;
    // update();
    Response? response = await walletServiceInterface.getLoyaltyPointList(offset);
    if (response!.statusCode == 200) {
      if (offset == 1) {
        loyaltyPointModel = LoyaltyPointModel.fromJson(response.body);
      } else {
        loyaltyPointModel!.data!.addAll(LoyaltyPointModel
            .fromJson(response.body)
            .data!);
        loyaltyPointModel!.offset = LoyaltyPointModel
            .fromJson(response.body)
            .offset;
        loyaltyPointModel!.totalSize = LoyaltyPointModel
            .fromJson(response.body)
            .totalSize;
      }
      isLoading = false;
    } else {
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }



  Future<Response> convertPoint(String point) async {
    isLoading = true;
    update();
    Response? response = await walletServiceInterface.convertPoint(point);
    if (response!.statusCode == 200) {
      getLoyaltyPointList(1);
      Get.find<ProfileController>().getProfileInfo();
      isLoading = false;
    } else {
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


  void getInputFieldList() {
    inputFieldControllerList = [];
    if (methodList.isNotEmpty && selectedMethod != null) {
      for (int i = 0; i < selectedMethod!.methodFields!.length; i++) {
        inputFieldControllerList.add(TextEditingController());
        isRequiredList.add(selectedMethod!.methodFields![i].isRequired!);
      }
    }
  }

  void setSelectedIndex(int index) {
    selectedIndex = index;
    update();
  }


  void setMethodTypeIndex(Withdraw withdraw, {bool notify = true}) {
    selectedMethod = withdraw;
    keyList = [];
    if (methodList.isNotEmpty) {
      for (int i = 0; i < selectedMethod!.methodFields!.length; i++) {
        keyList.add(selectedMethod!.methodFields![i].inputName!);
      }
      getInputFieldList();
    }
    if (notify) {
      update();
    }
  }

  Future<void> getWithdrawMethods() async {
    methodList = [];
    Response? response = await walletServiceInterface.getDynamicWithdrawMethodList();
    if (response!.statusCode == 200) {
      methodList.addAll(WithdrawModel
          .fromJson(response.body)
          .data!);
      getInputFieldList();
      for (int index = 0; index < methodList.length; index++) {
        if (methodList[index].isDefault!) {
          setMethodTypeIndex(methodList[index], notify: false);
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<Response?> updateBalance(String balance, String note) async {
    isLoading = true;
    update();
    keyList = [];
    inputValueList = [];
    for (int i = 0; i < selectedMethodInfo!.methodInfo!.length; i++) {
      keyList.add(selectedMethodInfo!.methodInfo![i].key!);
      inputValueList.add(selectedMethodInfo!.methodInfo![i].value!);
    }


    Response? response = await walletServiceInterface.withdrawBalance(
      keyList,
      inputValueList,
      selectedMethodInfo!.withdrawMethod!.id!,
      balance,
      note,
    );

    if (response!.statusCode == 200) {
      Get.back();
      inputValueList.clear();
      inputFieldControllerList.clear();
      getWithdrawPendingList(1);
      isLoading = false;
      showDialog(barrierDismissible: false,
        context: Get.context!, builder: (_) => const WithdrawSuccessfulDialogWidget(),
      );
      Get.find<ProfileController>().getProfileInfo();
    }
    else {
      isLoading = false;
      ApiChecker.checkApi(response);
    }

    update();
    return response;
  }

  Future<void> getWithdrawMethodInfoList(int offset) async {
    Response response = await walletServiceInterface.getWithdrawMethodInfoList(offset);
    if (response.statusCode == 200) {
      if (offset == 1) {
        withdrawMethodInfoData = WithdrawMethodInfoData.fromJson(response.body);
      } else {
        withdrawMethodInfoData?.totalSize = WithdrawMethodInfoData
            .fromJson(response.body)
            .totalSize;
        withdrawMethodInfoData?.offset = WithdrawMethodInfoData
            .fromJson(response.body)
            .offset;
        withdrawMethodInfoData?.data?.addAll(WithdrawMethodInfoData
            .fromJson(response.body)
            .data!);
      }
    }else{
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
  }

  Future<void> createWithdrawMethodInfo(String methodName) async {
    isLoading = true;
    update();
    for (TextEditingController textEditingController in inputFieldControllerList) {
      inputValueList.add(textEditingController.text.trim());
    }
    keyList.add('method_name');
    inputValueList.add(methodName);

    Response response =
    await walletServiceInterface.createWithdrawMethodInfo(
        keyList, inputValueList, selectedMethod!.id!);
    Get.back();
    if (response.statusCode == 200) {
      showCustomSnackBar('submitted_successfully'.tr, isError: false);
      getWithdrawMethodInfoList(1);
    }else{
      ApiChecker.checkApi(response);
    }
    inputValueList.clear();
    isLoading = false;
    update();
  }

  Future<void> updateWithdrawMethodInfo(String methodName, String methodInfoId,
      int methodId) async {
    isLoading = true;
    update();
    for (TextEditingController textEditingController in inputFieldControllerList) {
      inputValueList.add(textEditingController.text.trim());
    }
    keyList.add('method_name');
    inputValueList.add(methodName);

    Response response =
    await walletServiceInterface.updateWithdrawMethodInfo(
        keyList, inputValueList, methodId, methodInfoId);
    Get.back();
    if (response.statusCode == 200) {
      showCustomSnackBar('updated_successfully'.tr, isError: false);
      getWithdrawMethodInfoList(1);
    }else{
      ApiChecker.checkApi(response);
    }
    inputValueList.clear();
    isLoading = false;
    update();
  }

  Future<void> deleteWithdrawMethodInfo(String methodId) async {
    isLoading = true;
    update();

    Response response = await walletServiceInterface.deleteWithdrawMethodInfo(methodId);
    Get.back();
    if (response.statusCode == 200) {
      showCustomSnackBar('successfully_delete_payment_method'.tr, isError: false);
      getWithdrawMethodInfoList(1);
      selectedMethodInfo = null;
    }else{
      showDialog(
        barrierDismissible: false, context: Get.context!,
        builder: (_) => const DeleteConfirmationDialogWidget(fromFailed: true)
      );
    }
    isLoading = false;
    update();
  }

  Future<void> addUpdateTextFieldTexts(SingleMethodInfo method) async {
    for (int i = 0; i < method.methodInfo!.length; i++) {
      keyList.add(method.methodInfo![i].key!);
      inputFieldControllerList.add(TextEditingController(text: method.methodInfo![i].value!));
    }
  }

  void clearTextControllers() {
    keyList = [];
    inputFieldControllerList = [];
  }

  Future<void> getIncomeStatement(int offset) async {
    isLoading = true;

    Response? response = await walletServiceInterface.getIncomeStatement(offset);
    if (response!.statusCode == 200) {
      if (offset == 1) {
        incomeStatement = TripModel.fromJson(response.body);
      } else {
        incomeStatement!.data!.addAll(TripModel.fromJson(response.body).data!);
        incomeStatement!.offset = TripModel.fromJson(response.body).offset;
        incomeStatement!.totalSize = TripModel.fromJson(response.body).totalSize;
      }
      isLoading = false;
    } else {
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    manipulationIncomeStatement();
  }

  Future<void> getPayableHistoryList(int offset) async {
    isLoading = true;

    Response? response = await walletServiceInterface.getPayableHistoryList(offset);
    if (response!.statusCode == 200) {
      if (offset == 1) {
        transactionModel = TransactionModel.fromJson(response.body);
      } else {
        transactionModel!.data!.addAll(TransactionModel.fromJson(response.body).data!);
        transactionModel!.offset = TransactionModel.fromJson(response.body).offset;
        transactionModel!.totalSize = TransactionModel.fromJson(response.body).totalSize;
      }
      isLoading = false;
    } else {
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getWalletHistoryList(int offset) async {
    isLoading = true;

    Response? response = await walletServiceInterface.getWalletHistoryList(offset);
    if (response!.statusCode == 200) {
      if (offset == 1) {
        transactionModel = TransactionModel.fromJson(response.body);
      } else {
        transactionModel!.data!.addAll(TransactionModel.fromJson(response.body).data!);
        transactionModel!.offset = TransactionModel.fromJson(response.body).offset;
        transactionModel!.totalSize = TransactionModel.fromJson(response.body).totalSize;
      }
      isLoading = false;
    } else {
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getWithdrawPendingList(int offset) async {
    isLoading = true;

    Response? response = await walletServiceInterface.getWithdrawPendingList(offset);
    if (response!.statusCode == 200) {
      if (offset == 1) {
        pendingSettledWithdrawModel = PendingSettledWithdrawModel.fromJson(response.body);
      } else {
        pendingSettledWithdrawModel!.data!.addAll(
          PendingSettledWithdrawModel.fromJson(response.body).data!,
        );
        pendingSettledWithdrawModel!.offset = PendingSettledWithdrawModel.fromJson(response.body).offset;
        pendingSettledWithdrawModel!.totalSize = PendingSettledWithdrawModel.fromJson(response.body).totalSize;
      }
      isLoading = false;
    } else {
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getWithdrawSettledList(int offset) async {
    isLoading = true;

    Response? response = await walletServiceInterface.getWithdrawSettledList(offset);
    if (response!.statusCode == 200) {
      if (offset == 1) {
        pendingSettledWithdrawModel = PendingSettledWithdrawModel.fromJson(response.body);
      } else {
        pendingSettledWithdrawModel!.data!.addAll(PendingSettledWithdrawModel
            .fromJson(response.body)
            .data!);
        pendingSettledWithdrawModel!.offset = PendingSettledWithdrawModel
            .fromJson(response.body)
            .offset;
        pendingSettledWithdrawModel!.totalSize = PendingSettledWithdrawModel
            .fromJson(response.body)
            .totalSize;
      }
      isLoading = false;
    } else {
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  List<List<TripDetail>>? incomeStatementData;

  void manipulationIncomeStatement() {

    if(incomeStatement!.data != null && incomeStatement!.data!.isNotEmpty){
      int count = 0;
      incomeStatementData = [[]];
      incomeStatementData![count].add(incomeStatement!.data![0]);
      for (int i = 1; i < incomeStatement!.data!.length; i++) {
        if (DateConverter.isoStringToLocalDateOnly(incomeStatement!.data![i].createdAt!) ==
            DateConverter.isoStringToLocalDateOnly(incomeStatement!.data![i - 1].createdAt!)) {
          incomeStatementData![count].add(incomeStatement!.data![i]);

        } else {
          incomeStatementData!.add([]);
          count++;
          incomeStatementData![count]= [];
          incomeStatementData![count].add(incomeStatement!.data![i]);
        }
      }
    }else{
      incomeStatementData = [];
    }

    update();
  }

  void setPayableTypeIndex(int index,{bool notify = true}) {
    payableTypeIndex = index;
    if(index == 0){
      getPayableHistoryList(1);
    }else{
      getCashCollectHistoryList(1);
    }
    if(notify){
      update();
    }
  }

  Future<void> getCashCollectHistoryList(int offset) async {
    isLoading = true;

    Response? response = await walletServiceInterface.getCashCollectHistoryList(offset);
    if (response!.statusCode == 200) {
      if (offset == 1) {
        transactionModel = TransactionModel.fromJson(response.body);
      } else {
        transactionModel!.data!.addAll(TransactionModel.fromJson(response.body).data!);
        transactionModel!.offset = TransactionModel.fromJson(response.body).offset;
        transactionModel!.totalSize = TransactionModel.fromJson(response.body).totalSize;
      }
      isLoading = false;
    } else {
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }


}
