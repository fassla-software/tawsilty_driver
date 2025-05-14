import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_view_widget.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer_widget.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/controllers/refer_and_earn_controller.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/widgets/custom_itle.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/widgets/earning_card_widget.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ReferralEarningScreen extends StatelessWidget {
  const ReferralEarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeSmall,
          horizontal: Dimensions.paddingSizeDefault),
      child:
          GetBuilder<ReferAndEarnController>(builder: (referAndEarnController) {
        return Column(children: [
          Container(
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(Dimensions.paddingSizeDefault),
                color: Theme.of(context).highlightColor.withOpacity(0.1),
                border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.1))),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('your_earning'.tr),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Text(
                            PriceConverter.convertPrice(
                                context,
                                Get.find<ProfileController>()
                                        .profileInfo
                                        ?.wallet
                                        ?.referralEarn ??
                                    0),
                            style: textRobotoBold.copyWith(
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                                fontSize: 20))
                      ]),
                  Image.asset(Images.loyaltyPoint, height: 40, width: 40)
                ]),
          ),
          CustomTitle(
              title: 'earning_history'.tr,
              color: Theme.of(context).textTheme.bodyMedium!.color),
          Divider(
              thickness: .25,
              color: Theme.of(context).primaryColor.withOpacity(0.25)),
          referAndEarnController.referralModel?.data != null
              ? (referAndEarnController.referralModel!.data!.isNotEmpty)
                  ? Expanded(
                      child: SingleChildScrollView(
                      controller: referAndEarnController.scrollController,
                      child: PaginatedListViewWidget(
                        scrollController:
                            referAndEarnController.scrollController,
                        totalSize:
                            referAndEarnController.referralModel!.totalSize,
                        offset: (referAndEarnController.referralModel?.offset !=
                                null)
                            ? int.parse(referAndEarnController
                                .referralModel!.offset
                                .toString())
                            : null,
                        onPaginate: (int? offset) async {
                          await referAndEarnController
                              .getEarningHistoryList(offset!);
                        },
                        itemView: ListView.builder(
                          itemCount: referAndEarnController
                              .referralModel!.data!.length,
                          padding: const EdgeInsets.all(0),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return EarningCartWidget(
                                transaction: referAndEarnController
                                    .referralModel!.data![index]);
                          },
                        ),
                      ),
                    ))
                  : const Expanded(
                      child: NoDataWidget(title: 'no_transaction_found'))
              : const Expanded(child: NotificationShimmerWidget()),
        ]);
      }),
    );
  }
}
