import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';


class CustomPopScopeWidget extends StatelessWidget {
  final Widget child;
  const CustomPopScopeWidget({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: Navigator.canPop(context),
        onPopInvokedWithResult: (res,data){
          if(!res){
            Get.offAll(()=> const DashboardScreen());
          }
        },
        child: child
    );
  }
}
