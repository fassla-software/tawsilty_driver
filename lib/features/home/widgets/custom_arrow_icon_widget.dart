import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

class CustomArrowIconWidget extends StatelessWidget {
  final Color color;
  final Color iconColor;
  final IconData icon;
  final Function()? onTap;
  const CustomArrowIconWidget({super.key, required this.color, required this.icon, required this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,
      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall), color: color),
        child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeTiny),
          child: Icon(icon, color: iconColor,size: Dimensions.iconSizeSmall))));
  }
}