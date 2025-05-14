import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final bool isFiler;
  final Color? color;
  final Function()? onTap;
  const TitleWidget({super.key, required this.title,  this.isFiler = false, this.onTap, this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.tr, style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: color??Theme.of(context).textTheme.bodyMedium!.color)),
          if(isFiler)
          GestureDetector(
            onTap: onTap,
            child: Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(width: .25, color: Theme.of(context).primaryColor)
              ),
              child: Row(children: [
                SizedBox(width: Dimensions.iconSizeSmall,
                    child: Image.asset(Images.filterVerticalIcon)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text('filter_date'.tr)
            ],),),
          )
        ],
      ),
    );
  }
}
