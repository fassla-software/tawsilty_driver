import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/map/widgets/customer_info_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class BiddingDialogWidget extends StatefulWidget {
  final TripDetail rideRequest;
  const BiddingDialogWidget({super.key, required this.rideRequest});

  @override
  State<BiddingDialogWidget> createState() => _BiddingDialogWidgetState();
}

class _BiddingDialogWidgetState extends State<BiddingDialogWidget> {
  TextEditingController bidingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
      child: GetBuilder<RideController>(builder: (rideController) {
        return Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(mainAxisSize: MainAxisSize.min,children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(),

                Text('start_your_bidding'.tr, style: textBold.copyWith(
                  color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge,
                )),
              ],
            ),

            CustomerInfoWidget(
              fromTripDetails: false,
              customer: widget.rideRequest.customer,
              fare: widget.rideRequest.estimatedFare,
              customerRating: widget.rideRequest.customerAvgRating,
            ),

            Divider(thickness: 1,color: Theme.of(context).hintColor.withOpacity(0.75)),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(.1),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const SizedBox(),

                  SizedBox(height: 50, child: IntrinsicWidth(child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: bidingController,
                    style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'enter_your_bid'.tr,
                      hintStyle: textRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(.5)),
                      enabledBorder: UnderlineInputBorder(borderSide:  BorderSide(
                        width: 0.0, color: Theme.of(context).hintColor.withOpacity(0),
                      )),
                      focusedBorder: UnderlineInputBorder(borderSide:  BorderSide(
                        width: 0.0, color: Theme.of(context).hintColor.withOpacity(0),
                      )),
                    ),
                  ))),

                  InkWell(
                    onTap: (){
                      String biddingAmount = bidingController.text.trim();
                      if(biddingAmount.isEmpty){
                        showCustomSnackBar('bidding_amount_is_required'.tr);
                      }else{
                        rideController.bidding(widget.rideRequest.id!, bidingController.text);
                      }},
                    child: rideController.isLoading ?
                    SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0) :
                    SizedBox(
                      width: Dimensions.iconSizeMedium,
                      child: Image.asset(Images.arrowRight,color: Theme.of(context).primaryColor),
                    ),
                  )
                ]),
              ),
            )

          ]),
        );
      }),
    );
  }
}
