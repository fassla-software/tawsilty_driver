import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ButtonWidget extends StatelessWidget {
  final Function()? onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets margin;
  final double height;
  final double width;
  final double? fontSize;
  final double radius;
  final IconData? icon;
  final bool showBorder;
  final double borderWidth;
  final Color? borderColor;
  final Color? textColor;
  final Color? backgroundColor;
  const ButtonWidget({super.key, this.onPressed, required this.buttonText, this.transparent = false, this.margin = EdgeInsets.zero,
    this.width = Dimensions.webMaxWidth, this.height = 45, this.fontSize, this.radius = 5, this.icon,this.showBorder = false,this.borderWidth=1, this.borderColor, this.textColor, this.backgroundColor, });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor:backgroundColor ?? (onPressed == null ? Theme.of(context).disabledColor : transparent
          ? Colors.transparent : Theme.of(context).primaryColor),
      minimumSize: Size(width, height),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: showBorder?BorderSide(color: borderColor ?? Theme.of(context).primaryColor,width: borderWidth):const BorderSide(color: Colors.transparent)
      ),

    );

    return Center(child: SizedBox(width: width, child: Padding(
      padding: margin,
      child: TextButton(
        onPressed: onPressed,
        style: flatButtonStyle,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          icon != null ? Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
            child: Icon(icon, color: transparent ? Theme.of(context).primaryColor : Colors.white),
          ) : const SizedBox(),
          Text(buttonText, textAlign: TextAlign.center, style: textBold.copyWith(
            color: textColor ?? (transparent ? Theme.of(context).primaryColor : Colors.white),
            fontSize: fontSize ?? Dimensions.fontSizeLarge,
          )),
        ]),
      ),
    )));
  }
}