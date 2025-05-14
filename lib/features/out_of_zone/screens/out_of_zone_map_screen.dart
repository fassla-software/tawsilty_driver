import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/widgets/custom_icon_card_widget.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/controllers/out_of_zone_controller.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/images.dart';

class OutOfZoneMapScreen extends StatefulWidget {
  const OutOfZoneMapScreen({super.key});

  @override
  State<OutOfZoneMapScreen> createState() => _OutOfZoneMapScreenState();
}

class _OutOfZoneMapScreenState extends State<OutOfZoneMapScreen> {
  GoogleMapController? _mapController;
  Timer? _timer ;
  Set<Polygon> _polygons = {};
  Set<Polyline> _polyLine = {};
  List<LatLng> polygonLatLongs = [];
  Set<Marker> _markers = {};
  ByteData? byteData;
  Position? location;


  Future _loadData() async {
    polygonLatLongs = [];
    AssetBundle assetBundle = DefaultAssetBundle.of(context);

    await Future.forEach(Get.find<OutOfZoneController>().nearestZone, (v){
      polygonLatLongs.add(LatLng(v.latitude, v.longitude));
    });

    _polygons.add(Polygon(
      polygonId: const PolygonId("0"),
      points: polygonLatLongs,
      fillColor: Colors.green.withOpacity(0.15),
      strokeColor: Colors.green,
      strokeWidth: 0,
    ));

    _polyLine.add(Polyline(
        polylineId: const PolylineId('id'),
        points: polygonLatLongs,
        color: Colors.green,
        width: 2,
        patterns: [
          PatternItem.dash(10),
          PatternItem.gap(8),
        ]
    ));

    location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);


    byteData = await assetBundle.load(Images.carTop);
    _markers.add(Marker(
        markerId: const MarkerId('marker id'),
        position: LatLng(location!.latitude, location!.longitude),
        icon: BitmapDescriptor.bytes(byteData!.buffer.asUint8List(), width: 70 )
    ));

    _timer = Timer.periodic(const Duration(seconds: 10), (_) async{
      _markers = {};
      location = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 1), desiredAccuracy: LocationAccuracy.high,
      );

      _markers.add(Marker(
          markerId: const MarkerId('marker id'),
          position: LatLng(location!.latitude, location!.longitude),
          icon: BitmapDescriptor.bytes(byteData!.buffer.asUint8List(), width: 70)
      ));

      if(!(Get.find<OutOfZoneController>().nearestZone[0].latitude == polygonLatLongs[0].latitude)){
        _polygons = {};
        _polyLine = {};
        polygonLatLongs = [];
        Get.find<OutOfZoneController>().nearestZone.forEach((v){
          polygonLatLongs.add(LatLng(v.latitude, v.longitude));
        });
        _polygons.add(
          Polygon(
            polygonId: const PolygonId("polyGoneId"),
            points: polygonLatLongs,
            fillColor: Colors.green.withOpacity(0.15),
            strokeColor: Colors.green,
            strokeWidth: 0,
          ),
        );
        _polyLine.add(
          Polyline(
              polylineId: const PolylineId('polyLineId'),
              points: polygonLatLongs,
              color: Colors.green,
              width: 2,
              patterns: [
                PatternItem.dash(10),
                PatternItem.gap(8),
              ]
          ),
        );

        _setMapBounds();
      }

      setState(() {});
    });
  }


  @override
  void dispose() {
    _mapController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'your_location'.tr,showBackButton: true,regularAppbar: true),
      body: GetBuilder<RiderMapController>(builder: (riderMapController){
        return Stack(children: [
          GoogleMap(
            style: Get.isDarkMode ? Get.find<ThemeController>().darkMap :
            Get.find<ThemeController>().lightMap,
            initialCameraPosition:  CameraPosition(
              target: Get.find<LocationController>().initialPosition,
              zoom: 16,
            ),
            onMapCreated: (GoogleMapController controller) async {
              _mapController = controller;
              await _loadData();

              _setMapBounds();
              setState(() {});

            },
            minMaxZoomPreference: const MinMaxZoomPreference(0, AppConstants.mapZoom),
            zoomControlsEnabled: false,
            compassEnabled: false,
            polygons: _polygons,
            markers: _markers,
            polylines: _polyLine,
            trafficEnabled: riderMapController.isTrafficEnable,
            indoorViewEnabled: true,
            mapToolbarEnabled: true,
            myLocationButtonEnabled: true,
          ),

          Positioned(bottom: Get.width * 0.2,right: 0, child: Align(
            alignment: Alignment.bottomRight,
            child: GetBuilder<LocationController>(builder: (locationController) {
              return CustomIconCardWidget(
                title: '', index: 5,
                icon: riderMapController.isTrafficEnable ?
                Images.trafficOnlineIcon : Images.trafficOfflineIcon,
                iconColor: riderMapController.isTrafficEnable ?
                Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).hintColor,
                onTap: () => riderMapController.toggleTrafficView(),
              );
            }),
          )),

          Positioned(bottom: Get.width * 0.05,right: 0, child: Align(
            alignment: Alignment.bottomRight,
            child: GetBuilder<LocationController>(builder: (locationController) {
              return CustomIconCardWidget(
                iconColor: Theme.of(context).primaryColor,
                title: '', index: 5,icon: Images.currentLocation,
                onTap: () async {
                 _mapController?.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                   target: LatLng(location!.latitude, location!.longitude),
                   zoom: 12,
                 )));
                },
              );
            }),
          )),

        ]);
      }),
    );
  }

  void _setMapBounds() async{
    LatLngBounds bounds = _getPolygonAndPointBounds(LatLng(location!.latitude, location!.longitude), polygonLatLongs);
    LatLng centerBounds = LatLng(
      (bounds.northeast.latitude + bounds.southwest.latitude)/2,
      (bounds.northeast.longitude + bounds.southwest.longitude)/2,
    );
    zoomToFit(_mapController, bounds, centerBounds, 0);
  }

  Future<void> zoomToFit(GoogleMapController? controller, LatLngBounds? bounds, LatLng centerBounds, double bearing, {double padding = 0.2}) async {
    bool keepZoomingOut = true;
    while(keepZoomingOut) {
      final LatLngBounds screenBounds = await controller!.getVisibleRegion();
      if(fits(bounds!, screenBounds)) {
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - padding;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
          bearing: bearing,
        )));
        break;
      }
      else {
        // Zooming out by 0.1 zoom level per iteration
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck = screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck = screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck = screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck = screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck && northEastLongitudeCheck && southWestLatitudeCheck && southWestLongitudeCheck;
  }

  LatLngBounds _getPolygonAndPointBounds(LatLng point, List<LatLng> polygon) {
    double minLat = point.latitude;
    double minLng = point.longitude;
    double maxLat = point.latitude;
    double maxLng = point.longitude;

    for (LatLng coord in polygon) {
      if (coord.latitude < minLat) minLat = coord.latitude;
      if (coord.latitude > maxLat) maxLat = coord.latitude;
      if (coord.longitude < minLng) minLng = coord.longitude;
      if (coord.longitude > maxLng) maxLng = coord.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }


}



