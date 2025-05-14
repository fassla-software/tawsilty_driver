import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class WeatherAssistantWidget extends StatelessWidget {
  const WeatherAssistantWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,70,20,0),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: Column(mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Text('let_me_help_you'.tr, style: textSemiBold.copyWith(color: Theme.of(context).textTheme.displayLarge!.color),),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Container(padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    color: Theme.of(context).primaryColor.withOpacity(.05)
                  ),child: Row(children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'today_is_heavy'.tr, style: textRegular),
                              const TextSpan(text: ' '),
                              TextSpan(text: 'rainy_weather'.tr, style: textMedium.copyWith(color: Theme.of(context).primaryColor)),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'the_temperature'.tr, style: textRegular),
                              const TextSpan(text: ' '),
                              TextSpan(text: 'is 29 C', style: textMedium.copyWith(color: Theme.of(context).primaryColor)),
                            ],
                          ),
                        )
                      ],),
                    ),
                    SizedBox(width: Dimensions.weatherIconSize,
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Image.asset(Images.rain),
                        ))
                  ],),),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Container(padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(.035)
                  ),child: Row(children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'please_pick_a'.tr, style: textRegular),
                              const TextSpan(text: ' '),
                              TextSpan(text: 'umbrella'.tr, style: textMedium.copyWith(color: Theme.of(context).primaryColor)),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'or'.tr, style: textRegular),
                              const TextSpan(text: ' '),
                              TextSpan(text: 'rain_protection'.tr,style: textMedium.copyWith(color: Theme.of(context).primaryColor)),
                              const TextSpan(text: ' '),
                              TextSpan(text: 'with_you'.tr, style: textRegular),
                            ],
                          ),
                        )
                      ],),
                    ),
                    SizedBox(width: Dimensions.weatherIconSize,
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Image.asset(Images.umbrella),
                        ))
                  ],),),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Container(padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    color: Theme.of(context).colorScheme.error.withOpacity(.025)
                  ),child: Row(children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'due_to'.tr, style: textRegular),
                              const TextSpan(text: ' '),
                              TextSpan(text: 'heavy_rain'.tr, style: textMedium.copyWith(color: Theme.of(context).primaryColor)),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'the_rider_demanding'.tr, style: textRegular),
                              const TextSpan(text: ' '),
                              TextSpan(text: 'high_fare'.tr, style: textMedium.copyWith(color: Theme.of(context).primaryColor)),
                            ],
                          ),
                        )
                      ],),
                    ),
                    SizedBox(width: Dimensions.weatherIconSize,
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Image.asset(Images.highRate),
                        ))
                  ],),),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
              ],),
            ),
          ],
        ),
      ),
    );
  }
}


