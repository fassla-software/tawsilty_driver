import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/map/widgets/parcel_custom_radio_button.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ParcelCancellationList extends StatefulWidget {
  final bool isOngoing;
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const ParcelCancellationList({super.key, required this.isOngoing, required this.expandableKey});

  @override
  State<ParcelCancellationList> createState() => _ParcelCancellationListState();
}

class _ParcelCancellationListState extends State<ParcelCancellationList> {
  late final KeyboardVisibilityController _keyboardVisibilityController;
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    _keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = _keyboardVisibilityController.onChange.listen((isVisible) {
      if (!isVisible) {
        Get.find<RideController>().focusOnBottomSheet(widget.expandableKey);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(builder: (tripController) {
      return Column(children: [
        if((widget.isOngoing ?
        tripController.parcelCancellationCauseList!.data!.ongoingRide!.length :
        tripController.parcelCancellationCauseList!.data!.acceptedRide!.length) > 1)
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.isOngoing ?
          tripController.parcelCancellationCauseList!.data!.ongoingRide!.length :
          tripController.parcelCancellationCauseList!.data!.acceptedRide!.length,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return ParcelCustomRadioButton(
              text: widget.isOngoing ?
              tripController.parcelCancellationCauseList!.data!.ongoingRide![index] :
              tripController.parcelCancellationCauseList!.data!.acceptedRide![index],
              isSelected: tripController.parcelCancellationCurrentIndex == index,
              onTap: () {
                tripController.setParcelCancellationCurrentIndex(index);
                setState(() {});
              },
            );
          },
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeLarge),
            child: TextField(
              controller: tripController.othersCancellationController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  borderSide: BorderSide(width: 0.5, color: Theme.of(context).hintColor.withOpacity(0.5)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  borderSide: BorderSide(width: 0.5, color: Theme.of(context).hintColor.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  borderSide: BorderSide(width: 0.5, color: Theme.of(context).hintColor.withOpacity(0.5)),
                ),
                hintText: 'type_here_your_cancel_reason'.tr,
                hintStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ),
              readOnly: (widget.isOngoing ?
              tripController.parcelCancellationCauseList!.data!.ongoingRide!.length-1 :
              tripController.parcelCancellationCauseList!.data!.acceptedRide!.length -1) != tripController.parcelCancellationCurrentIndex,
              maxLines: 2,
              style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              onTap: () => Get.find<RideController>().focusOnBottomSheet(widget.expandableKey),
            )
          ),
        const SizedBox(height: Dimensions.paddingSizeSmall)
      ]);
    });
  }
}
