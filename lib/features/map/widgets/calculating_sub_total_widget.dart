import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class CalculatingSubTotalWidget extends StatefulWidget {
  const CalculatingSubTotalWidget({super.key});

  @override
  State<CalculatingSubTotalWidget> createState() => _CalculatingSubTotalWidgetState();
}

class _CalculatingSubTotalWidgetState extends State<CalculatingSubTotalWidget> {
  double percent = 0.0;
  @override
  void initState() {
    Timer? timer;
    timer = Timer.periodic(const Duration(milliseconds:1000),(_){
      setState(() {
        percent += 20;
        if(percent >= 100){
          timer!.cancel();
        }
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeExtraSmall),
        child: Text('one_moment'.tr, style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge))),
      Text('calculating_sub_total'.tr, style: textRegular.copyWith(color: Theme.of(context).hintColor)),

      Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
        child: LinearPercentIndicator( //leaner progress bar
          animation: true,
          animationDuration: 1000,
          lineHeight: 4.0,
          percent:percent/100,
          progressColor: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).hintColor))],);
  }
}
