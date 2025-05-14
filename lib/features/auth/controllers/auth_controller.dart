import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/common_widgets/snackbar_widget.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/auth/domain/enums/verification_from_enum.dart';
import 'package:ride_sharing_user_app/features/auth/domain/models/signup_body.dart';
import 'package:ride_sharing_user_app/features/auth/domain/services/auth_service_interface.dart';
import 'package:ride_sharing_user_app/features/auth/screens/reset_password_screen.dart';
import 'package:ride_sharing_user_app/features/auth/screens/sign_in_screen.dart';
import 'package:ride_sharing_user_app/features/auth/screens/verification_screen.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/approve_dialog_widget.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/location/screens/access_location_screen.dart';
import 'package:ride_sharing_user_app/features/map/controllers/otp_time_count_Controller.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/controllers/out_of_zone_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/splash/domain/models/config_model.dart';
import 'package:ride_sharing_user_app/helper/country_code_picke.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/pusher_helper.dart';
import 'package:ride_sharing_user_app/util/images.dart';

import '../../profile/screens/profile_screen.dart';



class AuthController extends GetxController implements GetxService {
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface});


  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _isOtpSending = false;
  bool get isLoading => _isLoading;
  bool get acceptTerms => _acceptTerms;
  bool get isOtpSending => _isOtpSending;
  final String _mobileNumber = '';
  String get mobileNumber => _mobileNumber;
  XFile? _pickedProfileFile ;
  XFile? get pickedProfileFile => _pickedProfileFile;
  XFile identityImage = XFile('');
  List<XFile> identityImages = [];
  List<MultipartBody> multipartList = [];
  String countryDialCode = '+20';
  bool isParcelShare = true;
  bool isRideShare = true;

  void setCountryCode(String code){
    countryDialCode = code;
    update();
  }

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController identityNumberController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();

  FocusNode fNameNode = FocusNode();
  FocusNode lNameNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode identityNumberNode = FocusNode();
  FocusNode referralNode = FocusNode();


  void addImageAndRemoveMultiParseData(){
    multipartList.clear();
    identityImages.clear();
    update();
  }

  void updateServiceType(bool ride){
    if(ride){
      isRideShare = !isRideShare;
    }else{
      isParcelShare = !isParcelShare;
    }
    update();
  }

  void pickImage(bool isBack, bool isProfile) async {
       if(isProfile){
        _pickedProfileFile = (await ImagePicker().pickImage(source: ImageSource.gallery))!;
      } else{
         identityImage = (await ImagePicker().pickImage(source: ImageSource.gallery))!;
         identityImages.add(identityImage);
         multipartList.add(MultipartBody('identity_images[]', identityImage));
      }
    update();
  }

  void removeImage(int index){
    identityImages.removeAt(index);
    multipartList.removeAt(index);
    update();
  }

  final List<String> _identityTypeList = ['passport', 'driving_license', 'nid', ];
  List<String> get identityTypeList => _identityTypeList;
  String _identityType = '';
  String get identityType => _identityType;

  void setIdentityType (String setValue){
    _identityType = setValue;
    update();
  }


  Future<void> login(String countryCode, String phone, String password) async {
    _isLoading = true;
    update();
    final String fullPhoneNumber = countryCode + phone;

    Response? response = await authServiceInterface.login( phone: fullPhoneNumber, password: password);

    if(response!.statusCode == 200){
      Map map = response.body;
      String token = '';
      token = map['data']['token'];
      setUserToken(token);
      PusherHelper.initilizePusher();
      updateToken().then((value) {
        Get.find<OutOfZoneController>().getZoneList();
        _navigateLogin(countryCode, phone,password);
      });
      _isLoading = false;
    }else if(response.statusCode == 202){
      if(response.body['data']['is_phone_verified'] == 0){

        final bool isPhoneNotVerified = response.body['data']['is_phone_verified'] == 0;
        final AuthController authController = Get.find<AuthController>();


        if (isPhoneNotVerified) {
          if (Get.find<SplashController>().config?.isFirebaseOtpVerification ?? false) {
            authController.firebaseOtpSend(countryCode: countryCode, number: phone, from: VerificationForm.login);
          } else if(Get.find<SplashController>().config?.isSmsGateway ?? false){
            Get.to(() => VerificationScreen( countryCode:countryCode, number: phone, form: VerificationForm.login));
          }else{
            showCustomSnackBar('sms_gateway_not_integrate'.tr);
          }
        }
      }
    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }


  bool logging = false;
  Future<void> logOut() async {
    logging = true;
    update();
    Response? response = await authServiceInterface.logOut();
    if(response!.statusCode == 200){
      Get.find<RideController>().updateRoute(false, notify: true);
      Get.find<ProfileController>().stopLocationRecord();
      logging = false;
      Get.back();
      Get.offAll(()=> const SignInScreen());

      PusherHelper().pusherDisconnectPusher();

    }else{
      logging = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> permanentDelete() async {
    logging = true;
    update();
    Response? response = await authServiceInterface.permanentDelete();
    if(response!.statusCode == 200){
      Get.find<RideController>().updateRoute(false, notify: true);
      Get.find<ProfileController>().stopLocationRecord();
      logging = false;
      Get.back();
      Get.offAll(()=> const SignInScreen());
      showCustomSnackBar('successfully_delete_account'.tr, isError: false);
    }else{
      logging = false;
      ApiChecker.checkApi(response);
    }
    update();
  }




  Future<void> register(String code, SignUpBody signUpBody) async {
    final ConfigModel? configModel = Get.find<SplashController>().config;

    _isLoading = true;
    update();
    Response? response = await authServiceInterface.registration(signUpBody: signUpBody,profileImage: pickedProfileFile,identityImage: multipartList);
    if(response!.statusCode == 200){
      fNameController.clear();
      lNameController.clear();
      passwordController.clear();
      phoneController.clear();
      confirmPasswordController.clear();
      emailController.clear();
      addressController.clear();
      identityNumberController.clear();
      _pickedProfileFile = null;
      identityImages.clear();
      multipartList.clear();
      referralCodeController.clear();
      _isLoading = false;

      if(configModel?.verification ?? false){
        if (configModel?.isFirebaseOtpVerification ?? false) {
          Get.find<AuthController>().firebaseOtpSend(
            countryCode: code,
            number: signUpBody.phone?.replaceAll(code, '') ?? '',
            from: VerificationForm.login,
          );

        } else if(configModel?.isSmsGateway ?? false){
          Get.to(()=> VerificationScreen(
            countryCode: code,
            number: signUpBody.phone?.replaceAll(code, '') ?? '',
            form: VerificationForm.login,
          ));

        }else{
        showCustomSnackBar('sms_gateway_not_integrate'.tr);
      }

      }else{
        showCustomSnackBar('registration_completed_successfully'.tr, isError: false);
        Get.offAll(()=> const SignInScreen());
      }
      Get.find<ProfileController>().updateFirstTimeShowBottomSheet(true);
    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }


  _navigateLogin(String code,String phone, String password){
    if (_isActiveRememberMe) {
      saveUserCredential(code ,phone, password);
    } else {
      clearUserCredential();
    }
    Get.find<ProfileController>().getProfileInfo().then((value){
      if(value.statusCode == 200){
        if(value.body['data']['vehicle']==null){
          Get.find<ProfileController>().setProfileTypeIndex(2);
 Get.offAll(()=> const ProfileScreen());
        }
       else if(Get.find<AuthController>().getZoneId() == ''){
          Get.offAll(()=> const AccessLocationScreen());
        }else{
          Get.offAll(()=> const DashboardScreen());
        }
        PusherHelper().driverTripRequestSubscribe(value.body['data']['id']);

      }

    });
  }



  Future<Response> sendOtp({required String countryCode,  required String number}) async{
    _isOtpSending = true;
    update();
    Response? response = await authServiceInterface.sendOtp(phone: countryCode+number);
    if(response!.statusCode == 200){
      _isOtpSending = false;
      showCustomSnackBar('otp_sent_successfully'.tr, isError: false);
    }else{
      _isOtpSending = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<void> firebaseOtpSend({required String countryCode, required String number, bool canRoute = true, required VerificationForm from})async {
    _isOtpSending = true;
    update();

    Response? response = await authServiceInterface.isUserRegistered(phone: countryCode + number);
    if(response!.statusCode == 200){
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: countryCode + number,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          _isOtpSending = false;
          update();

          if(e.code == 'invalid-phone-number') {
            showCustomSnackBar('please_submit_a_valid_phone_number'.tr);
          }else{
            showCustomSnackBar(e.message?.replaceAll('_', ' ') ?? '');
          }

        },
        codeSent: (String vId, int? resendToken) {

          _isOtpSending = false;
          update();
          if(canRoute){
            Get.to(() =>  VerificationScreen(countryCode: countryCode, number: number, session: vId, form: from));
          }

        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }else{
      _isOtpSending = false;
      ApiChecker.checkApi(response);
      update();
    }

  }




  Future<Response?> otpVerification(String phoneNumber, String otp,  {String password = '', required VerificationForm from, String? session}) async{
    _isLoading = true;
    update();

    Response? response;
    if(Get.find<SplashController>().config?.isFirebaseOtpVerification ?? false){
      response = await authServiceInterface.verifyFirebaseOtp(phone: phoneNumber, otp: otp,session: session!);
    }else{
      response = await authServiceInterface.verifyOtp(phone: phoneNumber, otp: otp);
    }


    if(response?.statusCode == 200){
      clearVerificationCode();
      _isLoading = false;
      if(from == VerificationForm.signUp){
        showDialog(context: Get.context!, builder: (_)=> ApproveDialogWidget(
            icon: Images.waitForVerification,
            description: 'create_account_approve_description'.tr,
            title: 'registration_not_approve_yet'.tr,
            onYesPressed: (){
              Get.offAll(()=> const SignInScreen());
            }), barrierDismissible: false);
      }else if(from == VerificationForm.login){
        Map map = response?.body;
        String token = '';
        token = map['data']['token'];
        setUserToken(token);
        _isLoading = false;
        updateToken().then((value){
          Get.find<OutOfZoneController>().getZoneList();
         String countryCode = CountryCodeHelper.getCountryCode(phoneNumber) ?? '';
          _navigateLogin(countryCode, phoneNumber.replaceAll(countryCode, ''), password);
        });
      }else{
        Get.to(()=> ResetPasswordScreen(phoneNumber: phoneNumber));
      }
    }else{
      _isLoading = false;
      ApiChecker.checkApi(response!);
    }
    update();
    return response;
  }



  Future<void> forgetPassword(String phone) async {
    _isLoading = true;
    update();
    Response? response = await authServiceInterface.forgetPassword(phone);
    if (response!.statusCode  == 200) {
      _isLoading = false;
      SnackBarWidget('successfully_sent_otp'.tr, isError: false);
    }else{
      _isLoading = false;
      SnackBarWidget('invalid_number'.tr);
    }
    update();
  }


  Future<void> resetPassword(String phone, String password) async {
    _isLoading = true;
    update();
    Response? response = await authServiceInterface.resetPassword(phone, password);
    if (response!.statusCode == 200) {
      SnackBarWidget('password_change_successfully'.tr, isError: false);
      Get.offAll(()=> const SignInScreen());
    }else{
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }


  Future<void> changePassword(String password, String newPassword) async {
    _isLoading = true;
    update();
    Response? response = await authServiceInterface.changePassword(password, newPassword);
    if (response!.statusCode == 200) {
      SnackBarWidget('password_change_successfully'.tr, isError: false);
      Get.offAll(()=> const DashboardScreen());
    }else{
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }




  bool updateFcm = false;
  Future<void> updateToken() async {
    updateFcm = true;
    update();
    Response? response =  await authServiceInterface.updateToken();
    if(response?.statusCode == 200){
      updateFcm = false;
    }else{
      updateFcm = false;
      ApiChecker.checkApi(response!);
    }
    update();
  }



  String _verificationCode = '';
  String _otp = '';
  String get otp => _otp;
  String get verificationCode => _verificationCode;

  void updateVerificationCode(String query) {
    _verificationCode = query;
    if(_verificationCode.isNotEmpty){
      _otp = _verificationCode;
    }
    update();
  }

  void clearVerificationCode({bool isUpdate = true}){
    _otp = '';
    _verificationCode = '';
    if(isUpdate){
      update();
    }
  }


  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  void setRememberMe() {
    _isActiveRememberMe = true;
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  Future<bool> clearSharedData() async{
    return authServiceInterface.clearSharedData();
  }

  void saveUserCredential(String code,String number, String password) {
    authServiceInterface.saveUserCredential(code, number, password);
  }

  String getUserNumber() {
    return authServiceInterface.getUserNumber();
  }

  String getUserCountryCode() {
    return authServiceInterface.getUserCountryCode();
  }

  String getLoginCountryCode() {
    return authServiceInterface.getLoginCountryCode();
  }

  String getUserPassword() {
    return authServiceInterface.getUserPassword();
  }

  bool isNotificationActive() {
    return authServiceInterface.isNotificationActive();
  }

  toggleNotificationSound(){
    authServiceInterface.toggleNotificationSound(!isNotificationActive());
    update();
  }

  Future<bool> clearUserCredential() async {
    return authServiceInterface.clearUserCredentials();
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

  String getDeviceToken() {
    return authServiceInterface.getDeviceToken();
  }

  Future <void> setUserToken(String token) async{
    authServiceInterface.saveUserToken(token, getZoneId());
  }


  Future <void> updateZoneId(String zoneId) async{
    authServiceInterface.updateZone(zoneId);
  }

  String getZoneId() {
    return authServiceInterface.getZonId();
  }

  void saveRideCreatedTime(){
    authServiceInterface.saveRideCreatedTime(DateTime.now());
  }

  void remainingTime() async{
    String time = await authServiceInterface.remainingTime();
    if(time.isNotEmpty){
      DateTime oldTime = DateTime.parse(time);
      DateTime newTime = DateTime.now();
      int diff =  newTime.difference(oldTime).inSeconds;
      Get.find<OtpTimeCountController>().resumeCountingTime(diff);
    }
  }
}