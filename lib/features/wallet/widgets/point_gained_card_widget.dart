import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/transaction_model.dart';
import 'package:ride_sharing_user_app/common_widgets/divider_widget.dart';

class PointGainedCardWidget extends StatelessWidget {
  final Transaction myEarnModel;
  const PointGainedCardWidget({super.key, required this.myEarnModel});

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
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child:
                    Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: Dimensions.iconSizeLarge,
                            child: Image.asset(Images.coin)),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(myEarnModel.attribute!, style: textSemiBold.copyWith(color: Theme.of(context).primaryColor)),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                              child: Text(DateConverter.isoStringToDateTimeString(myEarnModel.createdAt!),
                                style: textRegular.copyWith(color: Theme.of(context).hintColor),),
                            ),

                          ],),
                      ],
                    )),
                    Text('${myEarnModel.id} ${'point'.tr}', style: textSemiBold.copyWith(color: Theme.of(context).primaryColor),)
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
