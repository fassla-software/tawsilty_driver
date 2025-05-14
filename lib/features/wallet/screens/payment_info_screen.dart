import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_view_widget.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/screens/add_payment_info_screen.dart';
import 'package:ride_sharing_user_app/features/wallet/screens/update_payment_info_screen.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/delete_confermation_dialog_widget.dart';
import 'package:ride_sharing_user_app/helper/string_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class PaymentInfoScreen extends StatefulWidget {
  const PaymentInfoScreen({super.key});

  @override
  State<PaymentInfoScreen> createState() => _PaymentInfoScreenState();
}

class _PaymentInfoScreenState extends State<PaymentInfoScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Get.find<WalletController>().getWithdrawMethodInfoList(1);
    Get.find<WalletController>().getWithdrawMethods();
    Get.find<WalletController>().toggleHintTextShow(true, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(title: 'withdraw_method'.tr, showBackButton: true),
        body: GetBuilder<WalletController>(builder: (walletController) {
          return Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(children: [
              walletController.isHindShow
                  ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeSmall),
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.15)),
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Row(children: [
                        Image.asset(
                          Images.ideaIcon,
                          height: Dimensions.paddingSizeLarge,
                          width: Dimensions.paddingSizeLarge,
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(child: Text('you_should_fill_up'.tr)),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        InkWell(
                          onTap: () =>
                              walletController.toggleHintTextShow(false, true),
                          child: Image.asset(
                            Images.crossIcon,
                            height: Dimensions.paddingSizeDefault,
                            width: Dimensions.paddingSizeDefault,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                      ]),
                    )
                  : const SizedBox(),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              InkWell(
                onTap: () => Get.to(() => const AddPaymentInfoScreen()),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.paddingSizeSmall),
                        border: Border.all(
                            color: Get.isDarkMode
                                ? Colors.white
                                : Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.25))),
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'add_new_withdraw_info'.tr,
                            style: textRegular.copyWith(
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                                fontSize: Dimensions.fontSizeDefault),
                          ),
                          Image.asset(Images.outlineAddIcon,
                              height: 24, width: 24)
                        ])),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Expanded(
                child: walletController.withdrawMethodInfoData != null
                    ? walletController.withdrawMethodInfoData!.data!.isNotEmpty
                        ? SingleChildScrollView(
                            controller: scrollController,
                            child: PaginatedListViewWidget(
                              scrollController: scrollController,
                              totalSize: walletController
                                  .withdrawMethodInfoData!.totalSize,
                              offset:
                                  (walletController.withdrawMethodInfoData !=
                                              null &&
                                          walletController
                                                  .withdrawMethodInfoData
                                                  ?.offset !=
                                              null)
                                      ? int.parse(walletController
                                          .withdrawMethodInfoData!.offset
                                          .toString())
                                      : null,
                              onPaginate: (int? offset) async {
                                if (kDebugMode) {
                                  print('==========offset========>$offset');
                                }
                                await walletController
                                    .getWithdrawMethodInfoList(offset!);
                              },
                              itemView: ListView.separated(
                                itemCount: walletController
                                        .withdrawMethodInfoData?.data?.length ??
                                    0,
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, dataIndex) {
                                  return Stack(children: [
                                    Positioned(
                                      bottom: 0,
                                      right: Get.find<LocalizationController>()
                                              .isLtr
                                          ? 3
                                          : null,
                                      left: Get.find<LocalizationController>()
                                              .isLtr
                                          ? null
                                          : 3,
                                      child: Image.asset(
                                        Images.paymentDesignIcon,
                                        width: Get.width * 0.4,
                                        color: Get.isDarkMode
                                            ? Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .color!
                                                .withOpacity(0.15)
                                            : null,
                                      ),
                                    ),
                                    Container(
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.05),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.25)),
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.paddingSizeDefault)),
                                      padding: const EdgeInsets.only(
                                          top: Dimensions.paddingSizeDefault,
                                          bottom: Dimensions.paddingSizeDefault,
                                          left: Dimensions.paddingSizeLarge,
                                          right: Dimensions.paddingSizeDefault),
                                      child: Column(children: [
                                        Align(
                                            alignment: Get.find<
                                                        LocalizationController>()
                                                    .isLtr
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: PopupMenuButton(
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: const BorderRadius
                                                    .all(Radius.circular(
                                                        Dimensions
                                                            .radiusDefault)),
                                                side: BorderSide(
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                    width: 0.5),
                                              ),
                                              color:
                                                  Theme.of(context).cardColor,
                                              onSelected: (status) {
                                                if (status == 1) {
                                                  Get.to(() =>
                                                      UpdatePaymentInfoScreen(
                                                        methods: walletController
                                                            .withdrawMethodInfoData!
                                                            .data![dataIndex],
                                                      ));
                                                } else {
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (_) =>
                                                        DeleteConfirmationDialogWidget(
                                                            methodId: walletController
                                                                .withdrawMethodInfoData!
                                                                .data![
                                                                    dataIndex]
                                                                .id),
                                                  );
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 1,
                                                  child: Row(children: [
                                                    Image.asset(Images.editIcon,
                                                        height: 16, width: 16),
                                                    const SizedBox(
                                                        width: Dimensions
                                                            .paddingSizeSmall),
                                                    Text('edit'.tr,
                                                        style: textRegular
                                                            .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .color,
                                                        ))
                                                  ]),
                                                ),
                                                PopupMenuItem(
                                                  value: 2,
                                                  child: Row(children: [
                                                    Icon(
                                                      CupertinoIcons
                                                          .delete_simple,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .error,
                                                      size: 16,
                                                    ),
                                                    const SizedBox(
                                                        width: Dimensions
                                                            .paddingSizeSmall),
                                                    Text('delete'.tr,
                                                        style: textRegular
                                                            .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .color,
                                                        ))
                                                  ]),
                                                ),
                                              ],
                                              child:
                                                  const Icon(Icons.more_vert),
                                            )),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    'method_name'.tr,
                                                    style: textRegular.copyWith(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .color,
                                                    ),
                                                  )),
                                              Expanded(
                                                flex: 1,
                                                child: Text(' : ',
                                                    style: textRegular.copyWith(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .color,
                                                    )),
                                              ),
                                              Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    walletController
                                                            .withdrawMethodInfoData
                                                            ?.data?[dataIndex]
                                                            .methodName ??
                                                        '',
                                                    style: textBold.copyWith(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .color,
                                                    ),
                                                  ))
                                            ]),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeSmall),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    'payment_method'.tr,
                                                    style: textRegular.copyWith(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .color,
                                                    ),
                                                  )),
                                              Expanded(
                                                flex: 1,
                                                child: Text(' : ',
                                                    style: textRegular.copyWith(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .color,
                                                    )),
                                              ),
                                              Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    walletController
                                                            .withdrawMethodInfoData
                                                            ?.data?[dataIndex]
                                                            .withdrawMethod
                                                            ?.methodName ??
                                                        '',
                                                    style: textBold.copyWith(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .color,
                                                    ),
                                                  ))
                                            ]),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeSmall),
                                        ListView.separated(
                                            itemCount: walletController
                                                    .withdrawMethodInfoData
                                                    ?.data?[dataIndex]
                                                    .methodInfo
                                                    ?.length ??
                                                0,
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, infoIndex) {
                                              return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        flex: 4,
                                                        child: Text(
                                                          walletController
                                                                  .withdrawMethodInfoData
                                                                  ?.data?[
                                                                      dataIndex]
                                                                  .methodInfo![
                                                                      infoIndex]
                                                                  .key!
                                                                  .toTitleCase() ??
                                                              '',
                                                          style: textRegular
                                                              .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .color,
                                                          ),
                                                        )),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(' : ',
                                                          style: textRegular
                                                              .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .color,
                                                          )),
                                                    ),
                                                    Expanded(
                                                        flex: 4,
                                                        child: Text(
                                                          walletController
                                                                  .withdrawMethodInfoData
                                                                  ?.data?[
                                                                      dataIndex]
                                                                  .methodInfo?[
                                                                      infoIndex]
                                                                  .value ??
                                                              '',
                                                          style:
                                                              textBold.copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .color,
                                                          ),
                                                        ))
                                                  ]);
                                            },
                                            separatorBuilder: (context, index) {
                                              return const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeSmall);
                                            }),
                                      ]),
                                    ),
                                  ]);
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                      height: Dimensions.paddingSizeSmall);
                                },
                              ),
                            ),
                          )
                        : const NoDataWidget(
                            title: 'no_transaction_found',
                          )
                    : const NotificationShimmerWidget(),
              )
            ]),
          );
        }));
  }
}
