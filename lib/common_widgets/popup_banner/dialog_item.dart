import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ride_sharing_user_app/common_widgets/popup_banner/slider_item.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

class DialogItem extends StatelessWidget {
  final BuildContext context;

  final List<String> images;

  final bool fromNetwork;

  final double? height;

  final BoxFit fit;

  final Function(int) onClick;

  final AlignmentGeometry dotsAlignment;

  final Color dotsColorActive;

  final Color dotsColorInactive;

  final double dotsMarginBottom;

  final bool useDots;

  final bool autoSlide;

  final Widget? customCloseButton;

  final Duration slideChangeDuration;

  final int initIndex;

  final bool showDownloadButton;

  const DialogItem(
      {super.key,
      required this.context,
      required this.images,
      this.fromNetwork = true,
      this.height,
      this.fit = BoxFit.fill,
      required this.onClick,
      this.dotsAlignment = Alignment.bottomLeft,
      this.dotsColorActive = Colors.green,
      this.dotsColorInactive = Colors.grey,
      this.dotsMarginBottom = 10,
      this.useDots = true,
      this.slideChangeDuration = const Duration(seconds: 6),
      this.autoSlide = false,
      this.customCloseButton,
      required this.initIndex,
      required this.showDownloadButton
      });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  Widget _dialogContent(BuildContext context) {
    return Container(height: Get.height,width: Get.width,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 0.0, offset: Offset(0.0, 0.0))]),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: customCloseButton ??
                const Padding(
                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
          ),

          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SliderItem(
                height: height ?? (MediaQuery.of(context).size.height * 0.9),
                fromNetwork: fromNetwork,
                fit: fit,
                imageList: images,
                dotsAlignment: dotsAlignment,
                onClick: (index) => onClick(index),
                useDots: useDots,
                dotsColorActive: dotsColorActive,
                dotsColorInactive: dotsColorInactive,
                dotsMarginBottom: dotsMarginBottom,
                autoSlide: autoSlide,
                initIndex: initIndex,
                showDownloadButton: showDownloadButton,
              )),

        ]));
  }
}
