import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';

class UserDetailsWidget extends StatefulWidget {
  final String name;
  final String contactNumber;
  final String type;

  const UserDetailsWidget({super.key, required this.name, required this.contactNumber, required this.type});

  @override
  State<UserDetailsWidget> createState() => _UserDetailsWidgetState();
}

class _UserDetailsWidgetState extends State<UserDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (parcelController){
      return Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('${widget.type.tr} ${'info'.tr}',style: textSemiBold.copyWith(color: Theme.of(context).primaryColor),),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children:  [

                const SizedBox(width: Dimensions.paddingSizeSmall),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(widget.name,
                  style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).primaryColorDark),
                  overflow: TextOverflow.ellipsis),
                  Text(widget.contactNumber,
                  style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).hintColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          ],
        )
        ],
      ));
    });
  }
}
