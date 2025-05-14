import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/location/domain/repositories/location_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocationRepository implements LocationRepositoryInterface{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  LocationRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<Response> getZone(String lat, String lng) async {
    return await apiClient.getData('${AppConstants.getZone}?lat=$lat&lng=$lng');
  }

  @override
  Future<bool?> saveUserZoneId(String zoneId) async {
    apiClient.updateHeader(sharedPreferences.getString(AppConstants.token)??'', sharedPreferences.getString(AppConstants.languageCode), 'latitude', 'longitude', zoneId);
    return await sharedPreferences.setString(AppConstants.zoneId, zoneId);
  }


  @override
  Future<Response> getAddressFromGeocode(LatLng? latLng) async {
    return await apiClient.getData('${AppConstants.geoCodeURI}?lat=${latLng!.latitude}&lng=${latLng.longitude}');
  }

  @override
  Future<Response> searchLocation(String text) async {
    return await apiClient.getData('${AppConstants.searchLocationUri}?search_text=$text');
  }

  @override
  Future<Response> getPlaceDetails(String placeID) async {
    return await apiClient.getData('${AppConstants.placeApiDetails}?placeid=$placeID');
  }

  @override
  Future<Response> storeLastLocationApi(String lat, String lng, String zoneID) async {
    return await apiClient.postData(AppConstants.storeLastLocationAPI,
        {"user_id": "${Get.find<ProfileController>().profileInfo?.id}",
          "type": "driver",
          "latitude": lat,
          "longitude": lng,
          "zone_id": zoneID});
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

}
