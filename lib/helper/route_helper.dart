import 'dart:convert';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/auth/screens/sign_up_screen.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/splash/screens/splash_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String home = '/home';

  static getInitialRoute() => initial;
  static getSplashRoute({Map<String, dynamic>? notificationData}) {
    notificationData?.remove('body');
    String userName =
        (notificationData?['user_name'] ?? '').replaceAll('&', 'a');
    notificationData?.remove('user_name');

    return '$splash?notification=${jsonEncode(notificationData)}&userName=$userName';
  }

  static getHomeRoute() => home;

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const SignUpScreen()),
    GetPage(
        name: splash,
        page: () => SplashScreen(
            notificationData: Get.parameters['notification'] == null
                ? null
                : jsonDecode(Get.parameters['notification']!),
            userName: Get.parameters['userName']?.replaceAll('a', '&'))),
    GetPage(name: home, page: () => const DashboardScreen()),
  ];
}
