import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_pop_scope_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/features/auth/screens/reset_password_screen.dart';
import 'package:ride_sharing_user_app/features/home/screens/vehicle_add_screen.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/profile/screens/edit_profile_screen.dart';
import 'package:ride_sharing_user_app/features/profile/widgets/profile_item_widget.dart';
import 'package:ride_sharing_user_app/features/profile/widgets/profile_type_button_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    Get.find<ProfileController>().getProfileLevelInfo();
    Get.find<ProfileController>().getProfileInfo();
    Get.find<WalletController>().getLoyaltyPointList(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScopeWidget(
      child: Scaffold(
        body: GetBuilder<ProfileController>(builder: (profileController) {
          return Stack(
            children: [
              Column(children: [
                AppBarWidget(
                  title: 'profile'.tr,
                  showBackButton: true,
                  onTap: () => Get.find<ProfileController>().toggleDrawer(),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Dimensions.paddingSizeDefault,
                    Dimensions.paddingSizeDefault,
                    Dimensions.paddingSizeDefault,
                    0,
                  ),
                  child: SingleChildScrollView(
                      child: Column(children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).hintColor.withOpacity(.25),
                            width: .5),
                        borderRadius:
                            BorderRadius.circular(Dimensions.paddingSizeSmall),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Dimensions.paddingSizeSmall),
                        child: profileController.profileTypeIndex != 2
                            ? ImageWidget(
                                width: 80,
                                height: 80,
                                image:
                                    '${Get.find<SplashController>().config!.imageBaseUrl!.profileImage}/'
                                    '${profileController.profileInfo!.profileImage!}',
                              )
                            : profileController.profileInfo!.vehicle != null
                                ? ImageWidget(
                                    width: 80,
                                    height: 80,
                                    image:
                                        '${Get.find<SplashController>().config!.imageBaseUrl!.vehicleCategory}/'
                                        '${profileController.profileInfo!.vehicle!.category!.image}',
                                  )
                                : const SizedBox(),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: profileController.profileTypeIndex != 1
                          ? null
                          : Colors.transparent,
                      onTap: () {
                        if (profileController.profileTypeIndex == 0) {
                          Get.to(() => ProfileEditScreen(
                              profileInfo: profileController.profileInfo!));
                        } else if (profileController.profileTypeIndex == 2) {
                          Get.to(() => VehicleAddScreen(
                              vehicleInfo:
                                  profileController.profileInfo?.vehicle));
                        }
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              profileController.profileTypeIndex != 2
                                  ? '${profileController.profileInfo?.firstName ?? ''}  '
                                      '${profileController.profileInfo?.lastName ?? ''}'
                                  : '${profileController.profileInfo?.vehicle?.brand?.name ?? ''} ${profileController.profileInfo?.vehicle?.model?.name ?? ''}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textBold.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: Dimensions.fontSizeLarge,
                              ),
                            ),
                            if (profileController.profileTypeIndex != 1)
                              const SizedBox(
                                  width: Dimensions.paddingSizeSmall),
                            if (profileController.profileTypeIndex == 0 ||
                                (profileController.profileTypeIndex == 2 &&
                                    profileController.profileInfo?.vehicle
                                            ?.brand?.name !=
                                        null))
                              SizedBox(
                                  width: Dimensions.iconSizeMedium,
                                  child: Image.asset(
                                    Images.editIcon,
                                    color: Theme.of(context).primaryColorDark,
                                  )),
                            const SizedBox(),
                          ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    profileController.profileTypeIndex != 2
                        ? Row(mainAxisSize: MainAxisSize.min, children: [
                            Text(
                              '${'your_ratting'.tr} : '
                              '${profileController.profileInfo!.avgRatting.toString()} ',
                            ),
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.orange,
                              size: Dimensions.iconSizeSmall,
                            ),
                          ])
                        : const SizedBox(),
                    if (profileController.profileTypeIndex == 1)
                      Container(
                        margin: const EdgeInsets.only(
                            top: Dimensions.paddingSizeSmall),
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeExtraSmall,
                          horizontal: Dimensions.paddingSizeSmall,
                        ),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.25),
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall)),
                        child: Text(
                            '${profileController.levelModel?.data?.currentLevel?.name}'),
                      ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                    profileController.profileTypeIndex == 0
                        ? Padding(
                            padding: const EdgeInsets.only(
                                right: Dimensions.paddingSizeDefault),
                            child: Column(children: [
                              if (Get.find<SplashController>()
                                  .config!
                                  .levelStatus!)
                                ProfileItemWidget(
                                  title: 'my_level',
                                  value:
                                      '${profileController.levelModel?.data?.currentLevel?.name}',
                                  isLevel: true,
                                ),
                              if (profileController
                                      .profileInfo?.details?.services !=
                                  null)
                                ProfileItemWidget(
                                  title: 'service',
                                  value: profileController.profileInfo!.details!
                                              .services!.length ==
                                          1
                                      ? profileController
                                          .profileInfo!.details!.services![0].tr
                                      : '${profileController.profileInfo!.details!.services![0].tr} & ${profileController.profileInfo!.details!.services![1].tr}',
                                ),
                              if (_isShowParcelWeight(profileController
                                  .profileInfo?.details?.services))
                                ProfileItemWidget(
                                  title: 'parcel_weight_capacity',
                                  value:
                                      '${profileController.profileInfo?.vehicle?.parcelWeightCapacity ?? 'unlimited'.tr}',
                                ),
                              ProfileItemWidget(
                                title: 'contact',
                                value: Get.find<LocalizationController>().isLtr
                                    ? profileController.profileInfo?.phone ?? ''
                                    : '${profileController.profileInfo!.phone!.substring(1)}+',
                              ),
                              ProfileItemWidget(
                                title: 'gender',
                                value:
                                    profileController.profileInfo?.gender == 0
                                        ? 'male'.tr
                                        : 'female'.tr,
                              ),
                              ProfileItemWidget(
                                title: 'mail_address',
                                value:
                                    profileController.profileInfo?.email ?? '',
                              ),
                              ProfileItemWidget(
                                title: 'identification_type',
                                value: profileController
                                    .profileInfo!.identificationType!.tr,
                              ),
                              ProfileItemWidget(
                                title: 'identification_number',
                                value: profileController
                                        .profileInfo?.identificationNumber ??
                                    '',
                              ),
                            ]),
                          )
                        : profileController.profileTypeIndex == 2
                            ? profileController.profileInfo!.vehicle != null
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        right: Dimensions.paddingSizeDefault),
                                    child: Column(children: [
                                      ProfileItemWidget(
                                        title: 'vehicle_category_type',
                                        value: profileController.profileInfo!
                                            .vehicle!.category!.type!.tr,
                                      ),
                                      ProfileItemWidget(
                                        title: 'vehicle_category',
                                        value: profileController.profileInfo!
                                            .vehicle!.category!.name!.tr,
                                      ),
                                      ProfileItemWidget(
                                        title: 'vehicle_brand',
                                        value: profileController.profileInfo
                                                ?.vehicle?.brand?.name ??
                                            '',
                                      ),
                                      ProfileItemWidget(
                                        title: 'vehicle_model',
                                        value: profileController.profileInfo
                                                ?.vehicle?.model?.name ??
                                            '',
                                      ),
                                      ProfileItemWidget(
                                        title: 'license_number_plate',
                                        value: profileController.profileInfo
                                                ?.vehicle?.licencePlateNumber ??
                                            '',
                                      ),
                                      ProfileItemWidget(
                                        title: 'license_expire_date',
                                        value: DateConverter
                                            .isoStringToLocalDateOnly(
                                          profileController.profileInfo?.vehicle
                                                  ?.licenceExpireDate ??
                                              '',
                                        ),
                                      ),
                                      ProfileItemWidget(
                                        title: 'fuel_type',
                                        value: profileController.profileInfo
                                                ?.vehicle?.fuelType ??
                                            '',
                                      ),
                                    ]),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50),
                                    child: Column(children: [
                                      Image.asset(
                                        Images.noVehicleFound,
                                        height: Get.height * 0.3,
                                        width: Get.width * 0.7,
                                      ),
                                      Text('ready_to_drive'.tr,
                                          style: textBold,
                                          textAlign: TextAlign.center),
                                      const SizedBox(
                                          height:
                                              Dimensions.paddingSizeDefault),
                                      Text(
                                        'you_have_allmost_ready'.tr,
                                        textAlign: TextAlign.center,
                                        style: textRegular.copyWith(
                                            color: Theme.of(context).hintColor),
                                      ),
                                      const SizedBox(
                                          height:
                                              Dimensions.paddingSizeDefault),
                                      ButtonWidget(
                                          width: 150,
                                          buttonText: 'add_vehicle'.tr,
                                          onPressed: () => Get.to(
                                              () => const VehicleAddScreen()))
                                    ]),
                                  )
                            : profileController.profileTypeIndex == 1
                                ? !profileController
                                        .levelModel!.data!.isCompleted!
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                            Text('upgrade_to_next_level'.tr),
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeExtraSmall),
                                            LinearProgressIndicator(
                                              value: _calculateProgressValue(
                                                  _calculateTotalTargetPoint(
                                                      profileController
                                                              .levelModel
                                                              ?.data
                                                              ?.completedCurrentLevelTarget
                                                              ?.rideCompletePoint ??
                                                          0,
                                                      profileController
                                                              .levelModel
                                                              ?.data
                                                              ?.completedCurrentLevelTarget
                                                              ?.earningAmountPoint ??
                                                          0,
                                                      profileController
                                                              .levelModel
                                                              ?.data
                                                              ?.completedCurrentLevelTarget
                                                              ?.cancellationRatePoint ??
                                                          0,
                                                      profileController
                                                              .levelModel
                                                              ?.data
                                                              ?.completedCurrentLevelTarget
                                                              ?.reviewGivenPoint ??
                                                          0),
                                                  _calculateTotalTargetPoint(
                                                      profileController
                                                              .levelModel
                                                              ?.data
                                                              ?.currentLevel
                                                              ?.targetedRidePoint ??
                                                          0,
                                                      profileController
                                                              .levelModel
                                                              ?.data
                                                              ?.currentLevel
                                                              ?.targetedAmountPoint ??
                                                          0,
                                                      profileController
                                                              .levelModel
                                                              ?.data
                                                              ?.currentLevel
                                                              ?.targetedCancelPoint ??
                                                          0,
                                                      profileController
                                                              .levelModel
                                                              ?.data
                                                              ?.currentLevel
                                                              ?.targetedReviewPoint ??
                                                          0)),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions
                                                          .paddingSizeSmall),
                                              minHeight:
                                                  Dimensions.paddingSizeSeven,
                                              backgroundColor: Theme.of(context)
                                                  .hintColor
                                                  .withOpacity(0.25),
                                            ),
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeExtraSmall),
                                            Align(
                                              alignment: Get.find<
                                                          LocalizationController>()
                                                      .isLtr
                                                  ? Alignment.centerLeft
                                                  : Alignment.centerRight,
                                              child:
                                                  Text.rich(TextSpan(children: [
                                                TextSpan(
                                                  text: 'earn_more'.tr,
                                                  style: textRegular.copyWith(
                                                      color: Theme.of(context)
                                                          .hintColor),
                                                ),
                                                TextSpan(
                                                    text:
                                                        ' ${_calculateTotalTargetPoint(profileController.levelModel?.data?.completedCurrentLevelTarget?.rideCompletePoint ?? 0, profileController.levelModel?.data?.completedCurrentLevelTarget?.earningAmountPoint ?? 0, profileController.levelModel?.data?.completedCurrentLevelTarget?.cancellationRatePoint ?? 0, profileController.levelModel?.data?.completedCurrentLevelTarget?.reviewGivenPoint ?? 0).toInt()}/${_calculateTotalTargetPoint(profileController.levelModel?.data?.currentLevel?.targetedRidePoint ?? 0, profileController.levelModel?.data?.currentLevel?.targetedAmountPoint ?? 0, profileController.levelModel?.data?.currentLevel?.targetedCancelPoint ?? 0, profileController.levelModel?.data?.currentLevel?.targetedReviewPoint ?? 0).toInt()} ',
                                                    style: textRegular.copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColor)),
                                                TextSpan(
                                                  text:
                                                      'point_for_next_level'.tr,
                                                  style: textBold.copyWith(
                                                      color: Theme.of(context)
                                                          .hintColor),
                                                ),
                                              ])),
                                            ),
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeDefault),
                                            if (profileController.levelModel
                                                    ?.data?.nextLevel !=
                                                null)
                                              Center(
                                                  child: Text.rich(
                                                      TextSpan(children: [
                                                TextSpan(
                                                    text: 'your_next_level_is'
                                                        .tr),
                                                const TextSpan(text: ' '),
                                                TextSpan(
                                                  text: profileController
                                                      .levelModel
                                                      ?.data
                                                      ?.nextLevel
                                                      ?.name,
                                                  style: textBold,
                                                )
                                              ]))),
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeExtraSmall),
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(Dimensions
                                                          .paddingSizeSmall),
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .hintColor
                                                          .withOpacity(0.25))),
                                              padding: const EdgeInsets.all(
                                                  Dimensions.paddingSizeSmall),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if ((profileController
                                                                .levelModel
                                                                ?.data
                                                                ?.currentLevel
                                                                ?.targetedRide
                                                                ?.toInt() ??
                                                            0) >
                                                        0)
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'trips_completed'
                                                                    .tr,
                                                                style: textRegular.copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .color)),
                                                            Text(
                                                              '${profileController.levelModel?.data?.completedCurrentLevelTarget?.rideComplete?.toInt()}/'
                                                              '${profileController.levelModel?.data?.currentLevel?.targetedRide?.toInt()}',
                                                              style: textRegular.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                          ]),
                                                    if ((profileController
                                                                .levelModel
                                                                ?.data
                                                                ?.currentLevel
                                                                ?.targetedRide
                                                                ?.toInt() ??
                                                            0) >
                                                        0)
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '${profileController.levelModel?.data?.completedCurrentLevelTarget?.rideCompletePoint?.toInt()} ${'points'.tr}',
                                                              style: textRegular.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                            SizedBox(
                                                                width:
                                                                    Get.width *
                                                                        0.3,
                                                                child:
                                                                    LinearProgressIndicator(
                                                                  value:
                                                                      _calculateProgressValue(
                                                                    profileController
                                                                            .levelModel
                                                                            ?.data
                                                                            ?.completedCurrentLevelTarget
                                                                            ?.rideComplete ??
                                                                        0,
                                                                    profileController
                                                                            .levelModel
                                                                            ?.data
                                                                            ?.currentLevel
                                                                            ?.targetedRide ??
                                                                        0,
                                                                  ),
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          Dimensions
                                                                              .paddingSizeSmall),
                                                                  minHeight:
                                                                      Dimensions
                                                                          .paddingSizeSeven,
                                                                  backgroundColor: Theme.of(
                                                                          context)
                                                                      .hintColor
                                                                      .withOpacity(
                                                                          0.25),
                                                                ))
                                                          ]),
                                                    const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeSmall),
                                                    if ((profileController
                                                                .levelModel
                                                                ?.data
                                                                ?.currentLevel
                                                                ?.targetedReview
                                                                ?.toInt() ??
                                                            0) >
                                                        0)
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'review_given'
                                                                    .tr,
                                                                style: textRegular.copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .color)),
                                                            Text(
                                                              '${profileController.levelModel?.data?.completedCurrentLevelTarget?.reviewGiven?.toInt()}/'
                                                              '${profileController.levelModel?.data?.currentLevel?.targetedReview?.toInt()}',
                                                              style: textRegular.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            )
                                                          ]),
                                                    if ((profileController
                                                                .levelModel
                                                                ?.data
                                                                ?.currentLevel
                                                                ?.targetedReview
                                                                ?.toInt() ??
                                                            0) >
                                                        0)
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '${profileController.levelModel?.data?.completedCurrentLevelTarget?.reviewGivenPoint?.toInt()} ${'points'.tr}',
                                                              style: textRegular.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                            SizedBox(
                                                                width:
                                                                    Get.width *
                                                                        0.3,
                                                                child:
                                                                    LinearProgressIndicator(
                                                                  value: _calculateProgressValue(
                                                                      profileController
                                                                              .levelModel
                                                                              ?.data
                                                                              ?.completedCurrentLevelTarget
                                                                              ?.reviewGiven ??
                                                                          0,
                                                                      profileController
                                                                              .levelModel
                                                                              ?.data
                                                                              ?.currentLevel
                                                                              ?.targetedReview ??
                                                                          0),
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          Dimensions
                                                                              .paddingSizeSmall),
                                                                  minHeight:
                                                                      Dimensions
                                                                          .paddingSizeSeven,
                                                                  backgroundColor: Theme.of(
                                                                          context)
                                                                      .hintColor
                                                                      .withOpacity(
                                                                          0.25),
                                                                ))
                                                          ]),
                                                    const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeSmall),
                                                    if ((profileController
                                                                .levelModel
                                                                ?.data
                                                                ?.currentLevel
                                                                ?.targetedCancel
                                                                ?.toInt() ??
                                                            0) >
                                                        0)
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'maximum_cancellation_rate'
                                                                    .tr,
                                                                style: textRegular.copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .color)),
                                                            Text(
                                                              '${profileController.levelModel?.data?.completedCurrentLevelTarget?.cancellationRate?.toInt()}/'
                                                              '${profileController.levelModel?.data?.currentLevel?.targetedCancel?.toInt()}',
                                                              style: textRegular.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            )
                                                          ]),
                                                    if ((profileController
                                                                .levelModel
                                                                ?.data
                                                                ?.currentLevel
                                                                ?.targetedCancel
                                                                ?.toInt() ??
                                                            0) >
                                                        0)
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '${profileController.levelModel?.data?.completedCurrentLevelTarget?.cancellationRatePoint?.toInt()} ${'points'.tr}',
                                                              style: textRegular.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                            SizedBox(
                                                                width:
                                                                    Get.width *
                                                                        0.3,
                                                                child:
                                                                    LinearProgressIndicator(
                                                                  value:
                                                                      _calculateProgressValue(
                                                                    profileController
                                                                            .levelModel
                                                                            ?.data
                                                                            ?.currentLevel
                                                                            ?.targetedCancel ??
                                                                        0,
                                                                    (profileController.levelModel?.data?.completedCurrentLevelTarget?.cancellationRate ??
                                                                                0) ==
                                                                            0
                                                                        ? 1
                                                                        : profileController.levelModel?.data?.completedCurrentLevelTarget?.cancellationRate ??
                                                                            1,
                                                                  ),
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          Dimensions
                                                                              .paddingSizeSmall),
                                                                  minHeight:
                                                                      Dimensions
                                                                          .paddingSizeSeven,
                                                                  backgroundColor: Theme.of(
                                                                          context)
                                                                      .hintColor
                                                                      .withOpacity(
                                                                          0.25),
                                                                ))
                                                          ]),
                                                    const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeSmall),
                                                    if ((profileController
                                                                .levelModel
                                                                ?.data
                                                                ?.currentLevel
                                                                ?.targetedAmount
                                                                ?.toInt() ??
                                                            0) >
                                                        0)
                                                      Text('minimum_earned'.tr,
                                                          style: textRegular.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .color)),
                                                    if ((profileController
                                                                .levelModel
                                                                ?.data
                                                                ?.currentLevel
                                                                ?.targetedAmount
                                                                ?.toInt() ??
                                                            0) >
                                                        0)
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '${profileController.levelModel?.data?.completedCurrentLevelTarget?.earningAmountPoint?.toInt()} ${'points'.tr}',
                                                              style: textRegular.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                            Text(
                                                              '${PriceConverter.convertPrice(context, profileController.levelModel?.data?.completedCurrentLevelTarget?.earningAmount ?? 0)} of '
                                                              '${PriceConverter.convertPrice(context, profileController.levelModel?.data?.currentLevel?.targetedAmount ?? 0)}',
                                                              style: textRobotoRegular.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                          ]),
                                                  ]),
                                            )
                                          ])
                                    : Text('you_reached_the_maximum_level'.tr,
                                        style: textBold)
                                : const SizedBox(),
                    profileController.profileTypeIndex == 0
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusDefault),
                              border: Border.all(
                                  color: Theme.of(context).hintColor),
                            ),
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeDefault),
                            child: GestureDetector(
                              onTap: () =>
                                  Get.to(() => const ResetPasswordScreen(
                                        phoneNumber: '',
                                        fromChangePassword: true,
                                      )),
                              child: Row(children: [
                                SizedBox(
                                  width: Dimensions.iconSizeMedium,
                                  child: Image.asset(Images.changePasswordIcon),
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeSmall),
                                Text('change_password'.tr,
                                    style: textRegular.copyWith(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeDefault,
                                    ))
                              ]),
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    profileController.profileInfo!.isOldIdentificationImage! &&
                            profileController.profileTypeIndex == 0
                        ? Row(children: [
                            const SizedBox(
                                width: Dimensions.iconSizeMedium,
                                child: Icon(Icons.error)),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Text(
                              'identity_info_is_pending_for_approval'.tr,
                              style: textBold.copyWith(
                                  fontSize: Dimensions.fontSizeDefault),
                            )
                          ])
                        : const SizedBox(),
                  ])),
                ))
              ]),
              Positioned(
                top: Dimensions.topSpace,
                left: Dimensions.paddingSizeSmall,
                child: SizedBox(
                  height: Get.find<LocalizationController>().isLtr ? 45 : 50,
                  width: Get.width - Dimensions.paddingSizeDefault,
                  child: Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: profileController.profileType.length,
                      itemBuilder: (context, index) {
                        if (!(Get.find<SplashController>()
                                    .config!
                                    .levelStatus! ==
                                false &&
                            index == 1)) {
                          return SizedBox(
                              width: Get.width / 2.3,
                              child: ProfileTypeButtonWidget(
                                profileTypeName:
                                    profileController.profileType[index],
                                index: index,
                              ));
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  double _calculateTotalTargetPoint(
      double targetedRidePoint,
      double targetedAmountPoint,
      double targetedCancelPoint,
      double targetedReviewPoint) {
    return targetedRidePoint +
        targetedAmountPoint +
        targetedCancelPoint +
        targetedReviewPoint;
  }

  double _calculateProgressValue(double completeValue, double targetValue) {
    return (1 / targetValue) * completeValue;
  }

  bool _isShowParcelWeight(List<String>? services) {
    if (services == null) {
      return false;
    } else {
      if (services.contains('parcel')) {
        return true;
      } else {
        return false;
      }
    }
  }
}
