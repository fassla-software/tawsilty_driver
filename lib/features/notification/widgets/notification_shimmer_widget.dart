import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:shimmer/shimmer.dart';

class NotificationShimmerWidget extends StatelessWidget {
  const NotificationShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, item) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.07),
                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
              ),
              padding:  const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeLarge,
              ),
              margin: const EdgeInsets.symmetric(vertical: 2),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                IntrinsicHeight(child: Row(children: [
                  const ImageWidget(image: '', radius: Dimensions.radiusDefault, height: 35, width: 35),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Column(crossAxisAlignment: CrossAxisAlignment.start, children:  [
                    Container(width: 40, height: 15, color: Colors.white.withOpacity(0.7)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Container(width: 80, height: 10, color: Colors.white.withOpacity(0.7)),
                  ]),
                ])),

                Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                    child: Row(children: [
                      Container(height: 10, color: Colors.white.withOpacity(0.7),width: 40),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Icon(Icons.alarm, size: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor.withOpacity(0.5)),
                    ]),
                  ),

              ]),
            ),
          ),
        ),
      ),
    );
  }
}
