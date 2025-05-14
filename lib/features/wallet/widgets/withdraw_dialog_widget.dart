import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/withdraw_method_info_model.dart';
import 'package:ride_sharing_user_app/features/wallet/screens/add_payment_info_screen.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/helper/string_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';


class WithdrawRequestWidget extends StatefulWidget {
   const WithdrawRequestWidget({super.key});

  @override
  WithdrawRequestWidgetState createState() => WithdrawRequestWidgetState();
}

class WithdrawRequestWidgetState extends State<WithdrawRequestWidget> {

  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {

    ProfileController profileController = Get.find<ProfileController>();
    (profileController.profileInfo?.wallet?.receivableBalance ?? 0) -
        (profileController.profileInfo?.wallet?.payableBalance ?? 0) > 0 ?
    _balanceController.text = PriceConverter.convertPrice(
      context, ((profileController.profileInfo?.wallet?.receivableBalance ?? 0) -
        (profileController.profileInfo?.wallet?.payableBalance ?? 0)),
    ) :
    _balanceController.text = PriceConverter.convertPrice(
      context, ((profileController.profileInfo?.wallet?.payableBalance ?? 0 ) -
        (profileController.profileInfo?.wallet?.receivableBalance ?? 0)),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft:  Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: SingleChildScrollView(
        child: GetBuilder<WalletController>(builder: (walletController) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(width: double.infinity,
              decoration: BoxDecoration(color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft:  Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall,
                  vertical: Dimensions.paddingSizeDefault,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.keyboard_arrow_down),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeDefault,
                    horizontal: Dimensions.paddingSizeSmall,
                  ),
                  child: Column(children: [
                    if(walletController.withdrawMethodInfoData != null)
                    Container(width: Get.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeOver),
                            border: Border.all(
                              color: walletController.isMethodSelected ?
                              Theme.of(context).primaryColor.withOpacity(0.25):
                              Theme.of(context).colorScheme.error,
                            )
                        ),
                        child: DropdownButtonFormField2<SingleMethodInfo>(
                          isExpanded: true,
                          isDense: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none
                            ),

                          ),
                          hint: Text(walletController.selectedMethodInfo?.methodName ??
                              'select_withdraw_method'.tr,
                            style: textRegular.copyWith(
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          ),
                          items: walletController.withdrawMethodInfoData!.data!.map((item) =>
                              DropdownMenuItem<SingleMethodInfo>(
                                value: item,
                                child: Text(item.methodName ?? '', style: textRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).textTheme.bodyMedium!.color,
                                )),
                              )).toList(),
                          onChanged: (value) {
                            walletController.setMethodInfoTypeIndex(value!);
                            walletController.toggleMethodSelected(true);
                          },
                          buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(right: 8)),
                          iconStyleData: IconStyleData(
                            icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).hintColor),
                            iconSize: 24,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                          ),
                          menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 16)),
                        )
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    if(walletController.withdrawMethodInfoData == null ||
                        walletController.withdrawMethodInfoData!.data!.isEmpty)...[
                      InkWell(
                        onTap: ()=> Get.to(()=> const AddPaymentInfoScreen()),
                        child: Text('set_withdraw_method'.tr,style: textBold.copyWith(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).primaryColor
                        )),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault)
                    ],

                    if(walletController.selectedMethodInfo != null &&
                        walletController.selectedMethodInfo!.methodInfo!.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.25))
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: walletController.selectedMethodInfo?.methodInfo?.length ?? 0,
                          itemBuilder: (context, index){
                            return Padding(
                                padding:  const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                  Expanded(flex: 3, child: Text(
                                    walletController.selectedMethodInfo!.methodInfo![index].key!.toTitleCase(),
                                    style: textRegular.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  )),

                                  Expanded(flex: 1,
                                    child: Text(' : ',style: textRegular.copyWith(
                                      color: Theme.of(context).hintColor,
                                    )),
                                  ),

                                  Expanded(flex: 4, child: Text(
                                    '${walletController.selectedMethodInfo?.methodInfo?[index].value}',
                                    style: textRegular.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ))
                                ])
                            );
                          },
                        ),
                      )
                  ]),
                ),

                Container(width: MediaQuery.of(context).size.width,
                  padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Padding(
                      padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child: Text(
                        'withdraw_amount'.tr,
                        style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                      ),
                    ),

                    IntrinsicWidth(child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _balanceController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                      color: walletController.haveWithdrawAmount ?
                        Theme.of(context).primaryColor :
                        Theme.of(context).colorScheme.error,
                      ),
                      decoration: InputDecoration(
                        hintText: 'enter_amount'.tr,
                        hintStyle: textRegular.copyWith(
                          color: Theme.of(context).hintColor.withOpacity(.5),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:  BorderSide(width: 0.5,
                            color: Theme.of(context).hintColor.withOpacity(0.0),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:  BorderSide(width: 0.5,
                            color: Theme.of(context).hintColor.withOpacity(0.0),
                          ),
                        ),
                      ),
                      onTap: (){
                        walletController.toggleHaveWithdrawAmount(true);
                      },
                      onChanged: (String amount){
                        _balanceController.text = '${Get.find<SplashController>().config?.currencySymbol ?? '\$'}'
                            '${amount.replaceAll(Get.find<SplashController>().config?.currencySymbol ?? '\$', '')}';
                      },
                    )),
                    Divider(color: Theme.of(context).primaryColor.withOpacity(.25)),

                    Padding(
                      padding: const EdgeInsets.only(
                        top: Dimensions.paddingSizeSmall,
                        bottom: Dimensions.paddingSizeDefault,
                      ),
                      child: SizedBox(height: 30,
                        child: ListView.builder(
                          itemCount: walletController.suggestedAmount.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (amountContext, index){
                            return InkWell(
                              onTap: (){
                                walletController.setSelectedIndex(index);
                                walletController.toggleHaveWithdrawAmount(true);
                                _balanceController.text = PriceConverter.convertPrice(
                                    context,
                                    walletController.suggestedAmount[index].toDouble(),
                                );
                              },
                              child: Padding(
                                padding:  const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeSmall),
                                child: Container(
                                  padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                                    color: index == walletController.selectedIndex? Theme.of(context).primaryColor : Colors.transparent,
                                    border: Border.all(color:Get.isDarkMode ?
                                    Theme.of(context).hintColor.withOpacity(.5):
                                    Theme.of(context).primaryColor.withOpacity(.75),
                                    ),
                                  ),
                                  child: Center(child: Text(
                                    walletController.suggestedAmount[index].toString(),
                                    style: textRegular.copyWith(color:
                                    index == walletController.selectedIndex ?
                                    Colors.white :
                                    Theme.of(context).primaryColor,
                                    ),
                                  )),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child: Text(
                        'remark'.tr,
                        style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                      ),
                    ),

                    Padding(padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: noteController,
                        style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'remark_hint'.tr,
                          hintStyle: textRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(.5)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:  BorderSide(
                              width: 0.5,
                              color: Theme.of(context).primaryColor.withOpacity(0.25),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 35),

                !walletController.isLoading ?
                InkWell(
                  onTap: () {
                    if(walletController.withdrawMethodInfoData == null ||
                        walletController.withdrawMethodInfoData!.data!.isEmpty){
                      Get.find<WalletController>().toggleMethodSelected(false);
                      showCustomSnackBar('${'please_configure_your_payment_method'.tr}!');
                    }else if (walletController.selectedMethodInfo == null ||
                        walletController.selectedMethodInfo!.id!.isEmpty){
                      Get.find<WalletController>().toggleMethodSelected(false);
                      showCustomSnackBar('${'select_payment_method'.tr}!');
                    }else{
                      withdrawBalance();
                    }

                  },
                  child: Card(
                    color: (walletController.withdrawMethodInfoData?.data?.isEmpty ?? true) ?
                    Theme.of(context).hintColor : Theme.of(context).primaryColor,
                    child: SizedBox(height: 40, child: Center(
                      child: Text('withdraw_request'.tr, style: textRegular.copyWith(color: Colors.white)),
                    )),
                  ),
                ) :
                Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)),
              ]),
            ),
          );
        }),
      ),
    );
  }

  void withdrawBalance() async {
    String balance = '0';
    String note = '';
    double bal = 0;
    balance = _balanceController.text.trim().replaceAll(Get.find<SplashController>().config?.currencySymbol ?? '\$', '').replaceAll(' ', '').replaceAll(',', '');
    note = noteController.text.trim();

    if(balance.isNotEmpty){
       bal = double.parse(balance);
    }
    if (balance.isEmpty) {
      showCustomSnackBar('enter_balance'.tr);

    }else if(bal > Get.find<ProfileController>().profileInfo!.wallet!.receivableBalance!) {
      Get.find<WalletController>().toggleHaveWithdrawAmount(false);
      showCustomSnackBar(
        'insufficient_balance'.tr,
        subMessage: 'please_check_your_withdrawable_balance'.tr,
      );
    }else if(bal < 1 ) {
      showCustomSnackBar("${'minimum_amount'.tr} ${Get.find<SplashController>().config?.currencySymbol?? '\$'} 1");
    }
    else {
      Get.find<WalletController>().updateBalance(balance, note);

    }
  }
}
