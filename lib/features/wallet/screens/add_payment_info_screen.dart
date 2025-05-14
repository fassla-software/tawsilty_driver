import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/withdraw_model.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/string_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class AddPaymentInfoScreen extends StatefulWidget {
  const AddPaymentInfoScreen({super.key});

  @override
  State<AddPaymentInfoScreen> createState() => _AddPaymentInfoScreenState();
}

class _AddPaymentInfoScreenState extends State<AddPaymentInfoScreen> {
  final TextEditingController _methodName = TextEditingController();

  @override
  void initState() {
    Get.find<WalletController>().getWithdrawMethods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title:'add_withdraw_method'.tr, showBackButton: true),
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: GetBuilder<WalletController>(builder: (walletController) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSeven),
                child: Text(
                  'method_name'.tr,
                  style: textBold.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              ),

              TextField(
                controller: _methodName,
                keyboardType: TextInputType.text,
                cursorColor: Theme.of(context).hintColor,
                style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeOver),
                    borderSide:  BorderSide(
                      width: 0.5,
                      color: Theme.of(context).hintColor.withOpacity(0.25),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeOver),
                    borderSide:  BorderSide(
                      width: 0.5,
                      color: Theme.of(context).hintColor.withOpacity(0.25),
                    ),
                  ),
                  hintText: 'personal_account'.tr,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text('payment_method'.tr,
                style: textBold.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              SizedBox(width: Get.width,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeOver),
                      border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.25))
                    ),
                    child: DropdownButtonFormField2<Withdraw>(
                      isExpanded: true,
                      isDense: true,
                      style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none
                        ),

                      ),
                      hint: Text(
                        walletController.selectedMethod?.methodName ??'select_withdraw_method'.tr,
                        style: textRegular.copyWith(color: Theme.of(context).hintColor),
                      ),
                      items: walletController.methodList.map((item) => DropdownMenuItem<Withdraw>(
                          value: item, child: Text(
                        item.methodName ?? '',
                        style: textRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyMedium!.color
                        ),
                      ))).toList(),
                      onChanged: (value) {
                        walletController.setMethodTypeIndex(value!);
                      },
                      buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(right: 8)),
                      iconStyleData: IconStyleData(
                        icon: Icon(Icons.arrow_drop_down,
                            color: Theme.of(context).hintColor), iconSize: 24,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  )
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              if(walletController.methodList.isNotEmpty && walletController.selectedMethod != null &&
                  walletController.selectedMethod!.methodFields != null &&
                  walletController.inputFieldControllerList.isNotEmpty &&
                  walletController.selectedMethod!.methodFields!.isNotEmpty)
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: walletController.selectedMethod!.methodFields!.length,
                  itemBuilder: (context, index){

                    String type = walletController.selectedMethod!.methodFields![index].inputType!;

                    return Padding(padding:  const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSeven),
                            child: Text(
                              walletController.selectedMethod?.methodFields?[index].inputName?.toTitleCase() ?? '',
                              style: textBold.copyWith(
                                color: Theme.of(context).textTheme.bodyMedium!.color,
                              ),
                            ),
                          ),

                          TextField(
                            controller: walletController.inputFieldControllerList[index],
                            keyboardType: (type == 'number' || type == "phone") ? TextInputType.number:
                            TextInputType.text,
                            cursorColor: Theme.of(context).hintColor,
                            style: textRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeOver),
                                borderSide:  BorderSide(
                                  width: 0.5,
                                  color: Theme.of(context).hintColor.withOpacity(0.25),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeOver),
                                borderSide:  BorderSide(
                                  width: 0.5,
                                  color: Theme.of(context).hintColor.withOpacity(0.25),
                                ),
                              ),
                              hintText: walletController.selectedMethod!.methodFields![index].placeholder,
                            ),

                          ),
                        ],
                      ),
                    );
                  },
                )
            ]);
          }),
        ),
      ),
      bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min,
        children: [
          GetBuilder<WalletController>(builder: (walletController){
            return Padding( padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: walletController.isLoading ?
              Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
              ButtonWidget(
                buttonText: 'save'.tr,
                onPressed: (){
                  bool haveBlankTitle = false;
                  for(int i =0; i< walletController.inputFieldControllerList.length; i++){
                    if(walletController.inputFieldControllerList[i].text.isEmpty &&
                        walletController.isRequiredList[i] == 1){
                      haveBlankTitle = true;
                      break;
                    }
                  }
                  if(haveBlankTitle){
                    showCustomSnackBar('please_fill_all_the_field'.tr);
                  }else if(_methodName.text.isEmpty){
                    showCustomSnackBar('please_fill_all_the_field'.tr);
                  } else{
                    walletController.createWithdrawMethodInfo(_methodName.text);
                  }
                },
              ),
            );
          })
        ]),
    );
  }
}
