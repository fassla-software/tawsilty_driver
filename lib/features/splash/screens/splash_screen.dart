import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/screens/sign_in_screen.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/location/screens/access_location_screen.dart';
import 'package:ride_sharing_user_app/features/maintainance_mode/screens/maintainance_screen.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/controllers/out_of_zone_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/splash/domain/models/config_model.dart';
import 'package:ride_sharing_user_app/features/splash/screens/app_version_warning_screen.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/helper/firebase_helper.dart';
import 'package:ride_sharing_user_app/helper/notification_helper.dart';
import 'package:ride_sharing_user_app/helper/pusher_helper.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/images.dart';

import '../../../record_manger.dart';

class SplashScreen extends StatefulWidget {
  final Map<String, dynamic>? notificationData;
  final String? userName;
  const SplashScreen({super.key, this.notificationData, this.userName});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  StreamSubscription<List<ConnectivityResult>>? _onConnectivityChanged;

  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    if (!GetPlatform.isIOS) {
      _checkConnectivity();
    }
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();

    Get.find<SplashController>().initSharedData();
    Get.find<TripController>().rideCancellationReasonList();
    Get.find<TripController>().parcelCancellationReasonList();
    Get.find<AuthController>().remainingTime();
    _route();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _onConnectivityChanged?.cancel();
    _animation.removeListener(() {});
    _controller.dispose(); // you
    super.dispose();
  }

  void _checkConnectivity() {
    bool isFirst = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      bool isConnected = result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile);
      if ((isFirst && !isConnected) || !isFirst && context.mounted) {
        ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
        ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isConnected ? Colors.green : Colors.red,
          duration: Duration(seconds: isConnected ? 3 : 6000),
          content: Text(
            isConnected ? 'connected'.tr : 'no_connection'.tr,
            textAlign: TextAlign.center,
          ),
        ));

        if (isConnected) {
          _route();
        }
      }
      isFirst = false;
    });
  }

  void _route() async {
    bool isSuccess = await Get.find<SplashController>().getConfigData();
    if (isSuccess) {
      if (_isForceUpdate(Get.find<SplashController>().config)) {
        Get.offAll(() => const AppVersionWarningScreen());
      } else {
        FirebaseHelper().subscribeFirebaseTopic();
        if (Get.find<AuthController>().getUserToken().isNotEmpty) {
          PusherHelper.initilizePusher();
        }

        if (Get.find<AuthController>().getZoneId() == '') {
          Get.offAll(() => const AccessLocationScreen());
        } else {
          Get.find<AuthController>().updateToken();
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (Get.find<AuthController>().isLoggedIn()) {
              Get.find<OutOfZoneController>().getZoneList();
              Get.find<ProfileController>().getProfileInfo().then((value) {
                if (value.statusCode == 200) {
                  Get.find<LocationController>()
                      .getCurrentLocation()
                      .then((value) {
                    if (widget.notificationData != null) {
                      NotificationHelper.notificationToRoute(
                          widget.notificationData!,
                          formSplash: true,
                          userName: widget.userName);
                    } else {
                      Get.offAll(() => const DashboardScreen());
                    }
                  });
                  PusherHelper()
                      .driverTripRequestSubscribe(value.body['data']['id']);
                }
              });
            } else {
              if (Get.find<SplashController>().config!.maintenanceMode !=
                      null &&
                  Get.find<SplashController>()
                          .config!
                          .maintenanceMode!
                          .maintenanceStatus ==
                      1 &&
                  Get.find<SplashController>()
                          .config!
                          .maintenanceMode!
                          .selectedMaintenanceSystem!
                          .driverApp ==
                      1) {
                Get.offAll(() => const MaintenanceScreen());
              } else {
                Get.offAll(() => const SignInScreen()

                    // const RecordManger()
                    );
              }
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RideController>(builder: (rideController) {
        return GetBuilder<ProfileController>(builder: (profileController) {
          return GetBuilder<LocationController>(builder: (locationController) {
            return Stack(children: [
              Container(
                decoration: BoxDecoration(
                    color: Get.isDarkMode ? Colors.black : Colors.white),
                alignment: Alignment.bottomCenter,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Container(
                              transform: Matrix4.translationValues(
                                  0,
                                  320 -
                                      (320 *
                                          double.tryParse(
                                              _animation.value.toString())!),
                                  0),
                              child: Column(children: [
                                Opacity(
                                  opacity: _animation.value,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 120 -
                                          ((120 *
                                              double.tryParse(_animation.value
                                                  .toString())!)),
                                    ),
                                    child: Image.asset(
                                        Get.isDarkMode
                                            ? Images.logoNameWhite
                                            : Images.logoNameBlack,
                                        width: 160),
                                  ),
                                ),
                                const SizedBox(height: 50),
                                Image.asset(
                                  Images.splashBackgroundOne,
                                  width: Get.width,
                                  height: Get.height / 2,
                                  fit: BoxFit.cover,
                                ),
                              ]),
                            ),
                            Container(
                              transform: Matrix4.translationValues(0, 20, 0),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: (70 *
                                      double.tryParse(
                                          _animation.value.toString())!),
                                ),
                                child: Image.asset(Images.splashBackgroundTwo,
                                    width: Get.size.width),
                              ),
                            )
                          ]),
                    ]),
              ),
            ]);
          });
        });
      }),
    );
  }

  bool _isForceUpdate(ConfigModel? config) {
    double minimumVersion = Platform.isAndroid
        ? config?.androidAppMinimumVersion ?? 0
        : Platform.isIOS
            ? config?.iosAppMinimumVersion ?? 0
            : 0;

    return minimumVersion > 0 && minimumVersion > AppConstants.appVersion;
  }
}
