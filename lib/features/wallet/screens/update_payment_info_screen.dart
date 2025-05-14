import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/loader_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/withdraw_method_info_model.dart';
import 'package:ride_sharing_user_app/helper/string_helper.dart';
import 'package:ride_sharing_user_app/helper/toaster.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class UpdatePaymentInfoScreen extends StatefulWidget {
  final SingleMethodInfo methods;
  const UpdatePaymentInfoScreen({super.key, required this.methods});

  @override
  State<UpdatePaymentInfoScreen> createState() => _UpdatePaymentInfoScreenState();
}

class _UpdatePaymentInfoScreenState extends State<UpdatePaymentInfoScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _methodName = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.methods.withdrawMethod!.methodName!;
    _methodName.text = widget.methods.methodName!;
    Get.find<WalletController>().clearTextControllers();
    Get.find<WalletController>().addUpdateTextFieldTexts(widget.methods);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title:'update_withdraw_method'.tr, showBackButton: true),
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

              SizedBox(
                  width: Get.width,
                  child: TextField(
                    controller: _controller,
                    readOnly: true,
                    cursorColor: Theme.of(context).hintColor,
                    style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeOver),
                        borderSide:  BorderSide(
                          color: Theme.of(context).primaryColor.withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeOver),
                        borderSide:  BorderSide(
                          color: Theme.of(context).primaryColor.withOpacity(0.5),
                        ),
                      ),
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: Theme.of(context).primaryColor,
                      )
                    ),

                  )
              ),

              const SizedBox(height: Dimensions.paddingSizeDefault),

              (widget.methods.methodInfo!.isNotEmpty && widget.methods.methodInfo != null &&
                  walletController.inputFieldControllerList.isNotEmpty) ?
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.methods.methodInfo!.length,
                itemBuilder: (context, index){

                  String type = widget.methods.withdrawMethod!.methodFields![index].inputType!;

                  return Padding(padding:  const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSeven),
                          child: Text(
                            widget.methods.methodInfo![index].key?.toTitleCase() ?? '',
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
                                color: Theme.of(context).primaryColor.withOpacity(0.25),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeOver),
                              borderSide:  BorderSide(
                                color: Theme.of(context).primaryColor.withOpacity(0.25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ) : const LoaderWidget()
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
                  buttonText:'update'.tr,
                  onPressed: (){
                    bool haveBlankTitle = false;
                    for(int i =0; i< walletController.inputFieldControllerList.length; i++){
                      if(walletController.inputFieldControllerList[i].text.isEmpty && walletController.isRequiredList[i] == 1){
                        haveBlankTitle = true;
                        break;
                      }
                    }
                    if(haveBlankTitle){
                      showCustomToaster('please_fill_all_the_field'.tr);
                    }else{
                      walletController.updateWithdrawMethodInfo(
                        _methodName.text,
                          widget.methods.id ?? '',widget.methods.withdrawMethod?.id ?? 0,
                      );
                    }
                  },
                ),
              );
            })
          ]),
    );
  }
}
