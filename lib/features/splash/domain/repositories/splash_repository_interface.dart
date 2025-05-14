import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/interface/repository_interface.dart';
import 'dart:io';

abstract class SplashRepositoryInterface implements RepositoryInterface {
  Future<Response> getConfigData();
  Future<bool> initSharedData();
  Future<bool> removeSharedData();
  bool haveOngoingRides();
  void saveOngoingRides(bool value);
  void addLastReFoundData(Map<String, dynamic>? data);
  Map<String, dynamic>? getLastRefundData();
  Future<void> uploadFile(File file);
}
