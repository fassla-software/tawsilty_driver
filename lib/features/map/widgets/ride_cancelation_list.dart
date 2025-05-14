
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_radio_button.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class RideCancellationList extends StatefulWidget {
  final bool isOngoing;
  const RideCancellationList({super.key, required this.isOngoing});

  @override
  State<RideCancellationList> createState() => _RideCancellationListState();
}

class _RideCancellationListState extends State<RideCancellationList> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('why_do_you_want_to_cancel'.tr,style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),),

        const SizedBox(height: Dimensions.paddingSizeDefault,),
      GetBuilder<TripController>(builder: (tripController){
        int length = widget.isOngoing ? tripController.rideCancellationCauseList!.data!.ongoingRide!.length : tripController.rideCancellationCauseList!.data!.acceptedRide!.length;
        return Container(decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.15))),

          child: ListView.separated(shrinkWrap: true,
            itemCount: length,

            physics: const NeverScrollableScrollPhysics(),padding: EdgeInsets.zero,
            itemBuilder: (context,index){
              return CustomRadioButton(text: widget.isOngoing ? tripController.rideCancellationCauseList!.data!.ongoingRide![index] :
              tripController.rideCancellationCauseList!.data!.acceptedRide![index], isSelected: tripController.rideCancellationCurrentIndex == index,
                  onTap: (){
                 tripController.setCancellationCurrentIndex(index);
                setState(() {});},
                length: length,index: index,);
            },
            separatorBuilder: (context,index){
              return Divider(color: Theme.of(context).primaryColor.withOpacity(0.15),height: 0,);
            },
          ),
        );
      }),
      ],
    );
  }
}
