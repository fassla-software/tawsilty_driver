import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/drop_down_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_view_widget.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer_widget.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/trip_card_widget.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class TripsWidget extends StatefulWidget {
  final ScrollController scrollController;
  final TripController tripController;
  const TripsWidget(
      {super.key,
      required this.tripController,
      required this.scrollController});

  @override
  State<TripsWidget> createState() => _TripsWidgetState();
}

class _TripsWidgetState extends State<TripsWidget>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 5, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        Get.find<TripController>().setStatusIndex(tabController.index);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<TripController>(builder: (tripController) {
        return Column(children: [
          Row(children: [
            Expanded(
              flex: 10,
              child: TabBar(
                controller: tabController,
                unselectedLabelColor: Colors.grey,
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                labelColor: Get.isDarkMode
                    ? Theme.of(context).primaryColorDark
                    : Theme.of(context).primaryColor,
                labelStyle: textSemiBold.copyWith(),
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1)),
                dividerHeight: 1,
                dividerColor: Theme.of(context).primaryColor.withOpacity(0.15),
                tabs: [
                  Tab(text: 'all_trip'.tr),
                  Tab(text: 'ongoing'.tr),
                  Tab(text: 'cancelled'.tr),
                  Tab(text: 'completed'.tr),
                  Tab(text: 'returned'.tr)
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(
                  right: Get.find<LocalizationController>().isLtr
                      ? Dimensions.paddingSizeDefault
                      : 0,
                  left: Get.find<LocalizationController>().isLtr
                      ? 0
                      : Dimensions.paddingSizeDefault,
                ),
                child: DropDownWidget<String>(
                  showText: false,
                  showLeftSide:
                      Get.find<LocalizationController>().isLtr ? false : true,
                  menuItemWidth: 120,
                  icon: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle),
                    child: const Icon(
                      Icons.filter_list_sharp,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  maxListHeight: 200,
                  items: tripController.selectedFilterType
                      .map((item) => CustomDropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item.tr,
                              style: textRegular.copyWith(
                                color: Get.isDarkMode
                                    ? Get.find<TripController>()
                                                .selectedFilterTypeName ==
                                            item
                                        ? Theme.of(context).primaryColor
                                        : Colors.white
                                    : Get.find<TripController>()
                                                .selectedFilterTypeName ==
                                            item
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color,
                              ),
                            ),
                          ))
                      .toList(),
                  borderRadius: 5,
                  onChanged: (value) {
                    tripController.setFilterTypeName(value!);
                  },
                ),
              ),
            ),
          ]),
          Expanded(
              child: TabBarView(controller: tabController, children: [
            tabBarBodyWidget(),
            tabBarBodyWidget(),
            tabBarBodyWidget(),
            tabBarBodyWidget(),
            tabBarBodyWidget()
          ]))
        ]);
      }),
    );
  }

  Widget tabBarBodyWidget() {
    return widget.tripController.tripModel != null
        ? widget.tripController.tripModel!.data != null
            ? widget.tripController.tripModel!.data!.isNotEmpty
                ? SingleChildScrollView(
                    controller: widget.scrollController,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 70.0, top: Dimensions.paddingSizeSmall),
                      child: PaginatedListViewWidget(
                        scrollController: widget.scrollController,
                        totalSize: widget.tripController.tripModel!.totalSize,
                        offset: (widget.tripController.tripModel != null &&
                                widget.tripController.tripModel!.offset != null)
                            ? int.parse(widget.tripController.tripModel!.offset
                                .toString())
                            : 1,
                        onPaginate: (int? offset) async {
                          if (kDebugMode) {
                            print('==========offset========>$offset');
                          }
                          await widget.tripController.getTripList(
                              offset!,
                              '',
                              '',
                              'ride_request',
                              widget.tripController.selectedFilterTypeName,
                              widget.tripController.selectedStatusName);
                        },
                        itemView: ListView.separated(
                          itemCount:
                              widget.tripController.tripModel!.data!.length,
                          padding: const EdgeInsets.all(0),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return TripCard(
                                tripModel: widget
                                    .tripController.tripModel!.data![index]);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(
                                  color: Theme.of(context)
                                      .highlightColor
                                      .withOpacity(0.15)),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(top: Get.height / 5),
                    child: const NoDataWidget(title: 'no_trip_found'),
                  )
            : const NotificationShimmerWidget()
        : const NotificationShimmerWidget();
  }
}
