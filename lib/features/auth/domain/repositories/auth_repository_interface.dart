
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/auth/domain/models/signup_body.dart';
import 'package:ride_sharing_user_app/interface/repository_interface.dart';

abstract class AuthRepositoryInterface implements RepositoryInterface{
  Future<Response?> login({required String phone, required String password});
  Future<Response?> logOut();
  Future<Response> registration({required SignUpBody signUpBody, XFile? profileImage, List<MultipartBody>? identityImage});
  Future<Response?> sendOtp({required String phone});
  Future<Response?> verifyOtp({required String phone, required String otp});
  Future<dynamic> verifyFirebaseOtp({required String phone, required String otp, required String session});
  Future<Response?> resetPassword(String phoneOrEmail, String password);
  Future<Response?> changePassword(String oldPassword, String password);
  Future<Response?> updateToken();
  Future<Response?> forgetPassword(String? phone);
  Future<Response?> verifyPhone(String phone, String otp);
  Future<bool?> saveUserToken(String token, String zoneId);
  String getUserToken();
  bool isLoggedIn();
  bool clearSharedData();
  Future<void> saveUserCredential(String code, String number, String password);
  Future<void> saveDeviceToken();
  String getDeviceToken();
  String getUserNumber();
  String getUserCountryCode();
  String getUserPassword();
  bool isNotificationActive();
  toggleNotificationSound(bool isNotification);
  Future<bool> clearUserCredential();
  bool clearSharedAddress();
  String getZonId();
  Future<void> updateZone(String zoneId);
  Future<Response?> permanentDelete();
  Future<void> saveRideCreatedTime(DateTime dateTime);
  Future<String> remainingTime();
  String getLoginCountryCode();
  Future<dynamic> isUserRegistered({required String phone});
}