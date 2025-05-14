import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ride_sharing_user_app/features/map/controllers/otp_time_count_Controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'dart:math' as math;



class OtpVerificationWidget extends StatefulWidget {
  final bool fromOtp;
  const OtpVerificationWidget({super.key,this.fromOtp = true});

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget> {
  @override
  void initState() {
    Get.find<OtpTimeCountController>().startCountingState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController) {
      return GetBuilder<OtpTimeCountController>(builder: (otpTimeController){
        return Column(children: [
          widget.fromOtp ?
          Align(alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal : Dimensions.paddingSizeSmall,
                vertical: Dimensions.paddingSizeExtraSmall,
              ),
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Theme.of(context).hintColor.withOpacity(.085),
              ),

              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('${otpTimeController.min.toString().padLeft(2, '0')}:${otpTimeController.sec.toString().padLeft(2, '0')}', style: textBold),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Image.asset(Images.clockIcon,height: 17,width: 17),
              ]),
            ),
          ) :
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSignUp),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              otpTimeController.currentState == 0 ?
              Text('enter_trip_otp'.tr, style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge)) :
              Text('did_customer_arrived'.tr, style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault)),

              otpTimeController.currentState == 0 ?
              Text('collect_the_otp_from_customer'.tr, style: textRegular.copyWith(),textAlign: TextAlign.center) :
              Text('please_hold_on_a_little_more'.tr, style: textBold.copyWith(
                color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault,
              )),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,
                        Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,
                      ),
                      child: PinCodeTextField(
                          length: 4,
                          appContext: context,
                          obscureText: false,
                          showCursor: true,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              fieldHeight: 40,
                              fieldWidth: 40,
                              borderWidth: 1,
                              borderRadius: BorderRadius.circular(10),
                              selectedColor: Theme.of(context).primaryColor,
                              selectedFillColor: Theme.of(context).primaryColor.withOpacity(.25),
                              inactiveFillColor: Theme.of(context).disabledColor.withOpacity(.125),
                              inactiveColor: Theme.of(context).disabledColor.withOpacity(.125),
                              activeColor: Theme.of(context).primaryColor.withOpacity(.123),
                              activeFillColor: Theme.of(context).primaryColor.withOpacity(.125)),
                          animationDuration: const Duration(milliseconds: 300),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          onChanged: rideController.updateVerificationCode,
                          beforeTextPaste: (text) {
                            return true;}),
                    )),


                    InkWell(
                      onTap: () async {
                        if(rideController.verificationCode.length == 4){
                          rideController.matchOtp(rideController.tripDetail!.id!, rideController.verificationCode);
                        }else{
                          showCustomSnackBar("pin_code_is_required".tr);
                        }
                      },
                      child: rideController.isPinVerificationLoading ?
                      const SizedBox(width: 30,height: 30,child: CircularProgressIndicator()):
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          0, Dimensions.paddingSizeDefault,
                          Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,
                        ),
                        child: SizedBox(width: Dimensions.iconSizeLarge,child: Transform(
                          alignment: Alignment.center,
                          transform: Get.find<LocalizationController>().isLtr ?
                          Matrix4.rotationY(0) :
                          Matrix4.rotationY(math.pi),
                          child: Image.asset(Images.arrowRight),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ]);
      });
    });
  }
}
