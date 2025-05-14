import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class VehiclePendingWidget extends StatelessWidget {
  final String icon;
  final String? title;
  final String description;
  const VehiclePendingWidget({super.key, required this.icon, this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Image.asset(icon, width: 120, height: 120)),

         Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: Text(description, textAlign: TextAlign.center,
            style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),),),

        Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Text(title!, style: textMedium.copyWith(
              color: Theme.of(context).hintColor,
              fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center)),
        const SizedBox(height: Dimensions.paddingSizeDefault),


      ]),
    );
  }
}
