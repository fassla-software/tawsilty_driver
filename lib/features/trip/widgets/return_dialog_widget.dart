import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ReturnDialogWidget extends StatefulWidget {
  const ReturnDialogWidget({super.key});

  @override
  State<ReturnDialogWidget> createState() => _ReturnDialogWidgetState();
}

class _ReturnDialogWidgetState extends State<ReturnDialogWidget> {
  Timer? _timer;
  int _seconds = 0;
  String otp = '';
  int stateCount = 0;

  @override
  void initState() {
    super.initState();
  }

  void _startTimer() {
    _seconds = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds - 1;
      if(_seconds == 0) {
        timer.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(builder: (tripController){
      return Dialog(
          surfaceTintColor: Theme.of(context).cardColor,
          insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
          child: Container(
            padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: stateCount == 0 ?
            Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(onTap: ()=> Get.back(), child: Container(
                    decoration: BoxDecoration(color: Theme.of(context).hintColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: Image.asset(
                      Images.crossIcon,
                      height: Dimensions.paddingSizeSmall,
                      width: Dimensions.paddingSizeSmall,
                      color: Theme.of(context).cardColor,
                    ),
                  )),
                ),

                Text('enter_cancellation_otp'.tr,style: textBold),

                Text('collect_the_otp'.tr),

                Padding(padding:  EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge,horizontal: Get.width * 0.18),
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
                    onChanged: (value){
                      otp = value;
                    },
                    beforeTextPaste: (text) {
                      return true;
                    },
                  ),
                ),

                tripController.isLoading ?
                Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
                ButtonWidget(
                  width: Get.width * 0.5,
                  buttonText: 'submit'.tr,
                  onPressed: (){
                     if(otp.trim().isEmpty){
                       showCustomSnackBar('otp_required'.tr);
                     }else{
                       tripController.parcelReturnSubmitOtp(Get.find<RideController>().tripDetail?.id ?? '', otp).then((value){
                         if(value.statusCode == 200){
                           setState(() {
                             stateCount = 1;
                           });
                         }
                       });
                     }
                  },

                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text('didnot_receive_code'.tr,style: textBold),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                InkWell(
                    onTap: (){
                      if(_seconds == 0){
                        _startTimer();
                        tripController.resendReturnedOtp(Get.find<RideController>().tripDetail?.id ?? '');
                      }
                    },
                    child: RichText (
                      text: TextSpan(text: '${'resend_it'.tr} ', style: textBold.copyWith(color: Theme.of(context).colorScheme.surfaceContainer),
                        children: <TextSpan>[
                          TextSpan(text: _seconds > 0 ?'${'after'.tr} (${_seconds}s)' : '', style: textBold.copyWith()),
                        ],
                      ),
                    )
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                RichText (
                  text: TextSpan(text: '${'or_contact_with'.tr} ', style: textMedium.copyWith(color: Theme.of(context).colorScheme.secondaryFixedDim),
                    children: <TextSpan>[
                      TextSpan(text: Get.find<SplashController>().config?.businessName ?? '', style: textBold.copyWith(decoration: TextDecoration.underline)),
                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

              ],
            ) :
            Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(onTap: ()=> Get.back(), child: Container(
                      decoration: BoxDecoration(color: Theme.of(context).hintColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: Image.asset(
                        Images.crossIcon,
                        height: Dimensions.paddingSizeSmall,
                        width: Dimensions.paddingSizeSmall,
                        color: Theme.of(context).cardColor,
                      ),
                    )),
                  ),
                  const SizedBox(height: 30),

                  Image.asset(Images.parcelReturnSuccessIcon,height: 60,width: 60),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text('parcel_returned_successfully'.tr,style: textSemiBold),
                  const SizedBox(height: 50)
                ]
            ),
          )
      );
    });
  }
}
