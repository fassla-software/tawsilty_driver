import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/auth/domain/models/signup_body.dart';

abstract class AuthServiceInterface {
  Future<dynamic> login({required String phone, required String password});
  Future<dynamic> logOut();
  Future<dynamic> registration({required SignUpBody signUpBody, XFile? profileImage, List<MultipartBody>? identityImage});
  Future<dynamic> sendOtp({required String phone});
  Future<dynamic> verifyOtp({required String phone, required String otp});
  Future<dynamic> verifyFirebaseOtp({required String phone, required String otp, required String session});
  Future<dynamic> resetPassword(String phoneOrEmail, String password);
  Future<dynamic> changePassword(String oldPassword, String password);
  Future<dynamic> updateToken();
  Future<dynamic> forgetPassword(String? phone);
  Future<dynamic> verifyPhone(String phone, String otp);
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
  Future<bool> clearUserCredentials();
  bool clearSharedAddress();
  String getZonId();
  Future<void> updateZone(String zoneId);
  Future<dynamic> permanentDelete();
  Future<dynamic> saveRideCreatedTime(DateTime dateTime);
  Future<dynamic> remainingTime();
  String getLoginCountryCode();
  Future<dynamic> isUserRegistered({required String phone});
}