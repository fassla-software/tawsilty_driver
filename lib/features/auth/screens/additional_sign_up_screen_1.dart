import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/text_field_widget.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/screens/additional_sign_up_screen_2.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/signup_appbar_widget.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/text_field_title_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class AdditionalSignUpScreen1 extends StatelessWidget {
  const AdditionalSignUpScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GetBuilder<AuthController>(builder: (authController){
            return Column(children: [
              const SignUpAppbarWidget(title: 'signup_as_a_driver', progressText: '2_of_3',enableBackButton: true),

              Expanded(child: SingleChildScrollView(
                  child: Column(children: [
                    const SizedBox(height: Dimensions.paddingSizeSignUp),

                    Text('provide_basic_info'.tr,style: textBold.copyWith(color: Theme.of(context).primaryColor,fontSize: 22)),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Text('enter_your_information'.tr, style: textRegular.copyWith(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),fontSize: Dimensions.fontSizeSmall,
                    )),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        TextFieldTitleWidget(title: '${'first_name'.tr}*'),

                        TextFieldWidget(
                          hintText: 'first_name'.tr,
                          capitalization: TextCapitalization.words,
                          inputType: TextInputType.name,
                          prefixIcon: Images.person,
                          controller: authController.fNameController,
                          focusNode: authController.fNameNode,
                          nextFocus: authController.lNameNode,
                          inputAction: TextInputAction.next,
                        ),
                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        TextFieldTitleWidget(title: '${'last_name'.tr}*'),

                        TextFieldWidget(
                          hintText: 'last_name'.tr,
                          capitalization: TextCapitalization.words,
                          inputType: TextInputType.name,
                          prefixIcon: Images.person,
                          controller: authController.lNameController,
                          focusNode: authController.lNameNode,
                          nextFocus: authController.phoneNode,
                          inputAction: TextInputAction.next,
                        ),

                        TextFieldTitleWidget(title: '${'phone'.tr}*'),

                        TextFieldWidget(
                          hintText: 'phone'.tr,
                          inputType: TextInputType.number,
                          countryDialCode: authController.countryDialCode,
                          controller: authController.phoneController,
                          focusNode: authController.phoneNode,
                          nextFocus: authController.passwordNode,
                          inputAction: TextInputAction.next,
                          onCountryChanged: (CountryCode countryCode){
                            authController.countryDialCode = countryCode.dialCode!;
                            authController.setCountryCode(countryCode.dialCode!);
                            FocusScope.of(context).requestFocus(authController.phoneNode);
                          },
                        ),

                        TextFieldTitleWidget(title: '${'password'.tr}*'),

                        TextFieldWidget(
                          hintText: 'password_hint'.tr,
                          inputType: TextInputType.text,
                          prefixIcon: Images.password,
                          isPassword: true,
                          controller: authController.passwordController,
                          focusNode: authController.passwordNode,
                          nextFocus: authController.confirmPasswordNode,
                          inputAction: TextInputAction.next,
                        ),

                        TextFieldTitleWidget(title: '${'confirm_password'.tr}*'),

                        TextFieldWidget(
                          hintText: 'enter_confirm_password'.tr,
                          inputType: TextInputType.text,
                          prefixIcon: Images.password,
                          controller: authController.confirmPasswordController,
                          focusNode: authController.confirmPasswordNode,
                          nextFocus: authController.referralNode,
                          inputAction: TextInputAction.next,
                          isPassword: true,
                        ),

                        if(Get.find<SplashController>().config?.referralEarningStatus ?? false)...[
                          TextFieldTitleWidget(title: 'referral_code'.tr),

                          TextFieldWidget(
                            hintText: 'referral_code'.tr,
                            capitalization: TextCapitalization.words,
                            inputType: TextInputType.text,
                            prefixIcon: Images.referralIcon1,
                            controller: authController.referralCodeController,
                            focusNode: authController.referralNode,
                            inputAction: TextInputAction.done,
                          ),
                        ],

                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    ButtonWidget(
                      margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      radius: Dimensions.radiusExtraLarge,
                      buttonText: 'next'.tr,
                      onPressed: (){
                        String fName = authController.fNameController.text;
                        String lName = authController.lNameController.text;
                        String phone = authController.phoneController.text.trim();
                        String password = authController.passwordController.text;
                        String confirmPassword = authController.confirmPasswordController.text;

                        if(fName.isEmpty){
                          showCustomSnackBar('first_name_is_required'.tr);
                          FocusScope.of(context).requestFocus(authController.fNameNode);
                        }else if(lName.isEmpty){
                          showCustomSnackBar('last_name_is_required'.tr);
                          FocusScope.of(context).requestFocus(authController.lNameNode);
                        }else if(phone.isEmpty){
                          showCustomSnackBar('phone_is_required'.tr);
                          FocusScope.of(context).requestFocus(authController.phoneNode);
                        }else if(!PhoneNumber.parse(authController.countryDialCode + phone).isValid(type: PhoneNumberType.mobile)){
                          showCustomSnackBar('phone_number_is_not_valid'.tr);
                          FocusScope.of(context).requestFocus(authController.phoneNode);
                        }else if(password.isEmpty){
                          showCustomSnackBar('password_is_required'.tr);
                          FocusScope.of(context).requestFocus(authController.passwordNode);
                        }else if(password.length<8){
                          showCustomSnackBar('minimum_password_length_is_8'.tr);
                          FocusScope.of(context).requestFocus(authController.passwordNode);
                        }else if(confirmPassword.isEmpty){
                          showCustomSnackBar('confirm_password_is_required'.tr);
                          FocusScope.of(context).requestFocus(authController.confirmPasswordNode);
                        }else if(password != confirmPassword){
                          showCustomSnackBar('password_is_mismatch'.tr);
                          FocusScope.of(context).requestFocus(authController.confirmPasswordNode);
                        }else{
                          Get.to(()=> const AdditionalSignUpScreen2());

                        }

                        },
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                  ])
              ))

            ]);
          })
      ),
    );
  }
}
