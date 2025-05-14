import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';



class NoDataWidget extends StatelessWidget {
  final String? title;
  final bool fromHome;
  const NoDataWidget({super.key, this.title, this.fromHome = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(fromHome?  Images.initTrip :
              title == 'no_transaction_found' ? Images.noTransation
                  : title == "no_point_gain_yet" ? Images.noPoint
                  : title == "no_trip_found" ? Images.noTrip
                  : title == "no_notification_found" ? Images.noNotificaiton
                  : title == "no_message_found" ? Images.noMessage
                  : title == "no_review_found" ? Images.noReview
                  : title == "no_review_saved_yet" ? Images.noReview
                  : title == "no_channel_found" ? Images.noMessage
                  : title == "start_conversation" ? Images.conversationIcon
                  : title == "no_address_found" ? Images.noLocation
                  : Images.noDataFound, width: title == "no_notification_found" ? 70 :  100, height: title == "no_notification_found" ? 70 : 100, ),
          Text(title != null? title!.tr : 'no_data_found'.tr,
            style: textRegular.copyWith(color: Theme.of(context).hintColor, fontSize: MediaQuery.of(context).size.height*0.023),
            textAlign: TextAlign.center,
          ),

        ]),
      ),
    );
  }
}
