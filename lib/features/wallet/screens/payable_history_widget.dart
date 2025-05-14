import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/payable_transaction_list_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/payable_type_button_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

class PayableHistoryScreen extends StatefulWidget {
  const PayableHistoryScreen({super.key});

  @override
  State<PayableHistoryScreen> createState() => _PayableHistoryScreenState();
}

class _PayableHistoryScreenState extends State<PayableHistoryScreen> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    Get.find<WalletController>().setPayableTypeIndex(0,notify: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (res, val) async {
        Get.find<WalletController>().setPayableTypeIndex(1,notify: false);
        return;
      },
      child: Scaffold(
        body: GetBuilder<WalletController>(builder: (walletController){
         return Stack(children: [
             Column(children: [
               AppBarWidget(title: 'my_wallet'.tr),
               const SizedBox(height: Dimensions.topBelowSpace),

               Expanded(
                 child: SingleChildScrollView( controller: scrollController,
                   child: PayableTransactionListWidget(
                     walletController: walletController,
                     scrollController: scrollController,
                   ),
                 ),
               )
             ]),

           Positioned(top: Dimensions.topSpace,left: Dimensions.paddingSizeSmall,
             child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
               SizedBox(height: Dimensions.headerCardHeight,
                 child: ListView.builder(
                   shrinkWrap: true,
                   padding: EdgeInsets.zero,
                   scrollDirection: Axis.horizontal,
                   itemCount: walletController.payableTypeList.length,
                   itemBuilder: (context, index){
                     return SizedBox(width : Get.width/2.1,
                       child: PayableTypeButtonWidget(
                         payableType : walletController.payableTypeList[index], index: index,
                       ),
                     );
                   },
                 ),
               ),
             ]),
           )
           ]);
        }),
      ),
    );
  }
}
