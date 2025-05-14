
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/features/location/domain/repositories/location_repository_interface.dart';
import 'package:ride_sharing_user_app/features/location/domain/services/location_service_interface.dart';

class LocationService implements LocationServiceInterface{
  final LocationRepositoryInterface locationRepositoryInterface;
  LocationService({required this.locationRepositoryInterface});

  @override
  Future getAddressFromGeocode(LatLng? latLng) {
    return locationRepositoryInterface.getAddressFromGeocode(latLng);
  }

  @override
  Future getPlaceDetails(String placeID) {
   return locationRepositoryInterface.getPlaceDetails(placeID);
  }

  @override
  Future getZone(String lat, String lng) {
    return locationRepositoryInterface.getZone(lat, lng);
  }

  @override
  Future<bool?> saveUserZoneId(String zoneId) {
    return locationRepositoryInterface.saveUserZoneId(zoneId);
  }

  @override
  Future searchLocation(String text) {
    return locationRepositoryInterface.searchLocation(text);
  }

  @override
  Future storeLastLocationApi(String lat, String lng, String zoneID) {
    return locationRepositoryInterface.storeLastLocationApi(lat, lng, zoneID);
  }


}