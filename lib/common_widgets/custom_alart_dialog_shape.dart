import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

class CustomAlertDialogShape extends StatelessWidget {
  final Widget child;
  const CustomAlertDialogShape({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 10, width: 40, decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
                borderRadius: BorderRadius.circular(25),
              )),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              child,

            ],
          ),
        ),

        Positioned.fill(child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Align(alignment: Alignment.topRight, child: InkWell(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            onTap: ()=> Navigator.pop(context),
            child: Icon(Icons.cancel, color: Theme.of(context).colorScheme.error),
          )),
        ))
      ],
    );
  }
}
