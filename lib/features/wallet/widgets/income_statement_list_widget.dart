import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_view_widget.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/income_statement_card_widget.dart';

class IncomeStatementListWidget extends StatefulWidget {
  final WalletController walletController;
  final ScrollController scrollController;
  const IncomeStatementListWidget({
    super.key,required this.walletController,
    required this.scrollController,
  });

  @override
  State<IncomeStatementListWidget> createState() => _IncomeStatementListWidgetState();
}

class _IncomeStatementListWidgetState extends State<IncomeStatementListWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.walletController.incomeStatementData != null ?
    widget.walletController.incomeStatementData != null &&
        widget.walletController.incomeStatementData!.isNotEmpty ?
    Padding(padding: const EdgeInsets.only(bottom : 85.0),
      child: PaginatedListViewWidget(
        scrollController: widget.scrollController,
        totalSize: widget.walletController.incomeStatement!.totalSize,
        offset: (widget.walletController.incomeStatement != null &&
            widget.walletController.incomeStatement!.offset != null) ?
        int.parse(widget.walletController.incomeStatement!.offset.toString()) : null,
        onPaginate: (int? offset) async {
          if (kDebugMode) {
            print('==========offset========>$offset');
          }
          await widget.walletController.getIncomeStatement(offset!);
        },

        itemView: ListView.builder(
          itemCount: widget.walletController.incomeStatementData!.length,
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return IncomeStatementCardWidget(
              tripDetails: widget.walletController.incomeStatementData![index]
            );
          },
        ),
      ),
    ) :
    const NoDataWidget(title: 'no_transaction_found') :
    SizedBox(height: Get.height, child: const NotificationShimmerWidget());
  }
}
