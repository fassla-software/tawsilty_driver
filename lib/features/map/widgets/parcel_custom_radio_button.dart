import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

class ParcelCustomRadioButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  const ParcelCustomRadioButton({super.key,required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
        child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          Expanded(child: Text(
            text,
            style: TextStyle(
              color: !isSelected ? Theme.of(context).hintColor : Theme.of(context).textTheme.bodyMedium!.color,
              fontWeight: FontWeight.w400,fontSize: Dimensions.fontSizeDefault,
            ),
          )),

          isSelected ?
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
            ),
            child: const Icon(Icons.check, color: Colors.white,size: 16),
          ) :
          Container(
            height: 16,width: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              border: Border.all(color: Theme.of(context).hintColor),
            ),
            child: const SizedBox(),
          ),
        ]),
      ),
    );
  }
}
