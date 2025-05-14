import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class TextFieldTitleWidget extends StatelessWidget {
  final String title;
  const TextFieldTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(padding:const EdgeInsets.fromLTRB(10,17,0,8),
      child: Text(title, style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault,
        color: Theme.of(context).textTheme.bodyMedium!.color!)));
  }
}
