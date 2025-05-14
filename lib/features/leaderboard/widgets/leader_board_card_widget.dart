import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/leaderboard/domain/models/leaderboard_model.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';

class LeaderBoardCardWidget extends StatelessWidget {
  final int index;
  final Leader leaderBoard;
  const LeaderBoardCardWidget({super.key, required this.index, required this.leaderBoard});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(children: [
          Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [


              Expanded(child: Row(children: [
                Text('${index+1}.',style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                ClipRRect(borderRadius: BorderRadius.circular(100),
                    child: ImageWidget(width: 30,height: 30, fit: BoxFit.cover,
                        image: '${Get.find<SplashController>().config!.imageBaseUrl!.profileImage!}/${leaderBoard.driver?.profileImage??''}')),


                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Flexible(child: Text(' ${leaderBoard.driver?.firstName??''} ${leaderBoard.driver?.lastName??''}',
                      style: textRegular.copyWith()))])),


              Row(children: [
                Text('${PriceConverter.convertPrice(context, double.parse(leaderBoard.income!))} /',
                    style: textRobotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)),
                Text(' ${leaderBoard.totalRecords} ${'trips'.tr}',
                  style: textRegular.copyWith(color: Theme.of(context).colorScheme.onPrimary))])])),
          Divider(color: Theme.of(context).primaryColor,thickness: .25,)
        ],
      ),
    );
  }
}
