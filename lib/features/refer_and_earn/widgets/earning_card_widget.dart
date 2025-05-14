import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/common_widgets/divider_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/transaction_model.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class EarningCartWidget extends StatelessWidget {
  final Transaction transaction;
  const EarningCartWidget({super.key,required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
        child:Column(children: [
          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            child: Row(children: [
              Image.asset(
                Images.myEarnIcon,
                height: Dimensions.paddingSizeExtraLarge,
                width: Dimensions.paddingSizeExtraLarge,
              ),

              Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    transaction.attribute ?? '',
                    style: textRegular,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                    child: Text(DateConverter.isoStringToDateTimeString(transaction.createdAt ?? '2024-07-13T04:59:40.000000Z'),
                        style: textRegular.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeExtraSmall)),
                  ),
                ])),
              ])),

              Text(
                '+${PriceConverter.convertPrice(context, transaction.credit ?? 0)}',
                style: textRobotoBold.copyWith(color: Theme.of(context).primaryColor),
              ),

            ]),
          ),

          DividerWidget(height: .5,color: Theme.of(context).hintColor.withOpacity(0.75)),

        ])
    );
  }
}