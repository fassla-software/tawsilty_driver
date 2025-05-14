import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ride_sharing_user_app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:ride_sharing_user_app/features/auth/domain/services/auth_service.dart';
import 'package:ride_sharing_user_app/features/auth/domain/services/auth_service_interface.dart';
import 'package:ride_sharing_user_app/features/chat/controllers/chat_controller.dart';
import 'package:ride_sharing_user_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:ride_sharing_user_app/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:ride_sharing_user_app/features/chat/domain/services/chat_service.dart';
import 'package:ride_sharing_user_app/features/chat/domain/services/chat_service_interface.dart';
import 'package:ride_sharing_user_app/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/features/help_and_support/controllers/help_and_support_controller.dart';
import 'package:ride_sharing_user_app/features/help_and_support/domain/repositories/help_and_support_repository.dart';
import 'package:ride_sharing_user_app/features/help_and_support/domain/repositories/help_and_support_repository_interface.dart';
import 'package:ride_sharing_user_app/features/help_and_support/domain/services/help_and_support_service.dart';
import 'package:ride_sharing_user_app/features/help_and_support/domain/services/help_and_support_service_interface.dart';
import 'package:ride_sharing_user_app/features/leaderboard/controllers/leader_board_controller.dart';
import 'package:ride_sharing_user_app/features/leaderboard/domain/repositories/leader_board_repository.dart';
import 'package:ride_sharing_user_app/features/leaderboard/domain/repositories/leader_board_repository_interface.dart';
import 'package:ride_sharing_user_app/features/leaderboard/domain/services/leader_board_service.dart';
import 'package:ride_sharing_user_app/features/leaderboard/domain/services/leader_board_service_interface.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/location/domain/repositories/location_repository.dart';
import 'package:ride_sharing_user_app/features/location/domain/repositories/location_repository_interface.dart';
import 'package:ride_sharing_user_app/features/location/domain/services/location_service.dart';
import 'package:ride_sharing_user_app/features/location/domain/services/location_service_interface.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/otp_time_count_Controller.dart';
import 'package:ride_sharing_user_app/features/notification/controllers/notification_controller.dart';
import 'package:ride_sharing_user_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:ride_sharing_user_app/features/notification/domain/repositories/notification_repository_interface.dart';
import 'package:ride_sharing_user_app/features/notification/domain/services/notification_service.dart';
import 'package:ride_sharing_user_app/features/notification/domain/services/notification_service_interface.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/controllers/out_of_zone_controller.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/domain/repositories/out_of_zone_repository.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/domain/repositories/out_of_zone_repository_interface.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/domain/service/out_of_zone_service.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/domain/service/out_of_zone_service_interface.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:ride_sharing_user_app/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:ride_sharing_user_app/features/profile/domain/services/profile_service.dart';
import 'package:ride_sharing_user_app/features/profile/domain/services/profile_service_interface.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/controllers/refer_and_earn_controller.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/domain/repositories/refer_earn_repository.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/domain/repositories/refer_earn_repository_intertface.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/domain/services/refer_earn_service.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/domain/services/refer_earn_service_interface.dart';
import 'package:ride_sharing_user_app/features/review/controllers/review_controller.dart';
import 'package:ride_sharing_user_app/features/review/domain/repositories/review_repository.dart';
import 'package:ride_sharing_user_app/features/review/domain/repositories/review_repository_interface.dart';
import 'package:ride_sharing_user_app/features/review/domain/services/review_service.dart';
import 'package:ride_sharing_user_app/features/review/domain/services/review_service_interface.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/domain/repositories/ride_repository.dart';
import 'package:ride_sharing_user_app/features/ride/domain/repositories/ride_repository_interface.dart';
import 'package:ride_sharing_user_app/features/ride/domain/services/ride_service.dart';
import 'package:ride_sharing_user_app/features/ride/domain/services/ride_service_interface.dart';
import 'package:ride_sharing_user_app/features/setting/controllers/setting_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/splash/domain/repositories/splash_repository.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/splash/domain/repositories/splash_repository_interface.dart';
import 'package:ride_sharing_user_app/features/splash/domain/services/splash_service.dart';
import 'package:ride_sharing_user_app/features/splash/domain/services/splash_service_interface.dart';
import 'package:ride_sharing_user_app/features/trip/domain/repositories/trip_repository_interface.dart';
import 'package:ride_sharing_user_app/features/trip/domain/services/trip_service.dart';
import 'package:ride_sharing_user_app/features/trip/domain/services/trip_service_interface.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/repositories/wallet_repository_interface.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/services/wallet_service.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/services/wallet_service_interface.dart';
import 'package:ride_sharing_user_app/localization/language_model.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/features/trip/domain/repositories/trip_repository.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));

  //Interface
  SplashRepositoryInterface splashRepositoryInterface = SplashRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => splashRepositoryInterface);
  SplashServiceInterface splashServiceInterface = SplashService(splashRepositoryInterface: Get.find());
  Get.lazyPut(() => splashServiceInterface);

  AuthRepositoryInterface authRepositoryInterface = AuthRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => authRepositoryInterface);
  AuthServiceInterface authServiceInterface = AuthService(authRepositoryInterface: Get.find());
  Get.lazyPut(() => authServiceInterface);

  RideRepositoryInterface rideRepositoryInterface = RideRepository(apiClient: Get.find());
  Get.lazyPut(() => rideRepositoryInterface);
  RideServiceInterface rideServiceInterface = RideService(rideRepositoryInterface: Get.find());
  Get.lazyPut(() => rideServiceInterface);

  ProfileRepositoryInterface profileRepositoryInterface = ProfileRepository(apiClient: Get.find());
  Get.lazyPut(() => profileRepositoryInterface);
  ProfileServiceInterface profileServiceInterface = ProfileService(profileRepositoryInterface: Get.find());
  Get.lazyPut(() => profileServiceInterface);

  ChatRepositoryInterface chatRepositoryInterface = ChatRepository(apiClient: Get.find());
  Get.lazyPut(() => chatRepositoryInterface);
  ChatServiceInterface chatServiceInterface = ChatService(chatRepositoryInterface: Get.find());
  Get.lazyPut(() => chatServiceInterface);

  ReviewRepositoryInterface reviewRepositoryInterface = ReviewRepository(apiClient: Get.find());
  Get.lazyPut(() => reviewRepositoryInterface);
  ReviewServiceInterface reviewServiceInterface = ReviewService(reviewRepositoryInterface: Get.find());
  Get.lazyPut(() => reviewServiceInterface);

  LeaderBoardRepositoryInterface leaderBoardRepositoryInterface = LeaderBoardRepository(apiClient: Get.find());
  Get.lazyPut(() => leaderBoardRepositoryInterface);
  LeaderBoardServiceInterface leaderBoardServiceInterface = LeaderBoardService(leaderBoardRepositoryInterface: Get.find());
  Get.lazyPut(() => leaderBoardServiceInterface);

  WalletRepositoryInterface walletRepositoryInterface = WalletRepository(apiClient: Get.find());
  Get.lazyPut(() => walletRepositoryInterface);
  WalletServiceInterface walletServiceInterface = WalletService(walletRepositoryInterface: Get.find());
  Get.lazyPut(() => walletServiceInterface);

  NotificationRepositoryInterface notificationRepositoryInterface = NotificationRepository(apiClient: Get.find());
  Get.lazyPut(() => notificationRepositoryInterface);
  NotificationServiceInterface notificationServiceInterface = NotificationService(notificationRepositoryInterface: Get.find());
  Get.lazyPut(() => notificationServiceInterface);

  TripRepositoryInterface tripRepositoryInterface = TripRepository(apiClient: Get.find());
  Get.lazyPut(() => tripRepositoryInterface);
  TripServiceInterface tripServiceInterface = TripService(tripRepositoryInterface: Get.find());
  Get.lazyPut(() => tripServiceInterface);

  LocationRepositoryInterface locationRepositoryInterface = LocationRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => locationRepositoryInterface);
  LocationServiceInterface locationServiceInterface = LocationService(locationRepositoryInterface: Get.find());
  Get.lazyPut(() => locationServiceInterface);

  ReferEarnRepositoryInterface referEarnRepositoryInterface = ReferEarnRepository(apiClient: Get.find());
  Get.lazyPut(() => referEarnRepositoryInterface);
  ReferEarnServiceInterface referEarnServiceInterface = ReferEarnService(referEarnRepositoryInterface: Get.find());
  Get.lazyPut(() => referEarnServiceInterface);

  OutOfZoneRepositoryInterface outOfZoneRepositoryInterface = OutOfZoneRepository(apiClient: Get.find());
  Get.lazyPut(() => outOfZoneRepositoryInterface);
  OutOfZoneServiceInterface outOfZoneServiceInterface = OutOfZoneService(outOfZoneRepositoryInterface: Get.find());
  Get.lazyPut(() => outOfZoneServiceInterface);

  HelpAndSupportRepositoryInterface helpAndSupportRepositoryInterface = HelpAndSupportRepository(apiClient: Get.find());
  Get.lazyPut(() => helpAndSupportRepositoryInterface);
  HelpAndSupportServiceInterface helpAndSupportServiceInterface = HelpAndSupportService(helpAndSupportRepositoryInterface: Get.find());
  Get.lazyPut(() => helpAndSupportServiceInterface);



  //Service
  Get.lazyPut(() => SplashService(splashRepositoryInterface: Get.find()));
  Get.lazyPut(() => AuthService(authRepositoryInterface: Get.find()));
  Get.lazyPut(() => RideService(rideRepositoryInterface: Get.find()));
  Get.lazyPut(() => ProfileService(profileRepositoryInterface: Get.find()));
  Get.lazyPut(() => ChatService(chatRepositoryInterface: Get.find()));
  Get.lazyPut(() => ReviewService(reviewRepositoryInterface: Get.find()));
  Get.lazyPut(() => LeaderBoardService(leaderBoardRepositoryInterface: Get.find()));
  Get.lazyPut(() => WalletService(walletRepositoryInterface: Get.find()));
  Get.lazyPut(() => NotificationService(notificationRepositoryInterface: Get.find()));
  Get.lazyPut(() => TripService(tripRepositoryInterface: Get.find()));
  Get.lazyPut(() => LocationService(locationRepositoryInterface: Get.find()));
  Get.lazyPut(() => ReferEarnService(referEarnRepositoryInterface: Get.find()));
  Get.lazyPut(() => OutOfZoneService(outOfZoneRepositoryInterface: Get.find()));
  Get.lazyPut(() => HelpAndSupportService(helpAndSupportRepositoryInterface: Get.find()));







  // Repository
  Get.lazyPut(() => SplashRepository(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => AuthRepository(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => RideRepository(apiClient: Get.find()));
  Get.lazyPut(() => ProfileRepository(apiClient: Get.find()));
  Get.lazyPut(() => ChatRepository(apiClient: Get.find()));
  Get.lazyPut(() => ReviewRepository(apiClient: Get.find()));
  Get.lazyPut(() => LeaderBoardRepository(apiClient: Get.find()));
  Get.lazyPut(() => WalletRepository(apiClient: Get.find()));
  Get.lazyPut(() => NotificationRepository(apiClient: Get.find()));
  Get.lazyPut(() => TripRepository(apiClient: Get.find()));
  Get.lazyPut(() => LocationRepository(sharedPreferences: Get.find(),apiClient: Get.find()));
  Get.lazyPut(() => ReferEarnRepository(apiClient: Get.find()));
  Get.lazyPut(() => OutOfZoneRepository(apiClient: Get.find()));
  Get.lazyPut(() => HelpAndSupportRepository(apiClient: Get.find()));


  // Controller
  Get.lazyPut(() => SplashController(splashServiceInterface: Get.find()));
  Get.lazyPut(() => AuthController(authServiceInterface:  Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => RideController(rideServiceInterface: Get.find()));
  Get.lazyPut(() => ProfileController(profileServiceInterface: Get.find()));
  Get.lazyPut(() => ChatController(chatServiceInterface: Get.find()));
  Get.lazyPut(() => ReviewController(reviewServiceInterface: Get.find()));
  Get.lazyPut(() => LeaderBoardController(leaderBoardServiceInterface: Get.find()));
  Get.lazyPut(() => HelpAndSupportController(helpAndSupportServiceInterface: Get.find()));
  Get.lazyPut(() => WalletController(walletServiceInterface: Get.find()));
  Get.lazyPut(() => NotificationController(notificationServiceInterface: Get.find()));
  Get.lazyPut(() => TripController(tripServiceInterface: Get.find()));
  Get.lazyPut(() => RiderMapController());
  Get.lazyPut(() => BottomMenuController());
  Get.lazyPut(() => SettingController());
  Get.lazyPut(() => LocationController(locationServiceInterface: Get.find()));
  Get.lazyPut(() => OtpTimeCountController());
  Get.lazyPut(() => ReferAndEarnController(referEarnServiceInterface: Get.find()));
  Get.lazyPut(() => OutOfZoneController(outOfZoneServiceInterface: Get.find()));



  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> languageJson = {};
    mappedJson.forEach((key, value) {
      languageJson[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = languageJson;
  }
  return languages;
}
