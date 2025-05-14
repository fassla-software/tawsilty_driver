import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/map/widgets/parcel_card_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';

class OngoingParcelListScreen extends StatefulWidget {
  final String title;
  const OngoingParcelListScreen({super.key, required this.title});

  @override
  State<OngoingParcelListScreen> createState() => _OngoingParcelListScreenState();
}

class _OngoingParcelListScreenState extends State<OngoingParcelListScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => Future.delayed(const Duration(milliseconds: 50)).then((_){
        Get.offAll(()=> const DashboardScreen());
      }),
      child: Scaffold(
          appBar: AppBarWidget(title: widget.title.tr, regularAppbar: true,),
          body: GetBuilder<RideController>(builder: (rideController){
            return (rideController.parcelListModel == null || rideController.parcelListModel!.data!.isEmpty) ?
            const NoDataWidget(title: 'no_trip_found') :
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: rideController.parcelListModel!.data!.length,
                itemBuilder: (context, index){
                  return ParcelRequestCardWidget(rideRequest: rideController.parcelListModel!.data![index], index: index);
                });
          })
      ),
    );
  }
}
