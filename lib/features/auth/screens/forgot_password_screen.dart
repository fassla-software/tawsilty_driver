import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/auth/domain/enums/verification_from_enum.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/screens/verification_screen.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/text_field_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController phoneController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'forget_password'.tr,showBackButton: true, regularAppbar: true,),
      body: GetBuilder<AuthController>(builder: (authController){
        return SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [

                const SizedBox(height: Dimensions.orderStatusIconHeight),
                Column(crossAxisAlignment: CrossAxisAlignment.center, children: [


                    Center(child: Image.asset(Images.forgotPasswordLogo, width: 150,)),
                    const SizedBox(height: Dimensions.paddingSizeLarge,),
                  ],
                ),

                Row(children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Text('forgot_password'.tr,
                      style: textBold.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.fontSizeExtraLarge,)),
                    Text('enter_your_verified_phone_number'.tr,style: textRegular.copyWith(color: Theme.of(context).hintColor),),
                    const SizedBox(height: Dimensions.paddingSizeLarge,)])]),

              TextFieldWidget(
                hintText: 'phone'.tr,
                inputType: TextInputType.number,
                countryDialCode: authController.countryDialCode,
                controller: phoneController,
                onCountryChanged: (CountryCode countryCode){
                  authController.countryDialCode = countryCode.dialCode!;
                  authController.setCountryCode(countryCode.dialCode!);
                  },
              ),

              const SizedBox(height: Dimensions.paddingSizeExtraLarge,),


                authController.isOtpSending?  Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,),):
                ButtonWidget(buttonText: 'send_otp'.tr,
                  onPressed: (){
                    String phoneNumber = phoneController.text;
                    if(phoneNumber.isEmpty){
                      showCustomSnackBar('phone_is_required'.tr);
                    }else{

                      if(Get.find<SplashController>().config?.isFirebaseOtpVerification ?? false){
                        authController.firebaseOtpSend(countryCode:  authController.countryDialCode , number: phoneNumber, from: VerificationForm.reset);

                      }else if(Get.find<SplashController>().config?.isSmsGateway ?? false){
                        authController.sendOtp(countryCode: authController.countryDialCode, number: phoneNumber).then((value) {
                          if(value.statusCode == 200) {
                            Get.to(() =>  VerificationScreen(
                              countryCode: authController.countryDialCode, number:  phoneNumber,
                              form: VerificationForm.reset,
                            ));
                          }
                        });
                      }else{
                        showCustomSnackBar('sms_gateway_not_integrate'.tr);
                      }

                      // authController.sendOtp(countryCode: authController.countryDialCode, phone: phoneNumber).then((value){
                      //   if(value.statusCode == 200){
                      //     Get.to(()=> VerificationScreen(countryCode: authController.countryDialCode, number: phoneNumber, from: 'forget'));
                      //   }
                      // });
                    }
                  }, radius: 50),
              ],
            ),
          ),
        );
      }),
    );
  }
}
