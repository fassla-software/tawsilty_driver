
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/income_statement_list_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/payable_transaction_list_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/pending_settled_list_widget.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/profile/screens/profile_menu_screen.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/loyalty_point_list_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/wallet_amount_type_card_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/wallet_money_amount_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/zoom_drawer_context_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/type_button_widget.dart';


class WalletScreenMenu extends GetView<ProfileController> {
  const WalletScreenMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (_) => ZoomDrawer(
        controller: _.zoomDrawerController,
        menuScreen: const ProfileMenuScreen(),
        mainScreen: const WalletScreen(),
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




class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Get.find<WalletController>().getWithdrawPendingList(1);
    Get.find<WalletController>().getPayableHistoryList(1);
    Get.find<WalletController>().getIncomeStatement(1);
    Get.find<ProfileController>().getProfileInfo();
    Get.find<WalletController>().getLoyaltyPointList(1);
    Get.find<WalletController>().getWithdrawMethodInfoList(1);
    Get.find<WalletController>().setSelectedHistoryIndex(1,false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Stack( children: [
      Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(controller: scrollController, slivers: [
          SliverAppBar(
              pinned: true,
              elevation: 0,
              centerTitle: false,
              toolbarHeight: 80,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).highlightColor,
              flexibleSpace:
              GetBuilder<WalletController>(builder: (walletController) {
                return AppBarWidget(
                  title: 'my_wallet'.tr,
                  showBackButton: false,
                  onTap: (){
                  Get.find<ProfileController>().toggleDrawer();
                  },
                );
              })
          ),

          SliverToBoxAdapter(child: GetBuilder<WalletController>(builder: (walletController) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
               SizedBox(height: Get.height * 0.05),

              walletController.walletTypeIndex != 2 ?
              const WalletMoneyAmountWidget() :
              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Text(
                  'income_statements'.tr,
                  style: textBold.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                    fontSize: Dimensions.fontSizeExtraLarge,
                  ),
                ),
              ),

              if(walletController.walletTypeIndex != 1)
              GetBuilder<ProfileController>(builder: (profileController) {
                return Padding(
                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                  child: SizedBox(height: 165,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: [
                        if(walletController.walletTypeIndex == 0)...[
                          GestureDetector(
                            onTap: walletController.isLoading ? null : (){
                              walletController.setSelectedHistoryIndex(1, true);
                            },
                            child: WalletAmountTypeCardWidget(icon: Images.pendingWithdrawn,
                              amount: profileController.profileInfo?.wallet?.pendingBalance ?? 0,
                              title: 'pending_withdrawn'.tr,
                              haveBorderColor: walletController.selectedHistoryIndex == 1 ? true : false,
                            ),
                          ),

                          GestureDetector(
                            onTap: walletController.isLoading ? null : (){
                              walletController.setSelectedHistoryIndex(2, true);
                            },
                            child: WalletAmountTypeCardWidget(icon: Images.allreadyWithdrawnIcon,
                              amount: profileController.profileInfo?.wallet?.totalWithdrawn ?? 0,
                              title: 'already_withdrawn'.tr,
                              haveBorderColor: walletController.selectedHistoryIndex == 2 ? true : false,
                            ),
                          ),

                          GestureDetector(
                            onTap: walletController.isLoading ? null : (){
                              walletController.setSelectedHistoryIndex(3, true);
                            },
                            child: WalletAmountTypeCardWidget(icon: Images.paidBalanceIcon,
                              amount:profileController.profileInfo?.paidAmount ?? 0,
                              title: 'paid_amount'.tr,
                              haveBorderColor: walletController.selectedHistoryIndex == 3 ? true : false,
                            ),
                          ),

                          GestureDetector(
                            onTap: walletController.isLoading ? null : (){
                              walletController.setSelectedHistoryIndex(4, true);
                            },
                            child: WalletAmountTypeCardWidget(icon: Images.walletBalanceIcon,
                              amount: profileController.profileInfo?.levelUpRewardAmount ?? 0,
                              title: 'level_up_reward'.tr,
                              haveBorderColor: walletController.selectedHistoryIndex == 4 ? true : false,
                            ),
                          ),
                        ],

                        if(walletController.walletTypeIndex == 2)...[
                          if(profileController.profileInfo != null && profileController.profileInfo!.wallet != null)
                            WalletAmountTypeCardWidget(icon: Images.totalEarning,
                              amount: profileController.profileInfo?.totalEarning ?? 0,
                              title: 'total_earning'.tr,
                            ),

                          WalletAmountTypeCardWidget(icon: Images.pendingWithdrawn ,
                            amount: profileController.profileInfo?.tripIncome ?? 0,
                            title: 'trips_income'.tr,
                          ),

                          WalletAmountTypeCardWidget(icon: Images.withdrawMoneyIcon,
                            amount: profileController.profileInfo?.totalTips ?? 0,
                            title: 'total_tips'.tr,
                          ),

                          WalletAmountTypeCardWidget(icon: Images.totalCommissionIcon,
                            amount: profileController.profileInfo?.totalCommission ?? 0,
                            title: 'total_commission'.tr,
                          ),
                        ]

                      ],
                    ),
                  ),
                );
              }),
            ]);
          })),

          SliverToBoxAdapter(
            child: GetBuilder<WalletController>(builder: (walletController) {
              return Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Row(children: [
                    Text(
                      (walletController.walletTypeIndex == 0 || walletController.walletTypeIndex == 2)?
                      'transaction_history'.tr :
                      'point_gained_history'.tr,
                      style: textBold.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
                        fontSize: Dimensions.fontSizeExtraLarge,
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                if(walletController.walletTypeIndex == 0)
                  (walletController.selectedHistoryIndex == 1 ||
                      walletController.selectedHistoryIndex == 2) ?
                  PendingSettledListWidget(
                    walletController: walletController,
                    scrollController: scrollController,
                  ) :
                  PayableTransactionListWidget(
                    walletController: walletController,
                    scrollController: scrollController,
                  ),

                if(walletController.walletTypeIndex == 1)
                  LoyaltyPointTransactionListWidget(walletController: walletController),

                if(walletController.walletTypeIndex == 2)
                  IncomeStatementListWidget(
                      walletController: walletController,
                      scrollController: scrollController,
                  ),

              ]);
            }),
          )
        ]),
      ),

      Positioned(top: Get.height * (GetPlatform.isIOS ? 0.13 :  0.11),
        child: GetBuilder<WalletController>(builder: (walletController) {
          return Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
            child: SizedBox(
              height: Get.find<LocalizationController>().isLtr ? 45 : 50,
              width: Get.width-Dimensions.paddingSizeDefault,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: walletController.walletTypeList.length,
                itemBuilder: (context, index){
                  return SizedBox(width: 200,
                    child: TypeButtonWidget(
                      index: index,
                      name: walletController.walletTypeList[index],
                      selectedIndex: walletController.walletTypeIndex,
                      onTap: ()=> walletController.setWalletTypeIndex(index),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    ]);
  }
}


class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;
  SliverDelegate({required this.child, this.height = 70});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height || oldDelegate.minExtent != height || child != oldDelegate.child;
  }
}