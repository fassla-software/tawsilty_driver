import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationServiceInterface {
  Future<dynamic> getZone(String lat, String lng);
  Future<bool?> saveUserZoneId(String zoneId);
  Future<dynamic> getAddressFromGeocode(LatLng? latLng);
  Future<dynamic> searchLocation(String text);
  Future<dynamic> getPlaceDetails(String placeID);
  Future<dynamic> storeLastLocationApi(String lat, String lng, String zoneID);
}