import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/widgets/custom_icon_card_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/driver_header_info_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/expendale_bottom_sheet_widget.dart';
import 'package:ride_sharing_user_app/features/profile/screens/profile_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/screens/ride_request_list_screen.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class MapScreen extends StatefulWidget {
  final String fromScreen;
  const MapScreen({super.key,  this.fromScreen = 'home'});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver{
  GoogleMapController? _mapController;
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey<ExpandableBottomSheetState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _findingCurrentRoute();
  }

  _findingCurrentRoute(){
    
    Get.find<RideController>().updateRoute(false, notify: false);
    Get.find<RiderMapController>().setSheetHeight(Get.find<RiderMapController>().currentRideState == RideState.initial ? 300 : 270, false);
    Get.find<RideController>().getPendingRideRequestList(1);
    if(Get.find<RideController>().ongoingTrip != null
        && Get.find<RideController>().ongoingTrip!.isNotEmpty
        && (Get.find<RideController>().ongoingTrip![0].currentStatus == 'ongoing'
            || Get.find<RideController>().ongoingTrip![0].currentStatus == 'accepted'
            || (Get.find<RideController>().ongoingTrip![0].currentStatus =='completed'
                && Get.find<RideController>().ongoingTrip![0].paymentStatus == 'unpaid'))  ){
      // Get.find<RideController>().getCurrentRideStatus(froDetails: true, isUpdate: false);
      Get.find<RiderMapController>().setMarkersInitialPosition();
    }
    getCurrentLocation();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      // Get.find<RideController>().getCurrentRideStatus(froDetails: true, isUpdate: false,fromMapScreen: true);
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
    }
    super.dispose();
  }

  StreamSubscription? _locationSubscription;
  Marker? marker;
  GoogleMapController? _controller;

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load(Images.carTop);
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(Position? newLocalData, Uint8List imageData) {
    LatLng latLng = LatLng(newLocalData!.latitude, newLocalData.longitude);
    setState(() {
      marker = Marker(
          markerId: const MarkerId("home"),
          position: latLng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await Geolocator.getCurrentPosition();
      updateMarkerAndCircle(location, imageData);
      if (_locationSubscription != null) {
        _locationSubscription!.cancel();
      }

      _locationSubscription = Geolocator.getPositionStream().listen((newLocalData) {
        if (_controller != null) {
          _controller!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 16)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (res, val){
        if(res){
          Get.find<RideController>().getOngoingParcelList();
          Get.find<RideController>().getLastTrip();
          Get.find<RideController>().updateRoute(true,notify: true);

        }else{
          Get.offAll(()=> const DashboardScreen());
        }

      },
      child: Scaffold(resizeToAvoidBottomInset: false,
        body: GetBuilder<RiderMapController>(builder: (riderMapController) {
          return GetBuilder<RideController>(builder: (rideController) {
            return ExpandableBottomSheet(key: key,persistentContentHeight: riderMapController.sheetHeight,
              background: GetBuilder<RideController>(builder: (rideController) {
                return Stack(children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: riderMapController.sheetHeight -
                          (Get.find<RiderMapController>().currentRideState == RideState.initial ? 80 : 20),
                    ),
                    child: GoogleMap(
                      style: Get.isDarkMode ? Get.find<ThemeController>().darkMap :
                      Get.find<ThemeController>().lightMap,
                      initialCameraPosition:  CameraPosition(
                        target:  (rideController.tripDetail != null &&
                            rideController.tripDetail!.pickupCoordinates != null) ?
                        LatLng(
                          rideController.tripDetail!.pickupCoordinates!.coordinates![1],
                          rideController.tripDetail!.pickupCoordinates!.coordinates![0],
                        ) : Get.find<LocationController>().initialPosition,
                        zoom: 16,
                      ),
                      onMapCreated: (GoogleMapController controller) async {
                        riderMapController.mapController = controller;
                        if(riderMapController.currentRideState.name != 'initial'){
                          if(riderMapController.currentRideState.name == 'accepted' || riderMapController.currentRideState.name == 'ongoing'){
                            Get.find<RideController>().remainingDistance(Get.find<RideController>().tripDetail!.id!,mapBound: true);
                          }else{
                            riderMapController.getPickupToDestinationPolyline();}
                        }
                        _mapController = controller;
                      },
                      onCameraMove: (CameraPosition cameraPosition) {
                      },
                      onCameraIdle: () {

                      },
                      minMaxZoomPreference: const MinMaxZoomPreference(0, AppConstants.mapZoom),
                      markers: Set<Marker>.of(riderMapController.markers),
                      polylines: riderMapController.polylines,
                      zoomControlsEnabled: false,
                      compassEnabled: false,
                      trafficEnabled: riderMapController.isTrafficEnable,
                      indoorViewEnabled: true,
                      mapToolbarEnabled: true,
                    ),
                  ),

                  InkWell(
                    onTap: () => Get.to(const ProfileScreen()),
                    child: const DriverHeaderInfoWidget(),
                  ),

                  Positioned(bottom: Get.width * 0.87,right: 0, child: Align(
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

                  Positioned(bottom: Get.width * 0.73,right: 0, child: Align(
                    alignment: Alignment.bottomRight,
                    child: GetBuilder<LocationController>(builder: (locationController) {
                      return CustomIconCardWidget(
                        iconColor: Theme.of(context).primaryColor,
                        title: '', index: 5,icon: Images.currentLocation,
                        onTap: () async {
                          await locationController.getCurrentLocation(mapController: _mapController,isAnimate: false);
                        },
                      );
                    }),
                  )),

                  Positioned(child: Align(alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: (){
                        Get.find<RideController>().updateRoute(true,notify: true);
                        Get.off(()=> const DashboardScreen());
                      },
                      onHorizontalDragEnd: (DragEndDetails details){
                        _onHorizontalDrag(details);
                        Get.find<RideController>().updateRoute(true, notify: true);
                        Get.off(()=> const DashboardScreen());
                      },

                      child: Stack(children: [
                        SizedBox(width: Dimensions.iconSizeExtraLarge, child: Image.asset(
                          Images.mapToHomeIcon, color: Theme.of(context).primaryColor,
                        )),

                        Positioned(top: 0, bottom: 0, left: 5, right: 5,
                          child: SizedBox(width: 15,child: Image.asset(
                            Images.homeSmallIcon, color: Theme.of(context).colorScheme.shadow,
                          )),
                        )
                      ]),
                    ),
                  )),

                ]);
              }),
              persistentHeader: SizedBox(height: 50, child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                Center(child: GetBuilder<RideController>(builder: (rideController) {
                  return InkWell(onTap: () => Get.to(()=> const RideRequestScreen()),
                    child: Container(
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                          vertical: Dimensions.paddingSizeSmall,
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: Dimensions.iconSizeSmall, child: Image.asset(Images.reqListIcon)),

                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Text(
                              '${rideController.pendingRideRequestModel?.totalSize??0} ${'more_request'.tr}',
                              style: textRegular.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })),
              ],
              )),
              expandableContent: Builder(builder: (context) {
                return Column(mainAxisSize: MainAxisSize.min,children: [
                  RiderBottomSheetWidget(expandableKey: key),

                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ]);
              }),
            );
          });
        }),
      ),
    );
  }

  void _onHorizontalDrag(DragEndDetails details) {
    if(details.primaryVelocity == 0) return; // user have just tapped on screen (no dragging)

    if (details.primaryVelocity!.compareTo(0) == -1) {

    } else {

    }
  }

}