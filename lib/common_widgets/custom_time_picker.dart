import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ride_sharing_user_app/common_widgets/time_picker_spinner.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class CustomTimePicker extends StatefulWidget {
  const CustomTimePicker({super.key}) ;

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  @override
  void initState() {
    Get.find<TripController>().setParcelReturnTime(DateFormat('HH:mm:ss').format(DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('time'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge,)),
          const SizedBox(width: Dimensions.paddingSizeLarge,),
          TimePickerSpinner(
              is24HourMode: false,
              normalTextStyle: textRegular.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeSmall),
              highlightedTextStyle: textMedium.copyWith(
                fontSize: Dimensions.fontSizeLarge*1, color: Theme.of(context).primaryColor,
              ),
              itemHeight: Dimensions.fontSizeLarge + 2,
              itemWidth: Get.width * 0.2,
              alignment: Alignment.topCenter,
              isForce2Digits: true,
              onTimeChange: (time) {
                Get.find<TripController>().setParcelReturnTime("${time.hour >= 10 ? '' : '0'}${time.hour}:${time.minute >= 10 ? '' : '0'}${time.minute}:${time.second >= 10 ? '' : '0'}${time.second}");
              },
          )
        ],
      ),
    );
  }
}