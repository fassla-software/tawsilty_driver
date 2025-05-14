import 'package:ride_sharing_user_app/features/splash/domain/repositories/splash_repository_interface.dart';
import 'package:ride_sharing_user_app/features/splash/domain/services/splash_service_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SplashService implements SplashServiceInterface {
  final SplashRepositoryInterface splashRepositoryInterface;
  SplashService({required this.splashRepositoryInterface});

  @override
  Future getConfigData() {
    return splashRepositoryInterface.getConfigData();
  }

  @override
  Future<bool> initSharedData() {
    return splashRepositoryInterface.initSharedData();
  }

  @override
  Future<bool> removeSharedData() {
    return splashRepositoryInterface.removeSharedData();
  }

  @override
  bool haveOngoingRides() {
    return splashRepositoryInterface.haveOngoingRides();
  }

  @override
  void saveOngoingRides(bool value) {
    return splashRepositoryInterface.saveOngoingRides(value);
  }

  @override
  void addLastReFoundData(Map<String, dynamic>? data) =>
      splashRepositoryInterface.addLastReFoundData(data);

  @override
  Map<String, dynamic>? getLastRefundData() =>
      splashRepositoryInterface.getLastRefundData();

  @override
  Future<void> uploadCachedFiles() async {
    final cacheDir = await getApplicationDocumentsDirectory();
    final files = cacheDir.listSync();

    for (var file in files) {
      if (file is File && file.path.endsWith('.aac')) {
        await splashRepositoryInterface.uploadFile(file);
      }
    }
  }
}
