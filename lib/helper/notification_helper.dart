import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:ride_sharing_user_app/features/chat/controllers/chat_controller.dart';
import 'package:ride_sharing_user_app/features/chat/screens/message_screen.dart';
import 'package:ride_sharing_user_app/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/features/help_and_support/controllers/help_and_support_controller.dart';
import 'package:ride_sharing_user_app/features/home/screens/ongoing_parcel_list_screen.dart';
import 'package:ride_sharing_user_app/features/home/widgets/refund_alert_bottomsheet.dart';
import 'package:ride_sharing_user_app/features/html/domain/html_enum_types.dart';
import 'package:ride_sharing_user_app/features/html/screens/policy_viewer_screen.dart';
import 'package:ride_sharing_user_app/features/profile/screens/edit_profile_screen.dart';
import 'package:ride_sharing_user_app/features/profile/screens/profile_screen.dart';
import 'package:ride_sharing_user_app/features/profile/widgets/level_congratulations_dialog_widget.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/controllers/refer_and_earn_controller.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/screens/refer_and_earn_screen.dart';
import 'package:ride_sharing_user_app/features/review/screens/review_screen.dart';
import 'package:ride_sharing_user_app/features/trip/screens/trip_details_screen.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/screens/map_screen.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/trip/screens/payment_received_screen.dart';
import 'package:ride_sharing_user_app/features/trip/screens/review_this_customer_screen.dart';

class NotificationHelper {
  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    AndroidInitializationSettings androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (kDebugMode) {
          print('Notification response ==> ${response.payload.toString()}');
        }
        // TODO: Route
        try {
          if (response.payload != null && response.payload!.isNotEmpty) {
            if (kDebugMode) {
              print('Notification response ==> ${response.payload.toString()}');
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('Notification response ==> ${response.payload.toString()}');
          }
        }
        return;
      },

      onDidReceiveBackgroundNotificationResponse: myBackgroundMessageReceiver,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AndroidInitializationSettings androidInitialize = const AndroidInitializationSettings('notification_icon');
      var iOSInitialize = const DarwinInitializationSettings();
      var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
      flutterLocalNotificationsPlugin.initialize(
        initializationsSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          notificationToRoute(message.data);
          return;
        },

