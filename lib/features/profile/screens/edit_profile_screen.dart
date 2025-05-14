import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_pop_scope_widget.dart';
import 'package:ride_sharing_user_app/helper/country_code_picke.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/email_checker.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/text_field_title_widget.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/profile/domain/models/profile_model.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/text_field_widget.dart';
import 'package:ride_sharing_user_app/util/styles.dart';



class ProfileEditScreen extends StatefulWidget {
  final ProfileInfo profileInfo;
  const ProfileEditScreen({super.key, required this.profileInfo});

  @override
  ProfileEditScreenState createState() => ProfileEditScreenState();
}

class ProfileEditScreenState extends State<ProfileEditScreen>  with TickerProviderStateMixin {
  late String countryDialCode ;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController identityNumberController = TextEditingController();
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  bool isRideShare = true;
  bool isParcelDelivery = true;

  @override
  void initState() {
    firstNameController.text = widget.profileInfo.firstName!;
    lastNameController.text = widget.profileInfo.lastName!;
    emailController.text = widget.profileInfo.email!;
    identityNumberController.text = widget.profileInfo.identificationNumber!;
    if(widget.profileInfo.details!.services != null){
      if(widget.profileInfo.details!.services!.length == 1){
        if(widget.profileInfo.details!.services![0] == 'ride_request'){
          isParcelDelivery = false;
        }else{
          isRideShare = false;
        }
      }
    }
    Get.find<AuthController>().setIdentityType(widget.profileInfo.identificationType!);
    if(Get.find<LocalizationController>().isLtr){
      phoneController.text = widget.profileInfo.phone!;
    }else{
      phoneController.text = '${widget.profileInfo.phone!.substring(1)}+';
    }
    countryDialCode = CountryCodeHelper.getCountryCode(widget.profileInfo.phone)!;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return CustomPopScopeWidget(
      child: Scaffold(resizeToAvoidBottomInset: true,
        appBar: AppBarWidget(title: 'edit_profile'.tr,regularAppbar : true),
        body: GetBuilder<ProfileController>(builder: (profileController){
          return GetBuilder<AuthController>(builder: (authController) {
            return SingleChildScrollView(child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  child: Container(
                    height: 80, width: Get.width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                    ),
                    child: Center(child: InkWell(
                      onTap: ()=> authController.pickImage(false, true),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        clipBehavior: Clip.none, children: [
                        authController.pickedProfileFile == null ?
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: ImageWidget(
                            image: '${Get.find<SplashController>().config!.imageBaseUrl!.profileImage}/${widget.profileInfo.profileImage??''}',
                            height: 76, width: 76, placeholder: Images.personPlaceholder,
                          ),
                        ) :
                        CircleAvatar(
                          backgroundColor: Theme.of(context).hintColor.withOpacity(0.5),
                          radius: 40, backgroundImage:FileImage(File(authController.pickedProfileFile!.path)),
                        ),

                        Positioned(right: 5, bottom: -3,
                          child: Container(
                            decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                            padding: const EdgeInsets.all(5),
                            child: const Icon(Icons.camera_enhance_rounded, color: Colors.white,size: 13),
                          ),
                        ),
                      ],
                      ),
                    )),
                  ),
                ),

                TextFieldTitleWidget(title: 'service'.tr),

                Row(children: [
                  Expanded(
                    child: CheckboxListTile(
                      tileColor: isRideShare ? Theme.of(context).primaryColor.withOpacity(0.05) : null,
                      contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      title: Text('ride_share'.tr,style: textBold.copyWith(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodyMedium!.color
                      )),
                      value: isRideShare,
                      onChanged: (value){
                        isRideShare = value!;
                        setState(() {});
                      },
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall), // Optionally
                        side: BorderSide(
                          color: isRideShare ?
                          Theme.of(context).primaryColor.withOpacity(0.5) :
                          Theme.of(context).hintColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: CheckboxListTile(
                      tileColor: isParcelDelivery ? Theme.of(context).primaryColor.withOpacity(0.05) : null,
                      contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      title: Text('parcel_delivery'.tr,style: textBold.copyWith(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodyMedium!.color
                      )),
                      value: isParcelDelivery,
                      onChanged: (value){
                        isParcelDelivery = value!;
                        setState(() {});
                      },
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall), // Optionally
                        side: BorderSide(
                          color: isParcelDelivery ?
                          Theme.of(context).primaryColor.withOpacity(0.5) :
                          Theme.of(context).hintColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ]),

                TextFieldTitleWidget(title: 'first_name'.tr),

                TextFieldWidget(
                  hintText: 'first_name'.tr,
                  inputType: TextInputType.name,
                  capitalization: TextCapitalization.words,
                  prefixIcon: Images.person,
                  controller: firstNameController,
                  focusNode: firstNameFocus,
                  nextFocus: lastNameFocus,
                  inputAction: TextInputAction.next,
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                TextFieldTitleWidget(title: 'last_name'.tr),

                TextFieldWidget(
                  hintText: 'last_name'.tr,
                  inputType: TextInputType.name,
                  prefixIcon: Images.person,
                  controller: lastNameController,
                  focusNode: lastNameFocus,
                  nextFocus: emailFocus,
                  inputAction: TextInputAction.next,
                ),

                Row(children: [
                  TextFieldTitleWidget(title: 'phone'.tr),

                  Padding(
                    padding:const EdgeInsets.fromLTRB(10,17,0,8),
                    child: Icon(Icons.warning,color: Theme.of(context).colorScheme.primaryContainer,size: 12),
                  ),

                  Padding(
                    padding:const EdgeInsets.fromLTRB(5,17,0,8),
                    child: Text(
                      "phone_number_isn't_editable".tr,
                      style: textRegular.copyWith(
                        color: Theme.of(context).hintColor,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                  )
                ]),

                TextFieldWidget(
                  borderRadius: 50,
                  hintText: 'phone',
                  isEnabled: false,
                  showCountryCode: false,
                  inputType: TextInputType.number,
                  countryDialCode: countryDialCode,
                  controller: phoneController,
                  onCountryChanged: (CountryCode countryCode){
                    countryDialCode = countryCode.dialCode!;
                  },
                ),

                TextFieldTitleWidget(title: 'email'.tr),

                TextFieldWidget(
                  hintText: 'email'.tr,
                  inputType: TextInputType.emailAddress,
                  prefixIcon: Images.email,
                  controller: emailController,
                  focusNode: emailFocus,
                  inputAction: TextInputAction.done,
                ),

                TextFieldTitleWidget(title: 'identity_type'.tr),

                Container(height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7))),
                  child: DropdownButton<String>(
                    hint: authController.identityType == '' ? Text('select_identity_type'.tr,style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)) :
                    Text(authController.identityType.tr, style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)),
                    items: authController.identityTypeList.map((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value.tr,style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color))
                      );
                    }).toList(),
                    onChanged: (val) {
                      authController.setIdentityType(val!);
                    },
                    isExpanded: true,
                    underline: const SizedBox(),
                  ),
                ),




                TextFieldTitleWidget(title: 'identification_number'.tr,),
                TextFieldWidget(
                  hintText: 'Ex: 12345',
                  inputType: TextInputType.text,
                  prefixIcon: Images.identity,
                  controller: identityNumberController,
                  focusNode: authController.identityNumberNode,
                  inputAction: TextInputAction.done,
                ),

                TextFieldTitleWidget(title: 'identity_image'.tr),

                if(profileController.profileInfo?.identificationImage != null &&
                    profileController.profileInfo!.identificationImage!.isNotEmpty )
                  Padding(
                    padding:  const EdgeInsets.fromLTRB(
                      Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, 0,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount : profileController.profileInfo!.identificationImage!.length ,
                      itemBuilder: (BuildContext context, index){
                        return Padding(
                          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                          child: DottedBorder(
                            strokeWidth: 2,
                            dashPattern: const [10,5],
                            color: Theme.of(context).hintColor,
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(Dimensions.paddingSizeSmall),
                            child: Stack(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                child:  SizedBox(
                                  height: MediaQuery.of(context).size.width/4.3,
                                  width: MediaQuery.of(context).size.width,
                                  child: ImageWidget(
                                    image: '${Get.find<SplashController>().config!.imageBaseUrl!.identityImage}/${profileController.profileInfo!.identificationImage![index]}',
                                  ),
                                ),
                              ),

                              Positioned(bottom: 0, right: 0, top: 0, left: 0,
                                child: Container(decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor.withOpacity(0.07),
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                )),
                              ),
                            ]),
                          ),
                        );
                      },
                    ),
                  ),

                if(!profileController.profileInfo!.isOldIdentificationImage!)...[
                  TextFieldTitleWidget(title: 'upload_identity_image'.tr),

                  Padding(
                    padding:  const EdgeInsets.fromLTRB(
                      Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault,
                      Dimensions.paddingSizeDefault,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount : authController.identityImages.length >= 2 ? 2 : authController.identityImages.length + 1,
                      itemBuilder: (BuildContext context, index){
                        return index ==  authController.identityImages.length ?
                        GestureDetector(
                          onTap: ()=> authController.pickImage(false, false),
                          child: Column(children: [
                            DottedBorder(
                              strokeWidth: 2,
                              dashPattern: const [10,5],
                              color: Theme.of(context).hintColor,
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(Dimensions.paddingSizeSmall),
                              child: Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.width/4.3,
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.asset(Images.cameraPlaceholder, scale: 3),
                                  ),
                                ),

                                Positioned(bottom: 0, right: 0, top: 0, left: 0,
                                  child: Container(decoration: BoxDecoration(
                                    color: Theme.of(context).hintColor.withOpacity(0.07),
                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                  )),
                                ),
                              ]),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                          ]),
                        ) :
                        Column(children: [
                          Stack(children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                                  child: Image.file(
                                    File(authController.identityImages[index].path),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width/4.3,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            Positioned(top:0,right:0,
                              child: InkWell(
                                onTap :() => authController.removeImage(index),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(Icons.delete_forever_rounded,color: Colors.red,size: 15),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                        ]);
                      },
                    ),
                  )
                ],

                if(profileController.profileInfo!.isOldIdentificationImage!)
                  Container(
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ?
                      Colors.white.withOpacity(0.75) : Colors.black.withOpacity(0.75),
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        Image.asset(Images.alertIcon,height: 20,width: 20),
                        const SizedBox(width: 5),

                        Expanded(child: Text(
                          'please_wait_admin_approval_for_identity_info'.tr,
                          style: textMedium.copyWith(color: Theme.of(context).cardColor,fontSize: Dimensions.fontSizeSmall),
                        )),
                      ]),
                    ),
                  )
              ],
              ),
            ));
          });
        }),
        bottomNavigationBar: GetBuilder<ProfileController>(builder: (profileController) {
          return SizedBox(
            height: 70,
            child:  profileController.isLoading ?
            Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(blurRadius: 5, spreadRadius: 5,
                        color: Theme.of(context).hintColor.withOpacity(.125),
                        offset: const Offset(1,0)
                    )
                  ]
              ),
              child: ButtonWidget(
                buttonText: 'submit'.tr,
                onPressed: (){
                  List<String> services = [];
                  String email = emailController.text;
                  String fName = firstNameController.text;
                  String lName = lastNameController.text;
                  if(isRideShare){
                    services.add('ride_request');
                  }
                  if(isParcelDelivery){
                    services.add('parcel');
                  }
                  if(fName.isEmpty){
                    showCustomSnackBar('first_name_is_required'.tr);
                  }else if(lName.isEmpty){
                    showCustomSnackBar('last_name_is_required'.tr);
                  }else if(EmailChecker.isNotValid(email)){
                    showCustomSnackBar('enter_valid_email_address'.tr);
                  }else if(identityNumberController.text.isEmpty){
                    showCustomSnackBar('identity_number_is_required'.tr);
                  }else if(!isRideShare && !isParcelDelivery){
                    showCustomSnackBar('required_to_select_service'.tr);
                  }else{
                    profileController.updateProfile(
                        fName, lName, email,
                        identityNumberController.text,
                        services
                    );
                  }
                },
                radius: 5,
              ),
            ),
          );
        }),
      ),
    );
  }
}
