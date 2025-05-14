import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/review/controllers/review_controller.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/header_title_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';


class ReviewThisCustomerScreen extends StatefulWidget {
  final String tripId;
  const ReviewThisCustomerScreen({super.key, required this.tripId});

  @override
  State<ReviewThisCustomerScreen> createState() => _ReviewThisCustomerScreenState();
}

class _ReviewThisCustomerScreenState extends State<ReviewThisCustomerScreen> {
  TextEditingController reviewTextController = TextEditingController();
  double ratting = 3;
  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false,
      onPopInvokedWithResult: (res, val) async {
        Get.offAll(()=> const DashboardScreen());
        return;
      },
      child: Scaffold(
        body: GetBuilder<ReviewController>(
          builder: (reviewController) {
            return Column(children: [
              AppBarWidget(title: 'ratting_and_review'.tr, onBackPressed: (){
                Get.offAll(const DashboardScreen());
              },),
              HeaderTitle(title: 'payment_received_successfully'.tr, color: Theme.of(context).primaryColor,),

              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('review'.tr, style: textSemiBold.copyWith(color: Theme.of(context).primaryColor),),

                  Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                    child: Text('rate_this_customer'.tr, style: textRegular.copyWith(),),),

                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      RatingBar.builder(
                        initialRating: ratting,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: Dimensions.iconSizeLarge,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(Icons.star_rounded, color: Colors.amber),
                        onRatingUpdate: (rating) {
                          ratting = rating;
                          debugPrint(rating.toString());
                        },
                      ),
                    ],
                  ),

                    Padding(padding: const EdgeInsets.only(top: 45, bottom: Dimensions.paddingSizeSmall),
                      child: Text('leave_him_a_comment'.tr, style: textRegular.copyWith(),),),

                    TextFormField(
                      controller: reviewTextController,
                      maxLines: 5,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).hintColor.withOpacity(.1),
                        hintText: 'your_feedback'.tr,
                        hintStyle: textRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(.5)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          borderSide:  BorderSide(width: 0.5,
                              color: Theme.of(context).hintColor.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          borderSide:  BorderSide(width: 0.5,
                              color: Theme.of(context).primaryColor.withOpacity(0.5)),
                        ),

                      ),
                    ),
                ],),
              )

            ],);
          }
        ),

        bottomNavigationBar: GetBuilder<ReviewController>(
          builder: (reviewController) {
            return Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: SizedBox(height: 100,
                child: Column(children: [
                  InkWell(
                    onTap: (){
                      Get.offAll(()=> const DashboardScreen());
                    },
                    child: Text('skip_for_now'.tr,
                      style: textRegular.copyWith(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline),),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                  reviewController.isLoading?  Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)):
                  ButtonWidget(buttonText: 'submit'.tr, onPressed: (){
                    reviewController.submitReview(widget.tripId, ratting.floor(), reviewTextController.text);

                    // Get.to(()=> const SuccessfullyReviewedScreen());
                  },)
              ],),),
            );
          }
        ),
      ),
    );
  }
}
