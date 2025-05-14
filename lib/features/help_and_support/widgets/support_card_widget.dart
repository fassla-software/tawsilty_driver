import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class SupportCardWidget extends StatelessWidget {
  final String contextText;
  final String iconPath;
  const SupportCardWidget(
      {super.key, required this.contextText, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: Dimensions.paddingSizeSeven),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          color: Theme.of(context).cardColor,
          boxShadow: Get.isDarkMode
              ? null
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  )
                ]),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Image.asset(
                iconPath,
                color: Theme.of(context).primaryColorDark,
                height: 16,
                width: 16,
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Text(contextText.tr, style: textMedium)
        ]),
        Icon(Icons.arrow_forward_ios_rounded)
      ]),
    );
  }
}
