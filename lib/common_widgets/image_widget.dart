import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_sharing_user_app/util/images.dart';

class ImageWidget extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final double radius;
  final String placeholder;
  final String? svg;
  const ImageWidget({
    super.key,  this.image, this.height, this.width, this.fit = BoxFit.cover,
    this.placeholder = Images.placeholder, this.radius = 0,  this.svg,
  });

  @override
  Widget build(BuildContext context) {
    return svg != null ? SvgPicture.asset(
      svg!, height: height, width: width, fit: fit,
    ):  ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: FadeInImage.assetNetwork(
        image: image!, height: height, width: width, fit: fit,
        placeholder: Images.placeholder,
        imageErrorBuilder: (context, url, error) => Image.asset(placeholder, height: height, width: width, fit: fit),
      ),
    );
  }
}
