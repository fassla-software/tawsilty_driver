import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/payment_item_info_widget.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ImcomStatementBottomsheetWidget extends StatelessWidget {
  final TripDetail tripDetail;
  const ImcomStatementBottomsheetWidget({super.key, required this.tripDetail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(width: double.infinity,
        decoration: BoxDecoration(color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft:  Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: Dimensions.paddingSizeDefault,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Icon(Icons.keyboard_arrow_down),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Text('${'trip'.tr}# ${tripDetail.refId}'.tr,
            style: textSemiBold.copyWith(color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
            ),
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(children: [
              PaymentItemInfoWidget(
                  icon: Images.farePrice,
                  title: 'fare_price'.tr,
                  amount: _calculateFarePrice(
                    double.parse(tripDetail.paidFare ?? '0'),
                    tripDetail.adminCommission ?? 0,
                    tripDetail.tips ?? 0,
                  ),
                toolTipText: 'include_idle_waiting_fee'.tr,
              ),

              if(tripDetail.couponAmount != 0 )
              PaymentItemInfoWidget(
                icon: Images.coupon,
                title: 'coupon_amount'.tr,
                amount: tripDetail.couponAmount ?? 0,
              ),

              if(tripDetail.discountAmount != 0 )
              PaymentItemInfoWidget(
                icon: Images.discountIcon,
                title: 'discount_amount'.tr,
                amount: tripDetail.discountAmount ?? 0,
              ),

              if(tripDetail.tips != 0 )
              PaymentItemInfoWidget(
                  icon: Images.tipsIcon,
                  title: 'tips'.tr,
                  amount: tripDetail.tips ?? 0,
              ),

              PaymentItemInfoWidget(
                title: 'sub_total'.tr,
                amount: _calculateSubTotal(
                  double.parse(tripDetail.paidFare ?? '0'),
                  tripDetail.adminCommission ?? 0,
                  tripDetail.couponAmount ?? 0,
                  tripDetail.discountAmount ?? 0,
                ),
                isSubTotal: true,
              ),


            ]),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Row(children: [
              Icon(Icons.info_outline_rounded,color: Theme.of(context).colorScheme.primaryContainer),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              Flexible(child: Text('income_hint_note'.tr,style: textRegular))
            ]),
          )

        ]),
      ),
    );
  }
}

double _calculateFarePrice(
    double paidFare, double adminCommission, double tips
    ){
  return paidFare   - adminCommission - tips;
}

double _calculateSubTotal(
    double paidFare, double adminCommission, double coupon, double discount,
    ){
  return paidFare + coupon + discount  - adminCommission;
}