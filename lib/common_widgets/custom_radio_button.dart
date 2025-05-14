import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

class CustomRadioButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;
  final int length;

  const CustomRadioButton({super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.length,
    required this.index
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius:
          length == 1 ?
          BorderRadius.circular(10) :
          (length >1 && index == 0) ?
          const  BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)) :
          (length >1 && index == length-1) ?
          const BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)) :
          null,
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.25) : Colors.transparent,
        ),

        child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          isSelected ?
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(50)
            ),
            child: const Icon(Icons.check, color: Colors.white,size: 16),
          ) :
          Container(
            height: 16,width: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Theme.of(context).hintColor),
            ),
            child: const SizedBox(),
          ),
          const SizedBox(width: 8),

          Expanded(child: Text(
            text,
            style: TextStyle(
              color: !isSelected ? Get.isDarkMode ?
              Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5) :
              Theme.of(context).hintColor :
              Get.isDarkMode ?
              Theme.of(context).textTheme.bodyMedium!.color :
              Colors.black,
              fontWeight: FontWeight.w400,fontSize: Dimensions.fontSizeDefault,
            ),
          )),
        ]),
      ),
    );
  }
}