        onDidReceiveBackgroundNotificationResponse: myBackgroundMessageReceiver,

      );

      /// Show log for debug
      print('onMessage: ${message.data}');


      /// check maintenance mode
      if(!(Get.find<SplashController>().config!.maintenanceMode != null &&
          Get.find<SplashController>().config!.maintenanceMode!.maintenanceStatus == 1 &&
          Get.find<SplashController>().config!.maintenanceMode!.selectedMaintenanceSystem!.driverApp == 1) || Get.find<SplashController>().haveOngoingRides()){

        ///Check webSocket connection
        if (Get.find<SplashController>().pusherConnectionStatus == null || Get.find<SplashController>().pusherConnectionStatus == 'Disconnected') {
          if (message.data['action'] == "new_ride_request_notification") {
            Get.find<RideController>().getPendingRideRequestList(1);
            AudioPlayer audio = AudioPlayer();
            audio.play(AssetSource('notification.wav'));
            Get.find<RideController>().setRideId(message.data['ride_request_id']);
            Get.find<RideController>().getRideDetailBeforeAccept(message.data['ride_request_id']).then((value) {
              if (value.statusCode == 200) {
                Get.find<RiderMapController>().getPickupToDestinationPolyline();
                Get.find<RiderMapController>().setRideCurrentState(RideState.pending);
                Get.find<RideController>().updateRoute(false, notify: true);
                Get.to(() => const MapScreen());
              }
            });

          } else if(message.data['action'] == "new_message_arrived"){
            Get.find<ChatController>().getConversation(message.data['type'], 1);

          } else if (message.data['action'] == "ride_completed") {
            Get.find<RideController>().getRideDetails(message.data['ride_request_id']).then((value) {
              if (value.statusCode == 200) {
                Get.find<RideController>().getFinalFare(message.data['ride_request_id']).then((value) {
                  if (value.statusCode == 200) {
                    Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                    Get.to(() => const PaymentReceivedScreen());
                  }
                });
              }
            });

          } else if (message.data['action'] == "ride_accepted") {
            ///Bid Ride Accepted in this case....
            Get.find<RideController>().getRideDetails(message.data['ride_request_id']).then((value) {
              if (value.statusCode == 200) {
                Get.find<RiderMapController>().setRideCurrentState(RideState.accepted);
                Get.find<RideController>().updateRoute(false, notify: true);
                Get.to(() => const MapScreen());
              }
            });

          } else if (message.data['action'] == "coupon_removed" || message.data['action'] == "coupon_applied") {
            Get.find<RideController>().getFinalFare(message.data['ride_request_id']);

          } else if (message.data['action'] == "payment_successful" && message.data['type'] == "ride_request") {
            Get.find<RideController>().getRideDetails(message.data['ride_request_id']).then((value) {
              if (value.statusCode == 200) {
                if (Get.find<SplashController>().config!.reviewStatus!) {
                  Get.offAll(() => ReviewThisCustomerScreen(tripId: message.data['ride_request_id']));
                } else {
                  Get.offAll(() => const DashboardScreen());
                }
              }
            });

          } else if (message.data['action'] == "payment_successful" && message.data['type'] == "parcel") {
            Get.find<RideController>().getRideDetails(message.data['ride_request_id']).then((value) {
              if (value.statusCode == 200) {
                Get.find<RideController>().getOngoingParcelList();
                Get.offAll(()=> OngoingParcelListScreen(title: 'ongoing_parcel_list'.tr));

              }
            });

          } else if (message.data['action'] == "ride_cancelled" || message.data['action'] == "ride_started") {
            Get.find<RideController>().getPendingRideRequestList(1).then((value) {
              if (value.statusCode == 200) {
                Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                Get.offAll(() => const DashboardScreen());
              }
            });

          } else if (message.data['action'] == "vehicle_approved") {
            Get.find<ProfileController>().getProfileInfo().then((value) {
              if (value.statusCode == 200) {
                Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                Get.offAll(() => const DashboardScreen());
              }
            });

          }else if(message.data['action'] == "bid_rejected"){
            Get.offAll(() => const DashboardScreen());

          }else if(message.data['action'] == 'identity_image_approved' || message.data['action'] == 'identity_image_rejected'){
            Get.find<ProfileController>().getProfileInfo();

          }else if(message.data['action'] == 'level_completed'){
            Get.find<ProfileController>().getProfileLevelInfo();
            showDialog(
              context: Get.context!,
              barrierDismissible: false,
              builder: (_) => LevelCongratulationsDialogWidget(
                levelName: message.data['next_level'],
                rewardType: message.data['reward_type'],
                reward: message.data['reward_amount'],
              ),
            );

          }else if(message.data['action'] == "withdraw_rejected" || message.data['action'] == "withdraw_approved"){
            Get.find<ProfileController>().getProfileInfo();
            Get.find<WalletController>().getWithdrawPendingList(1);

          }else if(message.data['action'] == "withdraw_settled"){
            Get.find<ProfileController>().getProfileInfo();
            Get.find<WalletController>().getWithdrawSettledList(1);

          }else if(message.data['action'] == "cash_collected"){
            Get.find<ProfileController>().getProfileInfo();
            Get.find<WalletController>().getPayableHistoryList(1);

          }else if(message.data['action'] == 'parcel_returned'){
            if(Get.isDialogOpen ?? false){
              Get.back();
            }
            Get.find<RideController>().getOngoingParcelList();
            Get.find<RideController>().getRideDetails(message.data['ride_request_id']);

          }else if(message.data['action'] == 'parcel_cancelled'){
            Get.offAll(const DashboardScreen());

          }else if(message.data['action'] == 'referral_reward_received'){
            Get.find<ReferAndEarnController>().getEarningHistoryList(1);
            Get.find<ProfileController>().getProfileInfo();

          }else if(message.data['action'] == 'admin_message'){
            Get.find<HelpAndSupportController>().getConversation(message.data['type'], 1);

          }

          ///If web socket Not connected
        } else {
          if (message.data['action'] == "ride_accepted") {
            ///Bid Ride Accepted in this case....
            Get.find<RideController>().getRideDetails(message.data['ride_request_id']).then((value) {
              if (value.statusCode == 200) {
                Get.find<RiderMapController>().setRideCurrentState(RideState.accepted);
                Get.find<RideController>().updateRoute(false, notify: true);
                Get.to(() => const MapScreen());
              }
            });

          } else if (message.data['action'] == "vehicle_approved") {
            Get.find<ProfileController>().getProfileInfo().then((value) {
              if (value.statusCode == 200) {
                Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                Get.offAll(() => const DashboardScreen());
              }
            });

          }else if(message.data['action'] == "bid_rejected"){
            Get.offAll(() => const DashboardScreen());

          }else if(message.data['action'] == 'identity_image_approved' || message.data['action'] == 'identity_image_rejected'){
            Get.find<ProfileController>().getProfileInfo();

          }else if(message.data['action'] == 'level_completed'){
            Get.find<ProfileController>().getProfileLevelInfo();
            showDialog(
              context: Get.context!,
              barrierDismissible: false,
              builder: (_) => LevelCongratulationsDialogWidget(
                levelName: message.data['next_level'],
                rewardType: message.data['reward_type'],
                reward: message.data['reward_amount'],
              ),
            );

          }else if(message.data['action'] == "withdraw_rejected" || message.data['action'] == "withdraw_approved"){
            Get.find<ProfileController>().getProfileInfo();
            Get.find<WalletController>().getWithdrawPendingList(1);

          }else if(message.data['action'] == "withdraw_settled"){
            Get.find<ProfileController>().getProfileInfo();
            Get.find<WalletController>().getWithdrawSettledList(1);

          }else if(message.data['action'] == "cash_collected"){
            Get.find<ProfileController>().getProfileInfo();
            Get.find<WalletController>().getPayableHistoryList(1);

          }else if(message.data['action'] == 'parcel_returned'){
            if(Get.isDialogOpen ?? false){
              Get.back();
            }
            Get.find<RideController>().getOngoingParcelList();
            Get.find<RideController>().getRideDetails(message.data['ride_request_id']);

          }else if(message.data['action'] == 'parcel_cancelled'){
            Get.offAll(const DashboardScreen());

          }else if(message.data['action'] == 'referral_reward_received'){
            Get.find<ReferAndEarnController>().getEarningHistoryList(1);
            Get.find<ProfileController>().getProfileInfo();

          }else if(message.data['action'] == 'admin_message'){
            Get.find<HelpAndSupportController>().getConversation(message.data['type'], 1);

          }

        }

        ///checking which notification are not shown.
        if(!(message.data['action'] == "ride_cancelled" || message.data['action'] == "ride_started" || message.data['type'] == 'maintenance_mode_on' || message.data['type'] == 'maintenance_mode_off')){
          if(message.data['status'] == '1'){
            NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, true);
          }

        }
      }

      if(message.data['type'] == 'maintenance_mode_on' || message.data['type'] == 'maintenance_mode_off'){
        Get.find<SplashController>().getConfigData(reload: false);
      }

      if(message.data['action'] == 'parcel_refund_request') {
        final RideController rideController = Get.find<RideController>();
        bool isShowBottomSheet =  (rideController.getOnGoingRideCount() == 0) && ((rideController.parcelListModel?.totalSize ?? 0) == 0 );

        if(isShowBottomSheet) {
          showModalBottomSheet(context: Get.context!, builder: (ctx)=> RefundAlertBottomSheet(
            title: message.data['title'],
            description: message.data['body'],
            tripId: message.data['ride_request_id'],
          ));
        }else {
          /// Add the refund data to show dialog after complete ongoing ride
          Get.find<SplashController>().addLastReFoundData(message.data);
        }

      }

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      customPrint('onOpenApp: ${message.data}');
      notificationToRoute(message.data);

    });
  }

  static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln, bool data) async {
    String title = message.data['title'];
    String body = message.data['body'];
    String? orderID = message.data['order_id'];
    String? image = (message.data['image'] != null && message.data['image'].isNotEmpty) ?
    message.data['image'].startsWith('http') ?
    message.data['image'] :
    '${AppConstants.baseUrl}/storage/app/public/notification/${message.data['image']}' :
    null;

    try {
      await showBigPictureNotificationHiddenLargeIcon(title, body, orderID, image, fln);
    } catch (e) {
      await showBigPictureNotificationHiddenLargeIcon(title, body, orderID, null, fln);
      customPrint('Failed to show notification: ${e.toString()}');
    }
  }

  static Future<void> showTextNotification(String title, String body, String orderID, String action, FlutterLocalNotificationsPlugin fln) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'hexaride',
      'hexaride',
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: action);
  }

  static Future<void> showBigTextNotification(String title, String body, String orderID, String action, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body,
      htmlFormatBigText: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'hexaride',
      'hexaride',
      importance: Importance.max,
      styleInformation: bigTextStyleInformation,
      priority: Priority.max,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: action);
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(
      String title, String body, String? orderID, String? image, FlutterLocalNotificationsPlugin fln) async {
    String? largeIconPath;
    String? bigPicturePath;
    BigPictureStyleInformation? bigPictureStyleInformation;
    BigTextStyleInformation? bigTextStyleInformation;
    if (image != null && !GetPlatform.isWeb) {
      largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
      bigPicturePath = largeIconPath;
      bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        hideExpandedLargeIcon: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: body,
        htmlFormatSummaryText: true,
      );

    }
    else {
      bigTextStyleInformation = BigTextStyleInformation(
        body,
        htmlFormatBigText: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
      );

    }
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'hexaride',
      'hexaride',
      priority: Priority.max,
      importance: Importance.max,
      playSound: true,
      largeIcon: largeIconPath != null ? FilePathAndroidBitmap(largeIconPath) : null,
      styleInformation: largeIconPath != null ? bigPictureStyleInformation : bigTextStyleInformation,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static Future<void> notificationToRoute(Map<String,dynamic> data, {bool formSplash = false, String? userName}) async {
    if (data['action'] == "new_message_arrived") {
      Get.find<ChatController>().getConversation(data['type'], 1);
      _toRoute(formSplash, MessageScreen(channelId: data['type'], tripId: data['ride_request_id'], userName: userName ?? data['user_name']));

    }
    else if (data['action'] == "new_ride_request_notification") {
      Get.find<RideController>().getPendingRideRequestList(1);
      Get.find<RideController>().setRideId(data['ride_request_id']);
      Get.find<RideController>().getRideDetailBeforeAccept(data['ride_request_id']).then((value) {
        if (value.statusCode == 200) {
          Get.find<RiderMapController>().getPickupToDestinationPolyline();
          Get.find<RiderMapController>().setRideCurrentState(RideState.pending);
          Get.find<RideController>().updateRoute(false, notify: true);
          _toRoute(formSplash, const MapScreen());

        }
      });

    }
    else if (data['action'] == "ride_accepted") {
      ///Bid Ride Accepted in this case....
      Get.find<RideController>().getRideDetails(data['ride_request_id']).then((value) {
        if (value.statusCode == 200) {
          Get.find<RiderMapController>().setRideCurrentState(RideState.accepted);
          Get.find<RideController>().updateRoute(false, notify: true);
          _toRoute(formSplash, const MapScreen());
        }
      });
    }
    else if (data['action'] == "payment_successful" && data['type'] == "ride_request") {
      Get.offAll(() => const DashboardScreen());
      Get.find<BottomMenuController>().setTabIndex(3);

    }
    else if (data['action'] == "payment_successful" && data['type'] == "parcel") {
      Get.offAll(() => const DashboardScreen());
      Get.find<BottomMenuController>().setTabIndex(3);

    }
    else if (data['action'] == "ride_cancelled" || data['action'] == "ride_started") {
      Get.find<RideController>().getPendingRideRequestList(1).then((value) {
        if (value.statusCode == 200) {
          Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
          Get.offAll(() => const DashboardScreen());
        }
      });

    }
    else if (data['action'] == "vehicle_approved") {
      Get.find<ProfileController>().getProfileInfo().then((value) {
        if (value.statusCode == 200) {
          Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
          Get.find<ProfileController>().setProfileTypeIndex(2);
          _toRoute(formSplash, const ProfileScreen());

        }
      });

    }
    else if(data['action'] == "withdraw_rejected" ||
        data['action'] == "withdraw_approved" ||
        data['action'] == "cash_collected" || data['action'] == "withdraw_reversed") {
      Get.offAll(() => const DashboardScreen());
      Get.find<BottomMenuController>().setTabIndex(3);

    }
    else if(data['action'] == "withdraw_settled") {
      Get.offAll(() => const DashboardScreen());
      Get.find<BottomMenuController>().setTabIndex(3);
      Get.find<WalletController>().setSelectedHistoryIndex(1, true);

    }
    else if(data['action'] == "bid_rejected"){
      Get.offAll(() => const DashboardScreen());

    }
    else if(data['action'] == "review_submit"){
      _toRoute(formSplash, const ReviewScreen());

    }
    else if(data['action'] == 'identity_image_approved' || data['action'] == 'identity_image_rejected'){
      Get.find<ProfileController>().getProfileInfo().then((value) {
        _toRoute(formSplash, ProfileEditScreen(profileInfo: Get.find<ProfileController>().profileInfo!));
      });

    }
    else if(data['action'] == 'level_completed'){

      Get.find<ProfileController>().getProfileLevelInfo();

      if(formSplash) {
        _toRoute(formSplash, const DashboardScreen());
      }

      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (_) => LevelCongratulationsDialogWidget(
          levelName: data['next_level'],
          rewardType: data['reward_type'],
          reward: data['reward_amount'],
        ),
      );

    }
    else if(data['action'] == 'privacy_policy_page_updated'){
      Get.find<SplashController>().getConfigData().then((value){
        _toRoute(formSplash, PolicyViewerScreen(
          htmlType: HtmlType.privacyPolicy,
          image: Get.find<SplashController>().config?.privacyPolicy?.image??'',
        ));
      });

    }
    else if(data['action'] == 'legal_page_updated'){
      Get.find<SplashController>().getConfigData().then((value){
        _toRoute(formSplash, PolicyViewerScreen(
            htmlType: HtmlType.legal,
            image: Get.find<SplashController>().config?.legal?.image??''
        ));
      });

    }
    else if(data['action'] == 'terms_and_conditions_page_updated'){
      Get.find<SplashController>().getConfigData().then((value){
        _toRoute(formSplash, PolicyViewerScreen(htmlType: HtmlType.termsAndConditions,
            image: Get.find<SplashController>().config?.termsAndConditions?.image??''
        ));
      });

    }
    else if(data['action'] == 'referral_reward_received'){
      _toRoute(formSplash, const ReferAndEarnScreen());
    }
    else if(data['action'] == 'parcel_refund_request'){
      _toRoute(formSplash, TripDetails(tripId: data['ride_request_id']));
    }
    else if(data['action'] == 'parcel_refund_request_approved'){
      _toRoute(formSplash, TripDetails(tripId: data['ride_request_id']));
    }
    else if(data['action'] == 'parcel_refund_request_denied'){
      _toRoute(formSplash, TripDetails(tripId: data['ride_request_id']));
    }
    else if(data['action'] == 'debited_from_wallet'){
      Get.offAll(() => const DashboardScreen());
      Get.find<BottomMenuController>().setTabIndex(3);
    }
    else if(data['action'] == 'tips_from_customer'){
      _toRoute(formSplash, TripDetails(tripId: data['ride_request_id']));
    }
    else if(data['action'] == 'admin_message'){
      Get.find<HelpAndSupportController>().getPredefineFaqList();
      Get.find<HelpAndSupportController>().createChannel(fromSplash: formSplash);

    }
    else {
      Get.offAll(() => const DashboardScreen());
    }

  }

  static Future _toRoute(bool formSplash, Widget page) async {
    if(formSplash) {
      await Get.offAll(() => page);

    }else {
      await Get.to(() => page);
    }
  }

}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage remoteMessage) async {
  customPrint('onBackground: ${remoteMessage.data}');
  // var androidInitialize = new AndroidInitializationSettings('notification_icon');
  // var iOSInitialize = new IOSInitializationSettings();
  // var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  // NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, true);
}

Future<dynamic> myBackgroundMessageReceiver(NotificationResponse response) async {
  customPrint('onBackgroundClicked: ${response.payload}');
}

