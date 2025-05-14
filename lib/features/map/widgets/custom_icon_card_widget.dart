import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class CustomIconCardWidget extends StatefulWidget {
  final String icon;
  final String title;
  final int index;
  final Color? iconColor;
  final Function()? onTap;
  const CustomIconCardWidget({
    super.key, required this.icon, required this.index, this.onTap, required this.title,
    this.iconColor
  });

  @override
  State<CustomIconCardWidget> createState() => _CustomIconCardWidgetState();
}

class _CustomIconCardWidgetState extends State<CustomIconCardWidget> with SingleTickerProviderStateMixin{

  double? scale;
  AnimationController? controller;
  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500,),
      lowerBound: 0.0, upperBound: 0.1,)..addListener(() {setState(() {});});
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    scale = 1 - controller!.value;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      child: Transform.scale(scale: scale,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: .25, color: Theme.of(context).cardColor),
                borderRadius: BorderRadius.circular(100),
                color: Theme.of(context).cardColor
              ),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSize),
                child: SizedBox(
                  width: Dimensions.iconSizeLarge,
                  child: Image.asset(widget.icon, color: widget.iconColor),
                ),
              ),
            ),
          ),

          Text(widget.title, style: textRegular.copyWith()),
        ]),
      ),
    );
  }
  void _tapDown(TapDownDetails details) {
    controller?.forward();
  }
  void _tapUp(TapUpDetails details) {
    controller?.reverse();
  }
}