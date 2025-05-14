

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';

class CustomMenuDrivingStatusWidget extends StatelessWidget {
  final int index;
  final String icon;
  final int selectedIndex;
  const CustomMenuDrivingStatusWidget({super.key, required this.index, required this.icon, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(12,0,12,30),
      child: GestureDetector(onTap: ()=> Get.find<RideController>().setOrderStatusTypeIndex(index),
        child: Container(height: 41,width: 41,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
              color: index == selectedIndex ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(.08)),
          child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: SizedBox(width: Dimensions.iconSizeExtraLarge,height: Dimensions.iconSizeLarge,
              child: Center(child: Image.asset(icon ,color: index == selectedIndex
                  ? Colors.white : Theme.of(context).primaryColor)),
            ),
          ),
        ),
      ),
    );
  }
}