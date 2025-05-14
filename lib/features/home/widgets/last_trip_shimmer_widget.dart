import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:shimmer/shimmer.dart';

class LastTripShimmerWidget extends StatelessWidget {
  const LastTripShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[50]!,
        child: Container(width: Get.width,height: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.07),
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
            border: Border.all(color: Colors.grey)
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),

          child: Column(
            children: [
              Row(children: [

                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.07),
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),

                      child: Container(width: 50,height: 10,
                        decoration: BoxDecoration(color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.07),
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),

                      child: Container(width: 50,height: 10,
                        decoration: BoxDecoration(color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.07),
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),

                  child: Container(width: 50,height: 10,
                    decoration: BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                    ),),
                ),
              ],),
              const SizedBox(height: Dimensions.paddingSizeSmall,),
              Row(children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.07),
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),

                  child: Container(width: 50,height: 10,
                    decoration: BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                    ),),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.07),
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),

                  child: Container(width: 100,height: 100,
                    decoration: BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(200)
                    ),),
                ),
                const SizedBox(height: 10),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.07),
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),

                  child: Container(width: 50,height: 10,
                    decoration: BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                    ),),
                ),
              ],),

              const SizedBox(height: Dimensions.paddingSizeSmall,),
              Row(children: [
                Container(decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.07),
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),

                  child: Container(width: 50,height: 10,
                    decoration: BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                    ),),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.07),
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),

                  child: Container(width: 50,height: 10,
                    decoration: BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                    ),),
                ),
              ],),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
              Row(children: [
                Container(decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.07),
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),

                  child: Container(width: 50,height: 10,
                    decoration: BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                    ),),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.07),
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),

                  child: Container(width: 50,height: 10,
                    decoration: BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                    ),),
                ),
              ],),

            ],
          ),
        ),
      ),
    );
  }
}
