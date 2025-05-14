import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/loyalty_point_card_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_view_widget.dart';

class LoyaltyPointTransactionListWidget extends StatefulWidget {

  final WalletController walletController;
  const LoyaltyPointTransactionListWidget({super.key, required this.walletController});

  @override
  State<LoyaltyPointTransactionListWidget> createState() => _LoyaltyPointTransactionListWidgetState();
}

class _LoyaltyPointTransactionListWidgetState extends State<LoyaltyPointTransactionListWidget> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return widget.walletController.loyaltyPointModel != null? widget.walletController.loyaltyPointModel!.data != null && widget.walletController.loyaltyPointModel!.data!.isNotEmpty?
    PaginatedListViewWidget(
      scrollController: scrollController,
      totalSize: widget.walletController.loyaltyPointModel!.totalSize,
      offset: (widget.walletController.loyaltyPointModel != null && widget.walletController.loyaltyPointModel!.offset != null) ? int.parse(widget.walletController.loyaltyPointModel!.offset.toString()) : null,
      onPaginate: (int? offset) async {
        if (kDebugMode) {
          print('==========offset========>$offset');
        }
        await widget.walletController.getLoyaltyPointList(offset!);
      },

      itemView: ListView.builder(
        itemCount: widget.walletController.loyaltyPointModel!.data!.length,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return LoyaltyPointCardWidget(points: widget.walletController.loyaltyPointModel!.data![index]);
        },
      ),
    ):const NoDataWidget(title: 'no_point_gain_yet',):const NotificationShimmerWidget();
  }
}
