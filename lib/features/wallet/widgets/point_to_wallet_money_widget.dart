import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class PointToWalletMoneyWidget extends StatefulWidget {
  const PointToWalletMoneyWidget({super.key});

  @override
  State<PointToWalletMoneyWidget> createState() => _PointToWalletMoneyWidgetState();
}

class _PointToWalletMoneyWidgetState extends State<PointToWalletMoneyWidget> {
  int selectedIndex = -1;
  final List<int> _suggestedAmount = [100,200,300,400,500];
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    amountController.text = Get.find<ProfileController>().profileInfo?.loyaltyPoint.toString() ?? '0';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Theme.of(context).cardColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
      child: GetBuilder<WalletController>(builder: (walletController){
        return Container(
          padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(onTap: ()=> Get.back(), child: Container(
                  decoration: BoxDecoration(color: Theme.of(context).hintColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Image.asset(
                    Images.crossIcon,
                    height: Dimensions.paddingSizeSmall,
                    width: Dimensions.paddingSizeSmall,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                )),
              ),

              Padding(
                padding:const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Text('convert_point_to_wallet_money'.tr,
                  style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                ),
              ),

              Padding(padding:const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: Text('${'conversion_rate_is'.tr}: '
                    '${Get.find<SplashController>().config?.conversionRate}pt = '
                    '${Get.find<SplashController>().config?.currencySymbol}1',
                  style: textRobotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),

              IntrinsicWidth(child: TextFormField(
                textAlign: TextAlign.center,
                controller: amountController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                decoration: InputDecoration(
                  prefixStyle: TextStyle(color: Theme.of(context).primaryColor),
                  hintText: 'enter_point'.tr,
                  hintStyle: textRegular.copyWith(
                    color: Theme.of(context).hintColor.withOpacity(.5),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:  BorderSide(width: 0.5,
                          color: Theme.of(context).hintColor.withOpacity(0.0))),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:  BorderSide(width: 0.5,
                        color: Theme.of(context).hintColor.withOpacity(0.0)),
                  ),
                ),
                style: textBold.copyWith(
                  color:(Get.find<ProfileController>().profileInfo?.loyaltyPoint ?? 0) >=
                      _convertDouble(amountController.text) ?
                  Theme.of(context).primaryColor :
                  Theme.of(context).colorScheme.error,
                ),
                onChanged: (String value) {
                  selectedIndex = -1;
                  setState(() {});
                },

              )),

              Divider(color: Theme.of(context).primaryColor.withOpacity(.25)),

              Padding(
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall,
                  bottom: Dimensions.paddingSizeDefault,
                ),
                child: SizedBox(height: 60, child: ListView.builder(itemCount: _suggestedAmount.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (amountContext, index){
                    return GestureDetector(
                      onTap: (){
                        amountController.text = '${_suggestedAmount[index]}';
                        selectedIndex = index;
                        setState(() {});

                      },
                      child: Padding(
                        padding:const EdgeInsets.symmetric(
                          horizontal : Dimensions.paddingSizeExtraSmall,
                          vertical: Dimensions.paddingSizeSmall,
                        ),
                        child: Container(height: Get.height * 0.15,width: Get.width * 0.2,
                          decoration: BoxDecoration(
                            color:index == selectedIndex ? Theme.of(context).primaryColor :
                            Theme.of(context).cardColor, borderRadius: BorderRadius.circular(30),
                            border: Border.all(color:Get.isDarkMode ?
                            Theme.of(context).hintColor.withOpacity(.25) :
                            Theme.of(context).primaryColor.withOpacity(.35),
                            ),
                          ),
                          child: Center(
                            child: Text('${_suggestedAmount[index]}',
                              style: textRegular.copyWith(
                                color: index == selectedIndex ?
                                Colors.white :
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )),
              ),

              Text('${'convertible_amount'.tr}: '
                  '${PriceConverter.convertPrice(context,
                  _convertDouble(amountController.text) /
                      Get.find<SplashController>().config!.conversionRate!)}',
                style: textRobotoRegular,
                textAlign: TextAlign.center,
              ),

              Container(
                padding:const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault,
                  top: Dimensions.paddingSizeExtraLarge,
                ),
                margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSignUp),
                child: walletController.isLoading ?
                SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0) :
                ButtonWidget(buttonText: 'convert_point'.tr,
                  backgroundColor:
                  (Get.find<ProfileController>().profileInfo?.loyaltyPoint ?? 0) >=
                      _convertDouble(amountController.text) ?
                  Theme.of(context).primaryColor :
                  Theme.of(context).hintColor,
                  radius: 10,
                  onPressed: (){
                    String point = amountController.text;
                    if((Get.find<ProfileController>().profileInfo?.loyaltyPoint ?? 0) >= 0){
                      if(point.isEmpty) {
                        showCustomSnackBar('please_input_point'.tr,);
                      }else if(double.parse(point)< Get.find<SplashController>().config!.conversionRate!) {
                        showCustomSnackBar('${'minimum_conversion_point'.tr}: '
                            '${Get.find<SplashController>().config!.conversionRate!}',
                        );
                      }else{
                        walletController.convertPoint(point).then((value) {
                          if(value.statusCode == 200){
                            Get.back();
                            showCustomSnackBar('pont_converted_successfully'.tr, isError: false);
                            Get.find<WalletController>().getLoyaltyPointList(1);
                          }
                        });
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  double _convertDouble(String text){
    try{
      return double.parse(text);
    }catch (e) {
      return 0;
    }
  }
}
