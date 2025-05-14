import 'dart:async';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/splash/domain/models/config_model.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/splash/domain/services/splash_service_interface.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashController extends GetxController implements GetxService {
  final SplashServiceInterface splashServiceInterface;
  SplashController({required this.splashServiceInterface});

  ConfigModel? _config;

  ConfigModel? get config => _config;

  bool loading = false;
  Future<bool> getConfigData({bool reload = true}) async {
    loading = true;
    Response response = await splashServiceInterface.getConfigData();
    bool isSuccess = false;
    if (response.statusCode == 200) {
      isSuccess = true;
      loading = false;
      _config = ConfigModel.fromJson(response.body);
    } else {
      loading = false;
      ApiChecker.checkApi(response);
    }
    if (reload) {
      update();
    }
    return isSuccess;
  }

  Future<bool> initSharedData() {
    return splashServiceInterface.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashServiceInterface.removeSharedData();
  }

  final Uri params = Uri(
    scheme: 'mailto',
    path: '',
    query: 'subject=support Feedback&body=',
  );

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Future<void> sendMailOrCall(String url, bool isMail) async {
    if (!await launchUrl(Uri.parse(isMail ? params.toString() : url))) {
      throw 'Could not launch $url';
    }
  }

  String? _pusherConnectionStatus;
  String? get pusherConnectionStatus => _pusherConnectionStatus;

  void setPusherStatus(String? connection) {
    _pusherConnectionStatus = connection;
  }

  bool haveOngoingRides() {
    return splashServiceInterface.haveOngoingRides();
  }

  void saveOngoingRides(bool value) {
    return splashServiceInterface.saveOngoingRides(value);
  }

  void addLastReFoundData(Map<String, dynamic>? data) =>
      splashServiceInterface.addLastReFoundData(data);
  Map<String, dynamic>? getLastRefundData() =>
      splashServiceInterface.getLastRefundData();

  Future<void> uploadCachedFiles() async {
    await splashServiceInterface.uploadCachedFiles();
  }
}
