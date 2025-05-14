import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({super.key}) ;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  @override
  void initState() {
    Get.find<TripController>().setParcelReturnDate(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.25)),
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        ),
        child:SfDateRangePicker(
          backgroundColor: Theme.of(context).cardColor,
          showNavigationArrow: true,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args){
            if(args.value !=null){
              Get.find<TripController>().setParcelReturnDate(DateFormat('yyyy-MM-dd').format(args.value));
            }
          },
            initialSelectedDate: DateTime.now(),
            maxDate: Get.find<SplashController>().config!.parcelReturnTimeFeeStatus! ?
            DateTime.now().add(Duration(
                days: Get.find<SplashController>().config?.parcelReturnTimeType == 'day' ?
                (Get.find<SplashController>().config?.parcelReturnTime ?? 2) :
                ((Get.find<SplashController>().config?.parcelReturnTime ?? 0)/24).floor(),
            )) : null,
            selectionMode: DateRangePickerSelectionMode.single,
            todayHighlightColor: Colors.transparent,
            selectionShape: DateRangePickerSelectionShape.circle,
            selectionTextStyle: textRegular.copyWith(color: Theme.of(context).cardColor),
            selectionColor: Theme.of(context).primaryColor,
            headerHeight: 50,
            toggleDaySelection: true,
            enablePastDates: false,
            headerStyle: DateRangePickerHeaderStyle(
            backgroundColor: Theme.of(context).cardColor,
            textAlign: TextAlign.center,
            textStyle: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
            monthViewSettings: const DateRangePickerMonthViewSettings(
              dayFormat: 'EE',
              viewHeaderHeight: 40,
              firstDayOfWeek: 1,
              numberOfWeeksInView: 6,
            ),
            monthCellStyle: DateRangePickerMonthCellStyle(
                todayTextStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color!
                )
            )
        )
    );
  }
}