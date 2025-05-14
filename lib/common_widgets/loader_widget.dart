import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        alignment: Alignment.center,
        child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)));
  }
}
