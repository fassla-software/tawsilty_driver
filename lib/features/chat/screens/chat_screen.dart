import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/chat/controllers/chat_controller.dart';
import 'package:ride_sharing_user_app/features/chat/domain/models/channel_model.dart';
import 'package:ride_sharing_user_app/features/chat/widgets/message_item_widget.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_view_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    Get.find<ChatController>().getChannelList(1);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ChatController>(builder: (chatController) {
        return Column(children: [
          AppBarWidget(title: 'message'.tr,regularAppbar: true),

          const SizedBox(height: Dimensions.paddingSizeSmall),

          chatController.channelModel!= null ?
          (chatController.channelModel!.data != null && chatController.channelModel!.data!.isNotEmpty) ?
          Expanded(child: SingleChildScrollView(
            controller: scrollController,
            child: PaginatedListViewWidget(
              scrollController: scrollController,
              totalSize: chatController.channelModel!.totalSize,
              offset: chatController.channelModel != null && chatController.channelModel!.offset != null?
              int.parse(chatController.channelModel!.offset.toString()) : 1,
              onPaginate: (int? offset) async => await chatController.getChannelList(offset!),

              itemView: ListView.builder(
                itemCount: chatController.channelModel!.data!.length,
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  ChannelUsers? channelUser;
                  for (var element in chatController.channelModel!.data![index].channelUsers!) {
                    if(element.user!.userType == 'customer'){
                      channelUser = element;
                    }
                  }
                  return channelUser != null ?
                  MessageItemWidget(
                      isRead: false, channelUsers: channelUser,
                      unReadCount: chatController.channelModel!.data![index].unReadCount!,
                      lastMessage: chatController.channelModel!.data![index].lastChannelConversations?.message??'',
                      tripId: chatController.channelModel!.data![index].tripId!,
                  ) :
                  const SizedBox();
                },
              ),
            ),
          )) :
          const Expanded(child: NoDataWidget(title: 'no_channel_found')) :
          const Expanded(child: NotificationShimmerWidget()),

        ]);
      }),
    );
  }
}
