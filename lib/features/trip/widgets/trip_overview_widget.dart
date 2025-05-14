import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/features/review/screens/review_screen.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/chart_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/title_widget.dart';

class TripOverviewWidget extends StatelessWidget {
  final TripController tripController;
  const TripOverviewWidget({super.key, required this.tripController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: GetBuilder<TripController>(builder: (tripController) {
          return Stack(children: [
            Column(children: [
              const SizedBox(height: 80),

              const SizedBox(height: 220, child: ChartWidget()),

              TitleWidget(title: 'reports'.tr,color: Theme.of(context).textTheme.bodyMedium!.color),

              ReportsItemCard(title: 'total_trip', qty: tripController.tripOverView?.totalTrips?? 0),

              ReportsItemCard(title: 'total_trip_amount', amount: tripController.tripOverView?.totalEarn?? 0, isTotal: true),

              ReportsItemCard(title: 'total_cancel_trip', qty: tripController.tripOverView?.totalCancel?? 0),

              GestureDetector(
                  onTap: ()=> Get.to(const ReviewScreen()),
                  child: ReportsItemCard(title: 'total_review', qty: tripController.tripOverView?.totalReviews ?? 0)
              ),
              const SizedBox(height: 100),
            ]),

            Positioned(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Row(children: [
                Text('trips_overview'.tr, style: textSemiBold.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color, fontSize: Dimensions.fontSizeExtraLarge,
                )),

                const Spacer(),

                Container(
                  width: Dimensions.dropDownWidth + 20,
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))
                    ),
                    hint:  Text(tripController.selectedOverview.tr, style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)),
                    items: tripController.selectedOverviewType.map((item) => DropdownMenuItem<String>(
                        value: item, child: Text(item.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium!.color))
                    )).toList(),
                    onChanged: (value) {
                      tripController.setOverviewType(value!);
                    },
                    buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(right: 8)),
                    iconStyleData: IconStyleData(icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).hintColor), iconSize: 24),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    ),
                    menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 16)),
                  ),
                )

              ]),
            )),
          ]);
        }),
      ),
    );
  }
}


class ReportsItemCard extends StatelessWidget {
  final String? title;
  final double? amount;
  final bool isTotal;
  final int? qty;
  final bool isReview;
  const ReportsItemCard({super.key, this.title, this.amount, this.isTotal = false, this.qty, this.isReview = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault,Dimensions.paddingSizeSmall),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(.05),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
          Text(title!.tr,style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)),

          isTotal ?
          Text(PriceConverter.convertPrice(context, amount!),style: textRobotoMedium.copyWith(color: Theme.of(context).primaryColor)) :
          isReview ?
          Text(amount!.toString(),style: textMedium.copyWith(color: Theme.of(context).primaryColor)) :
          Text(qty!.toString(),style: textMedium.copyWith(color: Theme.of(context).primaryColor))

        ]),
      ),
    );
  }
}
