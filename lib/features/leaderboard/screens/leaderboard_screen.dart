import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/leaderboard/controllers/leader_board_controller.dart';
import 'package:ride_sharing_user_app/features/leaderboard/widgets/leader_board_card_widget.dart';
import 'package:ride_sharing_user_app/features/leaderboard/widgets/today_leaderboard_status_widget.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_view_widget.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {


  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    Get.find<LeaderBoardController>().getLeaderboardList(1,'today');
    Get.find<LeaderBoardController>().setFilterTypeName('today');
    Get.find<LeaderBoardController>().getDailyActivities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<LeaderBoardController>(builder: (leaderboardController) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppBarWidget(title: 'leader_board'.tr, showBackButton: true,),

          const TodayLeaderBoardStatusWidget(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'see_others'.tr,
                style: textSemiBold.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  fontSize: Dimensions.fontSizeExtraLarge,
                ),
              ),

              const Spacer(),

              Container(
                width: Dimensions.dropDownWidth,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 1, color: Theme.of(context).primaryColor.withOpacity(0.2)),
                ),
                child: DropdownButtonFormField2<String>(
                  isExpanded: true,
                  isDense: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                  ),
                  hint:  Text('today'.tr, style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)),
                  items: leaderboardController.selectedFilterType.map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item.tr, style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: leaderboardController.selectedFilterTypeName == item ?
                      Theme.of(context).primaryColor :
                      Theme.of(context).textTheme.bodyMedium!.color,
                    )),
                  )).toList(),
                  onChanged: (value) {
                    leaderboardController.setFilterTypeName(value!);
                  },
                  buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(right: 8)),
                  iconStyleData: IconStyleData(
                    icon: Icon(Icons.arrow_drop_down,
                        color: Theme.of(context).hintColor), iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  ),
                  menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 16)),
                ),
              ),
            ]),
          ),

          Expanded(child: Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            child: SingleChildScrollView(
              child: GetBuilder<LeaderBoardController>(builder: (leaderboardController) {
                return leaderboardController.leaderBoardModel != null ?
                leaderboardController.leaderBoardModel!.data != null &&
                    leaderboardController.leaderBoardModel!.data!.isNotEmpty ?
                Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center,children: [
                    if(leaderboardController.leaderBoardModel!.data!.length>1)
                      Expanded(child: LeaderboardStageItem(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        index: 2,
                        profile: leaderboardController.leaderBoardModel!.data![1].driver?.profileImage??'',
                        name: '${leaderboardController.leaderBoardModel!.data![1].driver?.firstName??''} ',
                        tripCount: leaderboardController.leaderBoardModel!.data![1].totalRecords ?? 0,
                      )),


                    if(leaderboardController.leaderBoardModel!.data!.isNotEmpty)
                      Expanded(child: LeaderboardStageItem(
                        color: Theme.of(context).primaryColor,
                        index: 1,
                        profile: leaderboardController.leaderBoardModel!.data![0].driver!.profileImage!,
                        name: '${leaderboardController.leaderBoardModel!.data![0].driver!.firstName!} ',
                        tripCount: leaderboardController.leaderBoardModel!.data![0].totalRecords!,
                      )),


                    if(leaderboardController.leaderBoardModel!.data!.length>2)
                      Expanded(child: LeaderboardStageItem(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        index: 3,
                        profile: leaderboardController.leaderBoardModel!.data![2].driver!.profileImage!,
                        name: '${leaderboardController.leaderBoardModel!.data![2].driver!.firstName!} ',
                        tripCount: leaderboardController.leaderBoardModel!.data![2].totalRecords!,
                      )),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Padding(
                      padding: const EdgeInsets.fromLTRB(
                        Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraLarge,
                        Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall,
                      ),
                      child: Text('on_the_serial'.tr, style: textSemiBold)),

                  PaginatedListViewWidget(
                    scrollController: scrollController,
                    totalSize: leaderboardController.leaderBoardModel!.totalSize,
                    offset: (leaderboardController.leaderBoardModel != null && leaderboardController.leaderBoardModel!.offset != null) ?
                    int.parse(leaderboardController.leaderBoardModel!.offset.toString()) : null,
                    onPaginate: (int? offset) async {
                      // await leaderboardController.getLeaderboardList(offset!,leaderboardController.selectedFilterTypeName);
                    },

                    itemView: ListView.builder(
                      itemCount: leaderboardController.leaderBoardModel!.data!.length,
                      padding: const EdgeInsets.all(0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return LeaderBoardCardWidget(index: index,leaderBoard : leaderboardController.leaderBoardModel!.data![index]);
                      },
                    ),
                  ) ,
                ]):
                Padding(padding: EdgeInsets.only(top: Get.height/5), child: const NoDataWidget()) :
                SizedBox(height: Get.height,child: const NotificationShimmerWidget());
              }),
            ),
          ))
        ]);
      }),
    );
  }
}


class LeaderboardStageItem extends StatelessWidget {
  final Color color;
  final int index;
  final String name;
  final int tripCount;
  final bool isFirst;
  final bool isSecond;
  final String profile;
  const LeaderboardStageItem({super.key,
    required this.color,
    required this.index,
    required this.name,
    required this.tripCount,
    this.isFirst = false,
    this.isSecond = false, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(children: [
        Text(tripCount.toString().padLeft(2, '0'),
          style: textBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,
              color: index ==3? Theme.of(context).colorScheme.tertiaryContainer: color),),


        Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeSmall),
            child: Text('trips'.tr,style: textMedium.copyWith(
                fontSize: Dimensions.fontSizeExtraLarge,
                color: index ==3? Theme.of(context).colorScheme.tertiaryContainer: color))),

        Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
            child: ClipRRect(borderRadius: BorderRadius.circular(100),
                child: ImageWidget(image: '${Get.find<SplashController>().config!.imageBaseUrl!.profileImage!}/$profile', width: 50,height: 50,))),

        Container(width: 100, decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(Dimensions.paddingSizeSeven)),

          child: Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,
              vertical: index == 1? Dimensions.paddingSizeDefault :Dimensions.paddingSizeSmall),
            child: Column(children: [
              Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                  color: Colors.white, boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.25), blurRadius: 1, spreadRadius: 1, offset: const Offset(1,3))]),
                width: index == 1? 40 : index == 3? 25 : 30, height:  index == 1? 40 : index == 3? 25 : 30,
                child: Center(child: Text(index.toString(),
                  style: textBold.copyWith(fontSize: index == 1? Dimensions.fontSizeExtraLarge:index == 3? 10 : Dimensions.fontSizeDefault,
                      color:  index == 3? Theme.of(context).colorScheme.secondaryContainer : color),)),
              ),
              Padding(padding: EdgeInsets.only(top: index == 1? Dimensions.paddingSizeDefault :index == 3? 0: Dimensions.paddingSizeExtraSmall),
                child: Center(child: Text(name.toString(), maxLines: 2, style: textSemiBold.copyWith(color: index == 3? Theme.of(context).colorScheme.tertiaryContainer : Colors.white),)),)]),
          ),
        ),
      ],
      ),
    );
  }
}
