import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/transaction_card_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_view_widget.dart';

class PayableTransactionListWidget extends StatefulWidget {
  final WalletController walletController;
  final ScrollController scrollController;
  const PayableTransactionListWidget({
    super.key, required this.walletController, required this.scrollController
  });

  @override
  State<PayableTransactionListWidget> createState() => _PayableTransactionListWidgetState();
}

class _PayableTransactionListWidgetState extends State<PayableTransactionListWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.walletController.transactionModel != null ?
    widget.walletController.transactionModel!.data != null &&
        widget.walletController.transactionModel!.data!.isNotEmpty ?
    Padding(padding: const EdgeInsets.only(bottom : 85.0),
      child: PaginatedListViewWidget(
        scrollController: widget.scrollController,
        totalSize: widget.walletController.transactionModel!.totalSize,
        offset: (widget.walletController.transactionModel != null &&
            widget.walletController.transactionModel!.offset != null) ?
        int.parse(widget.walletController.transactionModel!.offset.toString()) : null,
        onPaginate: (int? offset) async {
          if (kDebugMode) {
            print('==========offset========>$offset');
          }
          widget.walletController.selectedHistoryIndex == 1 ?
          widget.walletController.payableTypeIndex == 1 ?
          await widget.walletController.getCashCollectHistoryList(offset!) :
          await widget.walletController.getPayableHistoryList(offset!) :
          await widget.walletController.getWalletHistoryList(offset!);
        },

        itemView: ListView.builder(
          itemCount: widget.walletController.transactionModel!.data!.length,
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return TransactionCardWidget(transaction: widget.walletController.transactionModel!.data![index]);
          },
        ),
      ),
    ) :
    const NoDataWidget(title: 'no_transaction_found') :
    SizedBox(height: Get.height, child: const NotificationShimmerWidget());
  }
}
