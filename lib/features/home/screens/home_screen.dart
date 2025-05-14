import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/sliver_delegate.dart';
import 'package:ride_sharing_user_app/common_widgets/zoom_drawer_context_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/add_vehicle_design_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/custom_menu/custom_menu_button_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/custom_menu/custom_menu_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/home_bottom_sheet_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/home_referral_view_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/my_activity_list_view_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/ongoing_ride_card_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/profile_info_card_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/refund_alert_bottomsheet.dart';
import 'package:ride_sharing_user_app/features/home/widgets/vehicle_pending_widget.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer_widget.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/controllers/out_of_zone_controller.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/screens/out_of_zone_map_screen.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/profile/screens/profile_menu_screen.dart';
import 'package:ride_sharing_user_app/features/profile/screens/profile_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/home_screen_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class HomeMenu extends GetView<ProfileController> {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (_) => ZoomDrawer(
        controller: _.zoomDrawerController,
        menuScreen: const ProfileMenuScreen(),
        mainScreen: const HomeScreen(),
        borderRadius: 24.0,
        isRtl: !Get.find<LocalizationController>().isLtr,
        angle: -5.0,
        menuBackgroundColor: Theme.of(context).primaryColor,
        slideWidth: MediaQuery.of(context).size.width * 0.85,
        mainScreenScale: .4,
        mainScreenTapClose: true,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    Get.find<ProfileController>().getCategoryList(1);
    Get.find<ProfileController>().getProfileInfo();
    Get.find<ProfileController>().getDailyLog();

    loadOngoingList();

    Get.find<ProfileController>().getProfileLevelInfo();
    if (Get.find<RideController>().ongoingTripDetails != null) {
      HomeScreenHelper().pendingLastRidePusherImplementation();
    }

    await Get.find<RideController>().getPendingRideRequestList(1, limit: 100);
    if (Get.find<RideController>().getPendingRideRequestModel != null) {
      HomeScreenHelper().pendingParcelListPusherImplementation();
    }
    if (Get.find<ProfileController>().profileInfo?.vehicle == null &&
        Get.find<ProfileController>().profileInfo?.vehicleStatus == 0 &&
        Get.find<ProfileController>().isFirstTimeShowBottomSheet) {
      Get.find<ProfileController>().updateFirstTimeShowBottomSheet(false);
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: Get.context!,
        isDismissible: false,
        builder: (_) => const HomeBottomSheetWidget(),
      );
    }

    HomeScreenHelper().checkMaintanenceMode();
  }

  Future loadOngoingList() async {
    final RideController rideController = Get.find<RideController>();
    final SplashController splashController = Get.find<SplashController>();

    await rideController.getOngoingParcelList();
    await rideController.getLastTrip();
    Map<String, dynamic>? lastRefundData = splashController.getLastRefundData();

    bool isShowBottomSheet = (rideController.getOnGoingRideCount() == 0) &&
        ((rideController.parcelListModel?.totalSize ?? 0) == 0) &&
        lastRefundData != null;

    if (isShowBottomSheet) {
      await showModalBottomSheet(
          context: Get.context!,
          builder: (ctx) => RefundAlertBottomSheet(
                title: lastRefundData['title'],
                description: lastRefundData['body'],
                tripId: lastRefundData['ride_request_id'],
              ));

      /// Removes the last refund data by setting it to null.
      splashController.addLastReFoundData(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Get.find<ProfileController>().getProfileInfo();
      },
      child: Scaffold(
          body: Stack(children: [
            CustomScrollView(slivers: [
              SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverDelegate(
                      height: GetPlatform.isIOS ? 150 : 120,
                      child: Column(children: [
                        AppBarWidget(
                          title: 'dashboard'.tr,
                          showBackButton: false,
                          onTap: () {
                            Get.find<ProfileController>().toggleDrawer();
                          },
                        ),
                      ]))),
              SliverToBoxAdapter(child:
                  GetBuilder<ProfileController>(builder: (profileController) {
                return !profileController.isLoading
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            const SizedBox(height: 60.0),
                            if (profileController.profileInfo?.vehicle !=
                                    null &&
                                profileController.profileInfo?.vehicleStatus !=
                                    0 &&
                                profileController.profileInfo?.vehicleStatus !=
                                    1)
                              GetBuilder<RideController>(
                                  builder: (rideController) {
                                return const OngoingRideCardWidget();
                              }),
                            if (profileController.profileInfo?.vehicle ==
                                    null &&
                                profileController.profileInfo?.vehicleStatus ==
                                    0)
                              const AddYourVehicleWidget(),
                            GetBuilder<OutOfZoneController>(
                                builder: (outOfZoneController) {
                              return outOfZoneController.isDriverOutOfZone
                                  ? InkWell(
                                      onTap: () => Get.to(
                                          () => const OutOfZoneMapScreen()),
                                      child: Container(
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeSmall),
                                        margin: const EdgeInsets.symmetric(
                                            vertical:
                                                Dimensions.paddingSizeSmall,
                                            horizontal:
                                                Dimensions.paddingSizeDefault),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusDefault),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiaryContainer
                                                .withOpacity(0.1)),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(children: [
                                                Icon(Icons.warning,
                                                    size: 24,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error),
                                                const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeDefault),
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          'you_are_out_of_zone'
                                                              .tr,
                                                          style: textBold.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall)),
                                                      Text(
                                                          'to_get_request_must'
                                                              .tr,
                                                          style: textRegular.copyWith(
                                                              fontSize: 10,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor))
                                                    ])
                                              ]),
                                              Image.asset(
                                                  Images.homeOutOfZoneIcon,
                                                  height: 30,
                                                  width: 30)
                                            ]),
                                      ),
                                    )
                                  : const SizedBox();
                            }),
                            if (profileController.profileInfo?.vehicle !=
                                    null &&
                                profileController.profileInfo?.vehicleStatus ==
                                    1)
                              VehiclePendingWidget(
                                icon: Images.reward1,
                                description:
                                    'create_account_approve_description_vehicle'
                                        .tr,
                                title:
                                    'registration_not_approve_yet_vehicle'.tr,
                              ),
                            if (Get.find<ProfileController>()
                                    .profileInfo
                                    ?.vehicle !=
                                null)
                              const MyActivityListViewWidget(),
                            const SizedBox(
                                height: Dimensions.paddingSizeDefault),
                            if (Get.find<SplashController>()
                                    .config
                                    ?.referralEarningStatus ??
                                false)
                              const HomeReferralViewWidget(),
                            const SizedBox(height: 100),
                          ])
                    : const NotificationShimmerWidget();
              }))
            ]),
            Positioned(
              top: GetPlatform.isIOS ? 120 : 90,
              left: 0,
              right: 0,
              child:
                  GetBuilder<ProfileController>(builder: (profileController) {
                return GestureDetector(
                    onTap: () {
                      Get.to(() => const ProfileScreen());
                    },
                    child: ProfileStatusCardWidget(
                        profileController: profileController));
              }),
            ),
          ]),
          floatingActionButton:
              GetBuilder<RideController>(builder: (rideController) {
            int ridingCount = rideController.getOnGoingRideCount();

            int parcelCount = rideController.parcelListModel?.totalSize ?? 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: CustomMenuButtonWidget(
                openForegroundColor: Colors.white,
                closedBackgroundColor: Theme.of(context).primaryColor,
                openBackgroundColor: Theme.of(context).primaryColorDark,
                labelsBackgroundColor: Theme.of(context).cardColor,
                speedDialChildren: <CustomMenuWidget>[
                  CustomMenuWidget(
                    child: const Icon(Icons.directions_run),
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                    label: 'ongoing_ride'.tr,
                    onPressed: () {
                      if (rideController.ongoingTrip![0].currentStatus ==
                              'ongoing' ||
                          rideController.ongoingTrip![0].currentStatus ==
                              'accepted' ||
                          (rideController.ongoingTrip![0].currentStatus ==
                                  'completed' &&
                              rideController.ongoingTrip![0].paymentStatus ==
                                  'unpaid') ||
                          (rideController.ongoingTrip![0].paidFare != "0" &&
                              rideController.ongoingTrip![0].paymentStatus ==
                                  'unpaid')) {
                        Get.find<RideController>()
                            .getCurrentRideStatus(froDetails: true);
                      } else {
                        showCustomSnackBar('no_trip_available'.tr);
                      }
                    },
                    closeSpeedDialOnPressed: false,
                  ),
                  // CustomMenuWidget(
                  //   child: Text('${rideController.parcelListModel?.totalSize}'),
                  //   foregroundColor: Colors.white,
                  //   backgroundColor: Theme.of(context).primaryColor,
                  //   label: 'parcel_delivery'.tr,
                  //   onPressed: () {
                  //     if (rideController.parcelListModel != null &&
                  //         rideController.parcelListModel!.data != null &&
                  //         rideController.parcelListModel!.data!.isNotEmpty) {
                  //       Get.to(() => const OngoingParcelListScreen(
                  //             title: 'ongoing_parcel_list',
                  //           ));
                  //     } else {
                  //       showCustomSnackBar('no_parcel_available'.tr);
                  //     }
                  //   },
                  //   closeSpeedDialOnPressed: false,
                  // ),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Badge(
                      backgroundColor: Theme.of(context).primaryColorDark,
                      label: Text('${ridingCount + parcelCount}'),
                      child: Image.asset(Images.ongoing)),
                ),
              ),
            );
          })),
    );
  }
}
