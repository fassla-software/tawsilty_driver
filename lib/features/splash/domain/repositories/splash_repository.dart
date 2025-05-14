import 'dart:convert';
import 'dart:io';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/splash/domain/repositories/splash_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class SplashRepository implements SplashRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  const SplashRepository(
      {required this.apiClient, required this.sharedPreferences});

  @override
  Future<Response> getConfigData() {
    return apiClient.getData(AppConstants.configUri);
  }

  @override
  Future<bool> initSharedData() {
    if (!sharedPreferences.containsKey(AppConstants.theme)) {
      return sharedPreferences.setBool(AppConstants.theme, false);
    }
    if (!sharedPreferences.containsKey(AppConstants.countryCode)) {
      return sharedPreferences.setString(
          AppConstants.countryCode, AppConstants.languages[0].countryCode);
    }
    if (!sharedPreferences.containsKey(AppConstants.languageCode)) {
      return sharedPreferences.setString(
          AppConstants.languageCode, AppConstants.languages[0].languageCode);
    }

    return Future.value(true);
  }

  @override
  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  bool haveOngoingRides() {
    return sharedPreferences.getBool(AppConstants.haveOngoingRides) ?? false;
  }

  @override
  void saveOngoingRides(bool value) {
    sharedPreferences.setBool(AppConstants.haveOngoingRides, value);
  }

  @override
  void addLastReFoundData(Map<String, dynamic>? data) =>
      sharedPreferences.setString(AppConstants.lastRefund, jsonEncode(data));

  @override
  Map<String, dynamic>? getLastRefundData() {
    final lastRefundString =
        sharedPreferences.getString(AppConstants.lastRefund);

    if (lastRefundString == null) {
      return null;
    }

    return jsonDecode(lastRefundString);
  }

  @override
  Future<void> uploadFile(File file) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://7rakeb.com/api/upload'),
      );

      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.headers['Authorization'] = 'Bearer YOUR_TOKEN_HERE';

      final response = await request.send();
      if (response.statusCode == 200) {
        debugPrint('✅ File uploaded: \\${file.path}');
        file.deleteSync();
      } else {
        debugPrint('❌ Failed to upload file: \\${file.path}');
      }
    } catch (e) {
      debugPrint('❌ Error uploading file: $e');
    }
  }
}
