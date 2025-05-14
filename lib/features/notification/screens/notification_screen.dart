import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/notification/controllers/notification_controller.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_card_widget.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer_widget.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/profile/screens/profile_menu_screen.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/zoom_drawer_context_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_view_widget.dart';


class NotificationMenu extends GetView<ProfileController> {
  const NotificationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (_) => ZoomDrawer(
        controller: _.zoomDrawerController,
        menuScreen: const ProfileMenuScreen(),
        mainScreen: const NotificationScreen(),
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



class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ScrollController scrollController = ScrollController();
  @override

  @override
  void initState() {
    Get.find<NotificationController>().getNotificationList(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<NotificationController>(builder: (notificationController) {
        return Column(children: [
          AppBarWidget(
            title: 'my_notification'.tr,
            regularAppbar: true, showBackButton: false,
            onTap: () => Get.find<ProfileController>().toggleDrawer(),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Expanded(child: GetBuilder<NotificationController>(builder: (notificationController) {
            return notificationController.notificationModel != null ?
            (notificationController.notificationModel!.data != null && notificationController.notificationModel!.data!.isNotEmpty) ?
            SingleChildScrollView(
              controller: scrollController,
              child: PaginatedListViewWidget(
                  scrollController: scrollController,
                  totalSize: notificationController.notificationModel!.totalSize,
                  offset: (notificationController.notificationModel != null && notificationController.notificationModel!.offset != null) ? int.parse(notificationController.notificationModel!.offset.toString()) : null,
                  onPaginate: (int? offset) async {
                    await notificationController.getNotificationList(offset!);
                  },
                  itemView: Padding(padding: const EdgeInsets.only(bottom: 70),
                      child: ListView.builder(
                          itemCount: notificationController.notificationModel!.data!.length,
                          padding: const EdgeInsets.all(0),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return NotificationCardWidget(
                              previousNotification: index == 0 ? null : notificationController.notificationModel!.data![index - 1],
                              notification: notificationController.notificationModel!.data![index],
                              nextNotification: (index == notificationController.notificationModel!.data!.length-1) ? null : notificationController.notificationModel!.data![index + 1],
                            );
                          }
                      )
                  )
              ),
            ) :
            const NoDataWidget(title: 'no_notification_found') :
            const NotificationShimmerWidget() ;
          })),
        ]);
      }),
    );
  }
}
