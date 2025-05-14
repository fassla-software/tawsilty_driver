
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/profile/screens/profile_menu_screen.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/trip_overview_widget.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/trips_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/zoom_drawer_context_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/type_button_widget.dart';

class TripHistoryMenu extends GetView<ProfileController> {
  const TripHistoryMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (_) => ZoomDrawer(
        controller: _.zoomDrawerController,
        menuScreen: const ProfileMenuScreen(),
        mainScreen: const TripHistoryScreen(),
        borderRadius: 24.0,
        angle: -5.0,
        isRtl: !Get.find<LocalizationController>().isLtr,
        menuBackgroundColor: Theme.of(context).primaryColor,
        slideWidth: MediaQuery.of(context).size.width * 0.85,
        mainScreenScale: .4,
        mainScreenTapClose: true,
      ),
    );
  }
}


class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Get.find<TripController>().getTripList(1,'','',"ride_request",Get.find<TripController>().selectedFilterTypeName,Get.find<TripController>().selectedStatusName);
    Get.find<TripController>().getTripOverView(Get.find<TripController>().selectedOverview);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<TripController>(builder: (tripController) {
        return Stack(children: [
          Column(children: [
            AppBarWidget(
              title: 'trip_history'.tr,showBackButton: false,
              onTap: (){
                Get.find<ProfileController>().toggleDrawer();
              },
            ),

            const SizedBox(height: 40),

            tripController.activityTypeIndex == 0 ?
            TripsWidget(tripController: tripController, scrollController: scrollController) :
            TripOverviewWidget(tripController: tripController)
          ]),

          Positioned(
            top: Dimensions.topSpace,left: Dimensions.paddingSizeSmall,
            child: SizedBox(
              height: Get.find<LocalizationController>().isLtr ? 45 : 50,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: tripController.activityTypeList.length,
                itemBuilder: (context, index){
                  return SizedBox(width: Get.width/2.1,
                    child: TypeButtonWidget(
                      index: index,
                      name: tripController.activityTypeList[index],
                      selectedIndex: tripController.activityTypeIndex,
                      onTap: ()=> tripController.setActivityTypeIndex(index),
                    ),
                  );
                },
              ),
            ),
          ),
        ]);
      }),
    );
  }
}
