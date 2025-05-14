import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/divider_widget.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/imcom_statement_bottomsheet_widget.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class IncomeStatementCardWidget extends StatelessWidget {
  final List<TripDetail> tripDetails;
  const IncomeStatementCardWidget({super.key, required this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(DateConverter.isoStringToLocalDateOnly(tripDetails[0].createdAt!),style: textRegular),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
              border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.25))
          ),
          child: ListView.builder(
            itemCount: tripDetails.length,
            padding: const EdgeInsets.all(0),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Column(children: [
                  InkWell(
                    onTap: (){
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: context,
                        builder: (_) => ImcomStatementBottomsheetWidget(tripDetail: tripDetails[index]),
                      );
                      },
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: GetBuilder<WalletController>(builder: (walletController) {
                        return Row(children: [
                          Expanded(child: Row(children: [
                            SizedBox(
                              width: Dimensions.iconSizeLarge,
                              child: Image.asset(Images.incomeStatementCarIcon),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('${'trip'.tr}# ${tripDetails[index].refId}'.tr,
                                  style: textSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                                ),
                                (tripDetails[index].tips ?? 0) > 0 ?
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                  child: Text('${'tips'.tr} +${
                                      PriceConverter.convertPrice(context, tripDetails[index].tips ?? 0)
                                  }',
                                    style: textRobotoRegular.copyWith(color: Theme.of(context).hintColor),
                                  ),
                                ) :
                                const SizedBox(),
                              ]),
                            ),
                          ])),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault,
                              vertical: Dimensions.paddingSizeSeven,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context).primaryColor.withOpacity(.08)
                            ),
                            child: Text(PriceConverter.convertPrice(
                              context, _calculateDriverIncome(
                              double.parse(tripDetails[index].paidFare ?? '0'),
                              tripDetails[index].adminCommission ?? 0,
                              tripDetails[index].couponAmount ?? 0,
                              tripDetails[index].discountAmount ?? 0,
                            ),
                            ), style: textRobotoBold.copyWith(color: Theme.of(context).primaryColor)),
                          )
                        ]);
                      }),
                    ),
                  ),

                index != tripDetails.length - 1 ?
                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: DividerWidget(height: .5,color: Theme.of(context).hintColor.withOpacity(.75)),
                ) :
                const SizedBox(),
                ]);
            },
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall)

      ]),
    );
  }
}

double _calculateDriverIncome(
    double paidFare, double adminCommission, double coupon, double discount,
    ){
  return paidFare + coupon + discount  - adminCommission;
}
