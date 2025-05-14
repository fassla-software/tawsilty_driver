import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class HeaderTitle extends StatelessWidget {
  final String title;
  final double? width;
  final Color? color;
  const HeaderTitle({super.key, required this.title, this.width, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Container(width: width ?? Get.width,
        transform: Matrix4.translationValues(0, -30, 0),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
            border: Border.all(width: .5,
                color: Theme.of(context).primaryColor)

        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraLarge),
            child: Text(title,
              style: textBold.copyWith(color: color ?? Theme.of(context).hintColor, fontSize: Dimensions.fontSizeLarge),),
          ),
        ),
      ),
    );
  }
}
