import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/text_field_widget.dart';


class BankInfoEditScreen extends StatefulWidget {
  const BankInfoEditScreen({super.key});

  @override
  State<BankInfoEditScreen> createState() => _BankInfoEditScreenState();
}

class _BankInfoEditScreenState extends State<BankInfoEditScreen> {

  final FocusNode _accountNameFocus = FocusNode();
  final FocusNode _bankNameFocus = FocusNode();
  final FocusNode _branchNameFocus = FocusNode();
  final FocusNode _accountNumberFocus = FocusNode();


  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();



  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'bank_info_edit'.tr, regularAppbar : true,),
      body: Padding(
        padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [


            Padding(
              padding:  const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: Text('account_holder_name'.tr, style: textRegular),
                  ),
                   const SizedBox(height: Dimensions.paddingSizeSmall),

                  TextFieldWidget(
                    inputType: TextInputType.name,
                    focusNode: _accountNameFocus,
                    nextFocus: _bankNameFocus,
                    hintText:  'enter_account_name'.tr,
                    controller: _accountNameController,
                    prefixIcon: Images.userIcon,
                    inputAction: TextInputAction.next,
                  ),

                   const SizedBox(height: Dimensions.paddingSizeDefault),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: Text('bank_name'.tr, style: textRegular),
                  ),

                   const SizedBox(height: Dimensions.paddingSizeSmall),
                  TextFieldWidget(
                    inputType: TextInputType.name,
                    focusNode: _bankNameFocus,
                    nextFocus: _branchNameFocus,
                    hintText: 'enter_bank_name'.tr,
                    controller: _bankNameController,
                    prefixIcon: Images.bankIcon,
                    inputAction: TextInputAction.next,
                  ),
                   const SizedBox(height: Dimensions.paddingSizeDefault),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: Text('branch_name'.tr, style: textRegular),
                  ),

                   const SizedBox(height: Dimensions.paddingSizeSmall),
                  TextFieldWidget(
                    inputType: TextInputType.name,
                    focusNode: _branchNameFocus,
                    nextFocus: _accountNumberFocus,
                    hintText:  "enter_branch_name".tr,
                    controller: _branchNameController,
                    prefixIcon: Images.branchNameIcon,
                    inputAction: TextInputAction.next,
                  ),

                   const SizedBox(height: Dimensions.paddingSizeDefault),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: Text('account_no'.tr, style: textRegular),
                  ),

                   const SizedBox(height: Dimensions.paddingSizeSmall),
                  TextFieldWidget(

                    inputType: TextInputType.text,
                    focusNode: _accountNumberFocus,
                    hintText:  "enter_acc_number".tr,
                    prefixIcon: Images.accNumberIcon,
                    controller: _accountNumberController,
                    inputAction: TextInputAction.done,

                  ),
                ],
              ),
            ),



             const SizedBox(height: Dimensions.paddingSizeDefault,),
            GetBuilder<WalletController>(
              builder: (profile) {
                return  ButtonWidget(onPressed: (){
                  String accountName = _accountNameController.text.trim();
                  String bankName = _bankNameController.text.trim();
                  String branchName = _branchNameController.text.trim();
                  String accountNumber = _accountNumberController.text.trim();
                      if(accountName.isEmpty){
                        showCustomSnackBar('account_name_is_required'.tr);
                      }else if(bankName.isEmpty){
                        showCustomSnackBar('bank_name_is_required'.tr);
                      }else if(branchName.isEmpty){
                        showCustomSnackBar('branch_name_is_required'.tr);
                      }else if(accountNumber.isEmpty){
                        showCustomSnackBar('account_number_is_required'.tr);
                      }else{
                        Get.back();
                      }
                },
                    buttonText: 'update'.tr);
              }
            ),

          ],
        ),
      ),
    );
  }
}
