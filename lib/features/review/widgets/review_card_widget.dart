import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/review/controllers/review_controller.dart';
import 'package:ride_sharing_user_app/features/review/domain/models/review_model.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';


class ReviewCardWidget extends StatelessWidget {
  final Review review;
  final int index;
  const ReviewCardWidget({super.key, required this.review, required this.index});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  const EdgeInsets.symmetric(
        horizontal : Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall,
      ),
      child: GetBuilder<ReviewController>(builder: (reviewController){
        return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(.125),
                blurRadius: 5, spreadRadius: 1,
              )],
            ),
            padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Expanded(child: Text('${'trip'.tr} # ${review.tripRefId}', style: textMedium)),

                Padding(
                  padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                  child: Row(children: [
                    Padding(
                      padding:  const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      child: Image.asset(Images.calenderIcon, scale: 2.5),
                    ),

                    Text(
                      DateConverter.localToIsoString(DateTime.parse(review.createdAt!)),
                      style: textRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                  ]),
                ),
              ]),

              Padding(
                padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Row(children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.5)),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      child: ImageWidget(
                        image: '${Get.find<SplashController>().config!.imageBaseUrl!.profileImageCustomer!}/${review.givenUser!.profileImage??''}',
                        height: 30,width: 30,
                      ),
                    ),
                  ),

                  Padding(
                    padding:  const EdgeInsets.only(
                      left: Dimensions.paddingSizeSmall ,
                      right: Dimensions.paddingSizeSmall,
                    ),
                    child: Text(
                      '${review.givenUser!.firstName!} ${review.givenUser!.lastName!}',
                      style: textMedium,
                    ),
                  ),
                ]),
              ),

              if(review.feedback != null)
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: ReadMoreText(
                    review.feedback ?? '',
                    trimLines: 4,
                    colorClickableText: Theme.of(context).primaryColor,
                    trimMode: TrimMode.Line,
                    textAlign: TextAlign.start,
                    trimCollapsedText: 'show_more'.tr,
                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    trimExpandedText: 'show_less'.tr,
                    lessStyle: textSemiBold.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Get.isDarkMode ?
                      Theme.of(context).hintColor.withOpacity(.5) :
                      Theme.of(context).primaryColor,
                    ),
                    moreStyle: textSemiBold.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color:Get.isDarkMode ?
                      Theme.of(context).hintColor.withOpacity(.5) :
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),

              Padding(
                padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                child: Row(children: [
                  Text('${'rate_your_service'.tr} : '),

                  Icon(
                    Icons.star_rate_rounded,
                    color:Get.isDarkMode ?
                    Theme.of(context).hintColor.withOpacity(.5) : Theme.of(context).primaryColor,
                  ),

                  Text(review.rating.toString(), style: textMedium.copyWith()),

                  const Spacer(),

                  GetBuilder<ReviewController>(builder: (reviewController) {
                    return GestureDetector(
                      onTap: (){
                        reviewController.saveReview(review.id.toString(), index);
                      },
                      child:review.isLoading! ?
                      CircularProgressIndicator(
                        color: Get.isDarkMode ?
                        Theme.of(context).hintColor.withOpacity(.5) :
                        Theme.of(context).primaryColor,
                      ) :
                      Padding(
                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                        child: Icon(
                          review.isSaved! ? Icons.bookmark : Icons.bookmark_border,
                          color: review.isSaved! ?
                          Theme.of(context).primaryColor :
                          Get.isDarkMode ?
                          Theme.of(context).hintColor.withOpacity(.5) :
                          Theme.of(context).hintColor,
                        ),
                      ),
                    );
                  }),

                ]),
              ),

            ]),
          ),
        ]);
      }),
    );
  }
}
