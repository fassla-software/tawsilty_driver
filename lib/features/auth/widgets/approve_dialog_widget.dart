import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class ApproveDialogWidget extends StatelessWidget {
  final String icon;
  final String? title;
  final String description;
  final Function onYesPressed;

  const ApproveDialogWidget({super.key, required this.icon, this.title, required this.description, required this.onYesPressed,
    });

  @override
  Widget build(BuildContext context) {
    return Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(width: 500, child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Image.asset(icon, width: 50, height: 50)),


          title != null ? Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text(title ?? '', textAlign: TextAlign.center,
              style: textMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor)),) : const SizedBox(),


          Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Text(description, style: textMedium.copyWith(color: Theme.of(context).hintColor,
                fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center)),
          const SizedBox(height: Dimensions.paddingSizeDefault),


          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            SizedBox(width: 60,child: ButtonWidget(buttonText:  'ok'.tr,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(.25),
              textColor: Theme.of(context).colorScheme.surfaceTint,
              onPressed: () => onYesPressed(),
              radius: Dimensions.radiusSmall, height: 40))]),

        ]),
      )),
    );
  }
}
