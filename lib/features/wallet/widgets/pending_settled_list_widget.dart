import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_view_widget.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/pending_settled_card_widget.dart';

class PendingSettledListWidget extends StatefulWidget {
  final WalletController walletController;
  final ScrollController scrollController;
  const PendingSettledListWidget({
    super.key,
    required this.walletController,
    required this.scrollController,
  });

  @override
  State<PendingSettledListWidget> createState() => _PendingSettledListWidgetState();
}

class _PendingSettledListWidgetState extends State<PendingSettledListWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.walletController.pendingSettledWithdrawModel != null ?
    widget.walletController.pendingSettledWithdrawModel!.data != null &&
        widget.walletController.pendingSettledWithdrawModel!.data!.isNotEmpty ?
    Padding(padding: const EdgeInsets.only(bottom : 85.0),
      child: PaginatedListViewWidget(
        scrollController: widget.scrollController,
        totalSize: widget.walletController.pendingSettledWithdrawModel!.totalSize,
        offset: (widget.walletController.pendingSettledWithdrawModel != null &&
            widget.walletController.pendingSettledWithdrawModel!.offset != null) ?
        int.parse(widget.walletController.pendingSettledWithdrawModel!.offset.toString()) : null,
        onPaginate: (int? offset) async {
          if (kDebugMode) {
            print('==========offset========>$offset');
          }
          widget.walletController.selectedHistoryIndex == 1 ?
          await widget.walletController.getWithdrawPendingList(offset!) :
          await widget.walletController.getWithdrawSettledList(offset!);
        },

        itemView: ListView.builder(
          itemCount: widget.walletController.pendingSettledWithdrawModel!.data!.length,
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return  PendingSettledCardWidget(
              pendingSettleInfo: widget.walletController.pendingSettledWithdrawModel!.data![index],
            );
          },
        ),
      ),
    ) :
    const NoDataWidget(title: 'no_transaction_found') :
    SizedBox(height: Get.height, child: const NotificationShimmerWidget());
  }
}
