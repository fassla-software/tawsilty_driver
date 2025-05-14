import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/review/controllers/review_controller.dart';

class ReviewTypeButtonWidget extends StatelessWidget {
  final int index;
  final String reviewType;
  const ReviewTypeButtonWidget({super.key, required this.index, required this.reviewType});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewController>(builder: (reviewController) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
        child: InkWell(
          onTap: (){
            reviewController.isLoading || index == reviewController.reviewTypeIndex ? null :
            reviewController.setReviewIndex(index);
          },
          child: Container(width: MediaQuery.of(context).size.width/2.5,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              border: Border.all(width: .5,
                color: index == reviewController.reviewTypeIndex ?
                Theme.of(context).colorScheme.onSecondary: Theme.of(context).primaryColor,
              ),
              color: index == reviewController.reviewTypeIndex ?
              Theme.of(context).primaryColor : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            ),
            child: Column(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment : CrossAxisAlignment.center,children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(reviewType.tr,
                    textAlign: TextAlign.center,
                    style: textSemiBold.copyWith(
                      color : index == reviewController.reviewTypeIndex ?
                      Colors.white :
                      Theme.of(context).hintColor.withOpacity(.65), fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}