import 'package:ride_sharing_user_app/localization/language_model.dart';
import 'package:ride_sharing_user_app/util/images.dart';

class AppConstants {
  static const String appName = 'Drivo Driver';
  static const String baseUrl =
      'https://tawselty.com'; /* 'https://drivemond-admin.codemond.com'; */
  static const String polylineMapKey =
      'AIzaSyCHj3QwVPXAcG57hgUCowCRtbc4moArVH0';
  /* 'AIzaSyCGSZyU5GjFtJuay5jjqRD-xIr3XhGu1Ek'; */
  //AIzaSyA8Qy5ipfdKm01zA3pDc-bK1ypII3tAKTI
  static const double appVersion = 2.1;

  /// Flutter SDK 3.24.0
  static const String configUri = '/api/driver/configuration';
  static const String registration = '/api/driver/auth/registration';
  static const String loginUri = '/api/driver/auth/login';
  static const String logout = '/api/user/logout';
  static const String permanentDelete = '/api/user/delete';
  static const String sendOtp = '/api/driver/auth/send-otp';
  static const String otpVerification = '/api/driver/auth/otp-verification';
  static const String resetPassword = '/api/driver/auth/reset-password';
  static const String changePassword = '/api/user/change-password';
  static const String onlineOfflineStatus = '/api/driver/update-online-status';
  static const String profileInfo = '/api/driver/info';
  static const String updateProfileInfo = '/api/driver/update/profile';
  static const String vehicleBrandList =
      '/api/driver/vehicle/brand/list?offset=';
  static const String vehicleModelList =
      '/api/driver/vehicle/models/list?offset=';
  static const String vehicleMainCategory =
      '/api/driver/vehicle/category/list?offset=';
  static const String addNewVehicle = '/api/driver/vehicle/store';
  static const String geoCodeURI = '/api/driver/config/geocode-api';
  static const String getZone = '/api/driver/config/get-zone-id';
  static const String fcmTokenUpdate = '/api/driver/update/fcm-token';
  static const String tripDetails = '/api/driver/ride/details/';
  static const String uploadScreenShots = '/api/ride/store-screenshot';
  static const String tripAcceptOrReject = '/api/driver/ride/trip-action';
  static const String matchOtp = '/api/driver/ride/match-otp';
  static const String remainDistance = '/api/driver/get-routes';
  static const String tripStatusUpdate = '/api/driver/ride/update-status';
  static const String rideRequestList = '/api/driver/ride/pending-ride-list';
  static const String activityList = '/api/driver/my-activity';
  static const String bidding = '/api/driver/ride/bid';
  static const String ongoingTrip = '/api/driver/last-ride-details';
  static const String finalFare = '/api/driver/ride/final-fare';
  static const String currentRideStatus = '/api/driver/ride/ride-resume-status';
  static const String submitReview = '/api/driver/review/store';
  static const String tripList = '/api/driver/ride/list';
  static const String tripOverView = '/api/driver/ride/overview';
  static const String paymentUri = '/api/driver/ride/payment';
  static const String searchLocationUri =
      '/api/customer/config/place-api-autocomplete';
  static const String getDistanceFromLatLng =
      '/api/customer/config/distance_api';
  static const String placeApiDetails =
      '/api/customer/config/place-api-details';
  static const String createChannel = '/api/driver/chat/create-channel';
  static const String channelList = '/api/driver/chat/channel-list';
  static const String conversationList = '/api/driver/chat/conversation';
  static const String sendMessage = '/api/driver/chat/send-message';
  static const String notificationList =
      '/api/driver/notification-list?limit=10&offset=';
  static const String arrivalPickupPoint = '/api/driver/ride/arrival-time';
  static const String waitingUri = '/api/driver/ride/ride-waiting';
  static const String transactionListUri =
      '/api/driver/transaction/list?limit=10&offset=';
  static const String loyaltyPointListUri =
      '/api/driver/loyalty-points/list?limit=10&offset=';
  static const String reviewList = '/api/driver/review/list?limit=10&offset=';
  static const String saveReview = '/api/driver/review/save/';
  static const String pointConvert = '/api/driver/loyalty-points/convert';
  static const String leaderboardUri = '/api/driver/activity/leaderboard?';
  static const String dynamicWithdrawMethodList =
      '/api/driver/withdraw/methods?limit=20&offset=1';
  static const String withdrawRequestUri = '/api/driver/withdraw/request';
  static const String dailyActivities = '/api/driver/activity/daily-income';
  static const String trackDriverLog = '/api/driver/time-tracking';
  static const String updateLastLocationUsingSocket =
      '/user/live-location?appKey';
  static const String storeLastLocationAPI = '/api/user/store-live-location';
  static const String ignoreNotification =
      '/api/driver/ride/ignore-trip-notification';
  static const String arrivedDestination =
      '/api/driver/ride/coordinate-arrival';
  static const String findChannelRideStatus = '/api/driver/chat/find-channel';
  static const String rideCancellationReasonList =
      '/api/driver/config/cancellation-reason-list';
  static const String parcelOngoingList =
      '/api/driver/ride/ongoing-parcel-list?limit=100&offset=1';
  static const String parcelUnpaidList =
      '/api/driver/ride/unpaid-parcel-list?limit=100&offset=1';
  static const String changeLanguage = '/api/driver/change-language';
  static const String getProfileLevel = '/api/driver/level';
  static const String getWithdrawMethodInfoList =
      '/api/driver/withdraw-method-info/list?limit=10&offset=';
  static const String withdrawMethodCreate =
      '/api/driver/withdraw-method-info/create';
  static const String withdrawMethodUpdate =
      '/api/driver/withdraw-method-info/update/';
  static const String incomeStatementUri =
      '/api/driver/income-statement?limit=10&offset=';
  static const String payableListUri =
      '/api/driver/transaction/payable-list?limit=10&offset=';
  static const String withdrawPendingListUri =
      '/api/driver/withdraw/pending-request?limit=10&offset=';
  static const String withdrawSettledListUri =
      '/api/driver/withdraw/settled-request?limit=10&offset=';
  static const String cashCollectHistoryList =
      '/api/driver/transaction/cash-collect-list?limit=10&offset=';
  static const String walletListUri =
      '/api/driver/transaction/wallet-list?limit=10&offset=';
  static const String withdrawMethodDelete =
      '/api/driver/withdraw-method-info/delete/';
  static const String updateVehicle = '/api/driver/vehicle/update/';
  static const String referralDetails = '/api/driver/referral-details';
  static const String referralEarningList =
      '/api/driver/transaction/referral-earning-list?limit=10&offset=';
  static const String parcelCancellationReasonList =
      '/api/driver/config/parcel-cancellation-reason-list';
  static const String parcelCancellationOtp =
      '/api/driver/ride/returned-parcel';
  static const String parcelResendOtp = '/api/driver/ride/resend-otp';
  static const String getZoneList = '/api/driver/zone/list';
  static const String otpFirebaseVerification =
      '/api/driver/auth/firebase-otp-verification';
  static const String checkRegisteredUserUri = '/api/driver/auth/check';
  static const String createChannelWithAdmin =
      '/api/driver/chat/create-channel-with-admin';
  static const String sendMessageToAdmin =
      '/api/driver/chat/send-message-to-admin';
  static const String sendFaqMessageToAdmin =
      '/api/driver/chat/send-predefined-question-to-admin';
  static const String predefineFawQuestionList =
      '/api/driver/config/predefined-question-answer-list';

  // Shared Key
  static const String theme = 'theme';
  static const String token = 'token';
  static const String deviceToken = 'deviceToken';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String haveOngoingRides = 'have_ongoing_rides';
  static const String cartList = 'cart_list';
  static const String userPassword = 'user_password';
  static const String userAddress = 'user_address';
  static const String userNumber = 'user_number';
  static const String loginCountryCode = 'login_country_code';
  static const String searchAddress = 'search_address';
  static const String localization = 'X-Localization';
  static const String topic = 'notify';
  static const String zoneId = 'zoneId';
  static const String lastRefund = 'refund';

  static List<LanguageModel> languages = [
    LanguageModel(
      imageUrl: Images.unitedKingdom,
      languageName: 'English',
      countryCode: 'US',
      languageCode: 'en',
    ),
    LanguageModel(
      imageUrl: Images.saudi,
      languageName: 'عربي',
      countryCode: 'SA',
      languageCode: 'ar',
    ),
  ];

  static const int limitOfPickedIdentityImageNumber = 2;
  static const double limitOfPickedImageSizeInMB = 2;
  static const double completionArea = 500;
  static const double otpShownArea = 500;
  static const int balanceInputLen = 10;

  ///map zoom
  static const double mapZoom = 20;
}
