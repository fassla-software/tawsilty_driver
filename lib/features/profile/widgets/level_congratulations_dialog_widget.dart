import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class LevelCongratulationsDialogWidget extends StatelessWidget {
  final String levelName;
  final String rewardType;
  final String reward;
  const LevelCongratulationsDialogWidget({
    super.key,
    required this.levelName,
    required this.rewardType,
    required this.reward
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Theme.of(context).cardColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
      child: Column(mainAxisSize: MainAxisSize.min,
        children: [
          Align(alignment: Alignment.topRight,
            child: InkWell(onTap: ()=> Get.back(), child: Container(
              decoration: BoxDecoration(color: Theme.of(context).hintColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Image.asset(
                Images.crossIcon,
                height: Dimensions.paddingSizeSmall,
                width: Dimensions.paddingSizeSmall,
                color: Theme.of(context).cardColor,
              ),
            )),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 50,left: 50,bottom: 10),
            child: SizedBox(width: Get.width,
              child: Column(mainAxisSize:MainAxisSize.min, children: [
                Text('${'congratulations'.tr} !',style: textBold.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                )),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Image.asset(Images.levelUpAwardIcon, height: 70, width: 70),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                if(rewardType == 'wallet' || rewardType == 'loyalty_points')...[
                  Text('${'you_have_earned'.tr} '
                      '${rewardType == 'wallet' ?
                  PriceConverter.convertPrice(Get.context!, double.parse(reward)) :
                  '${double.parse(reward).toInt()} ${'points'.tr}'}',
                    style: textRobotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                ],

                Text(levelName.isNotEmpty ? '${'level_note'.tr}$levelName' : 'maximum_level_note'.tr,
                  style: textRegular.copyWith(color: Theme.of(context).hintColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                ButtonWidget(buttonText: 'ok'.tr, onPressed: ()=> Get.back(),
                  margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall,horizontal: 90),
                ),


              ]),
            ),
          ),
        ],
      ),
    );
  }
}
