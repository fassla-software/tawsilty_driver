import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/payment_item_info_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/pending_settled_withdraw_model.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class PendingWithdrawnBottomsheetWidget extends StatelessWidget {
  final PendingSettleInfo pendingSettleInfo;
  const PendingWithdrawnBottomsheetWidget({super.key, required this.pendingSettleInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.5),
        width: double.infinity,
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
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.keyboard_arrow_down),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
          
            Text('transaction_details'.tr,
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
                  title: 'price'.tr,
                  amount: double.parse(pendingSettleInfo.amount.toString()),
                ),
          
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [
                    SizedBox(width:Dimensions.iconSizeSmall, child: Image.asset(Images.farePrice)),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
          
                    Text('status'.tr, style: textMedium.copyWith(color: Theme.of(context).primaryColor))
          
                  ]),
          
                  Text((pendingSettleInfo.status ?? '').tr, style: textMedium.copyWith(color: Theme.of(context).primaryColor))
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),
          
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [
                    SizedBox(width:Dimensions.iconSizeSmall, child: Image.asset(Images.farePrice)),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
          
                    Text('date&time'.tr, style: textMedium.copyWith(color: Theme.of(context).primaryColor))
          
                  ]),
          
                  Text(DateConverter.isoStringToDateTimeString(pendingSettleInfo.createdAt!),
                      style: textMedium.copyWith(color: Theme.of(context).primaryColor),
                  )
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),
          
                if(
                pendingSettleInfo.driverNote != null || pendingSettleInfo.approvalNote != null ||
                    pendingSettleInfo.deniedNote != null
                )...[
                  Row(children: [
                    SizedBox(width:Dimensions.iconSizeSmall, child: Image.asset(Images.farePrice)),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
          
                    Text('note'.tr, style: textMedium.copyWith(color: Theme.of(context).primaryColor))
                  ]),
          
                  Row(children: [
                    const SizedBox(width: Dimensions.paddingSizeExtraLarge),
          
                    Expanded(child: Text(
                        pendingSettleInfo.status == 'pending' ?
                        pendingSettleInfo.driverNote ?? '' :
                        pendingSettleInfo.status == 'approved' ?
                        pendingSettleInfo.approvalNote ?? '' :
                        pendingSettleInfo.deniedNote ?? '',
                        style: textMedium.copyWith(color: Theme.of(context).hintColor.withOpacity(0.75)),
                      ))
                  ]),
                ]
          
              ]),
            ),
          
          
          ]),
        ),
      ),
    );
  }
}
