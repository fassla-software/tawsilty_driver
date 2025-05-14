import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class BidAcceptingDialogueWidget extends StatelessWidget {
  final bool isStartedTrip;
  const BidAcceptingDialogueWidget({super.key,  this.isStartedTrip = false});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [

        const SizedBox(width: 40,height: 40, child: CircularProgressIndicator(strokeWidth: 10,)),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        isStartedTrip?
        Text('your_trip_is_about_to_start'.tr,textAlign: TextAlign.center,
            style: textMedium.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).cardColor)):
        Text('your_bid_is_accepted'.tr, style: textMedium.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).cardColor)),
        const SizedBox(height: Dimensions.paddingSizeDefault),


      ])),
    );
  }
}
