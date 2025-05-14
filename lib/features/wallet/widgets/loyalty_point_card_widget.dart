import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/loyalty_point_model.dart';
import 'package:ride_sharing_user_app/common_widgets/divider_widget.dart';

class LoyaltyPointCardWidget extends StatelessWidget {
  final Points points;
  const LoyaltyPointCardWidget({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
      child: GetBuilder<WalletController>(
          builder: (walletController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  child: Row(children: [
                    Expanded(child:
                    Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(' ${points.model!.tr}', style: textSemiBold.copyWith(color: Theme.of(context).primaryColor)),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                child: Text(DateConverter.isoStringToDateTimeString(points.createdAt?? '2023-05-17T06:17:49.000000Z'),
                                  style: textRegular.copyWith(color: Theme.of(context).hintColor),),
                              ),

                            ],),
                        ),
                      ],
                    )),
                    Container(
                        padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSeven),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color:points.type == 'debit' ?
                            Theme.of(context).colorScheme.error.withOpacity(.15) :
                            Theme.of(context).primaryColor.withOpacity(.15)),
                        child: Text(points.points!.toInt().toString(),
                            style: textBold.copyWith(
                              color: points.type == 'debit' ?
                                  Theme.of(context).colorScheme.error :
                              Theme.of(context).primaryColor,
                            ),
                        ))
                  ],),
                ),
                DividerWidget(height: .5,color: Theme.of(context).hintColor.withOpacity(.75),)
              ],
            );
          }
      ),
    );
  }
}
