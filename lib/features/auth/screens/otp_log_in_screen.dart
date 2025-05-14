import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/text_field_widget.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/domain/enums/verification_from_enum.dart';
import 'package:ride_sharing_user_app/features/auth/screens/sign_up_screen.dart';
import 'package:ride_sharing_user_app/features/auth/screens/verification_screen.dart';
import 'package:ride_sharing_user_app/features/html/domain/html_enum_types.dart';
import 'package:ride_sharing_user_app/features/html/screens/policy_viewer_screen.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class OtpLoginScreen extends StatefulWidget {
  final bool fromSignIn;
  const OtpLoginScreen({super.key, this.fromSignIn = false});

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  TextEditingController phoneController = TextEditingController();
  FocusNode phoneNode = FocusNode();

  @override
  void initState() {
    super.initState();

    Get.find<AuthController>().countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().config!.countryCode!).dialCode!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: GetBuilder<AuthController>(builder: (authController){
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Center(child: Image.asset(Images.otpScreenLogo, width: 150)),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                    ]),

                  Text('otp_login'.tr,
                    style: textBold.copyWith(
                      color: Theme.of(context).primaryColor,fontSize: Dimensions.fontSizeExtraLarge,
                    ),
                  ),

                  Text(
                    'enter_your_phone_number'.tr,
                    style: textRegular.copyWith(color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  TextFieldWidget(
                    hintText: 'phone'.tr,
                    inputType: TextInputType.number,
                    countryDialCode: authController.countryDialCode,
                    prefixHeight: 70,
                    controller: phoneController,
                    focusNode: phoneNode,
                    inputAction: TextInputAction.done,
                    onCountryChanged: (CountryCode countryCode){
                      authController.countryDialCode = countryCode.dialCode!;
                      authController.setCountryCode(countryCode.dialCode!);
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  authController.isOtpSending ?
                  Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
                  ButtonWidget(
                    buttonText: 'send_otp'.tr,
                    onPressed: () {
                      String phone = phoneController.text.trim();

                      if(phone.isEmpty) {
                        showCustomSnackBar('enter_your_phone_number'.tr);
                        FocusScope.of(context).requestFocus(phoneNode);
                      }else if(!GetUtils.isPhoneNumber(authController.countryDialCode + phone)) {
                        showCustomSnackBar('phone_number_is_not_valid'.tr);
                      }else {

                        if(Get.find<SplashController>().config?.isFirebaseOtpVerification ?? false){
                          authController.firebaseOtpSend(countryCode: authController.countryDialCode , number: phone, from: VerificationForm.login);
                        }else if(Get.find<SplashController>().config?.isSmsGateway ?? false){
                          authController.sendOtp(countryCode:  authController.countryDialCode, number:  phone).then((value) {
                            if(value.statusCode == 200) {
                              Get.to(() =>  VerificationScreen(
                                countryCode: authController.countryDialCode , number: phone,
                                form: widget.fromSignIn ? VerificationForm.login : VerificationForm.signUp,
                              ));
                            }
                          });
                        }else{
                          showCustomSnackBar('sms_gateway_not_integrate'.tr);
                        }

                       // authController.sendOtp(countryCode: authController.countryDialCode,phone:  phone).then((value) {
                       //   if(value.statusCode == 200) {
                       //     Get.to(() =>  VerificationScreen(
                       //         number: phone,
                       //         from: 'login',
                       //       countryCode: authController.countryDialCode,
                       //     ));
                       //   }
                       // });
                      }
                    },
                    radius: 50,
                  ),

                  Row(children: [
                      const Expanded(child: Divider(thickness: .125)),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,vertical: 8),
                        child: Text('or'.tr ,style: textRegular.copyWith(color: Theme.of(context).hintColor)),
                      ),

                      const Expanded(child: Divider(thickness: .125)),
                    ]),

                  ButtonWidget(
                    showBorder: true,
                    borderWidth: 1,
                    transparent: true,
                    buttonText: 'log_in'.tr,
                    onPressed: () => Get.back(),
                    radius: 50,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('${'do_not_have_an_account'.tr} ',
                        style: textMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).hintColor,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Get.off(() => const SignUpScreen());
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50,30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,

                        ),
                        child: Text('sign_up'.tr, style: textMedium.copyWith(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).primaryColor,
                          fontSize: Dimensions.fontSizeSmall,
                        )),
                      )
                    ]),

                  SizedBox(height: MediaQuery.of(context).size.height*0.1),

                  Align(alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: ()=> Get.to(() =>  const PolicyViewerScreen(htmlType: HtmlType.termsAndConditions)),
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Text("terms_and_condition".tr, style: textMedium.copyWith(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).primaryColor,
                          fontSize: Dimensions.fontSizeSmall,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
