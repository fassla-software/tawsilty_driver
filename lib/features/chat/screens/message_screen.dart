import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_pop_scope_widget.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/chat/controllers/chat_controller.dart';
import 'package:ride_sharing_user_app/features/chat/widgets/message_bubble_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_view_widget.dart';

class MessageScreen extends StatefulWidget {
  final String channelId;
  final String tripId;
  final String userName;
  const MessageScreen({super.key, required this.channelId, required this.tripId, required this.userName});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Get.find<ChatController>().findChannelRideStatus(widget.channelId);
    Get.find<ChatController>().getConversation(widget.channelId, 1);
    Get.find<ChatController>().subscribeMessageChannel(widget.tripId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CustomPopScopeWidget(
      child: Scaffold(
        body:  GetBuilder<ChatController>(builder: (messageController){
          return Column(children: [
            AppBarWidget(title: '${'chat_with'.tr} ${widget.userName}', regularAppbar: true),
      
            (messageController.messageModel != null && messageController.messageModel!.data != null) ?
            messageController.messageModel!.data!.isNotEmpty ?
            Expanded(child: SingleChildScrollView(
              controller: scrollController,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                child: PaginatedListViewWidget(
                  reverse: true,
                  scrollController: scrollController,
                  totalSize: messageController.messageModel!.totalSize,
                  offset: (messageController.messageModel != null && messageController.messageModel!.offset != null) ?
                  int.parse(messageController.messageModel!.offset.toString()) : null,
                  onPaginate: (int? offset) async  => await messageController.getConversation(widget.channelId, offset!),
      
                  itemView: ListView.builder(
                    reverse: true,
                    itemCount: messageController.messageModel!.data!.length,
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      if(index !=0){
                        return ConversationBubbleWidget(
                          message: messageController.messageModel!.data![index],
                          previousMessage: messageController.messageModel!.data![index-1],
                          index: index,length: messageController.messageModel!.data!.length,
                        );
                      }else{
                        return ConversationBubbleWidget(
                          message: messageController.messageModel!.data![index],
                          index: index, length: messageController.messageModel!.data!.length,
                        );
                      }
      
                    },
                  ),
                ),
              ),
            )) :
            const Expanded(child: NoDataWidget(title: 'no_message_found',)) :
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, children: [
                SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0),
            ],
            )),
      
            messageController.pickedImageFile != null && messageController.pickedImageFile!.isNotEmpty ?
            Container(
              height: 90, width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    return  Stack(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: 80, width: 80,
                            child: Image.file(
                              File(messageController.pickedImageFile![index].path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
      
                      Positioned(right: 5,
                        child: InkWell(
                          child: const Icon(Icons.cancel_outlined, color: Colors.red),
                          onTap: () => messageController.pickMultipleImage(true,index: index),
                        ),
                      ),
                    ]);
                  },
                  itemCount: messageController.pickedImageFile!.length,
              ),
            ) :
            const SizedBox(),
      
            messageController.otherFile != null ?
            Stack(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25), height: 25,
                child: Text(messageController.otherFile!.names.toString()),
              ),
      
              Positioned(top: 0, right: 0,
                child: InkWell(
                  child: const Icon(Icons.cancel_outlined, color: Colors.red),
                  onTap: () => messageController.pickOtherFile(true),
                ),
              ),
            ]) :
            const SizedBox(),
      
            Padding(
              padding: const EdgeInsets.only(
                left: Dimensions.paddingSizeDefault,
                right: Dimensions.paddingSizeDefault,
                bottom: Dimensions.paddingSizeDefault,
              ),
              child: Divider(color: Theme.of(context).hintColor.withOpacity(0.15)),
            ),
      
            /// Message Send field here.
      
            messageController.channelRideStatus ?
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(child: Container(
                margin: const EdgeInsets.only(
                  left: Dimensions.paddingSizeSmall,
                  right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeExtraLarge,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
                child: Form(
                  key: messageController.conversationKey,
                  child: Row(children: [
                    const SizedBox(width: Dimensions.paddingSizeDefault),
      
                    Expanded(child: TextField(
                      minLines: 1,
                      controller: messageController.conversationController,
                      textCapitalization: TextCapitalization.sentences,
                      style: textMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color:Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "type_here".tr,
                        hintStyle: textRegular.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                      onChanged: (String newText) {},
                    )),
      
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: InkWell(
                        onTap: () => messageController.pickMultipleImage(false),
                        child: Image.asset(
                          height: 20,width: 20,
                          Images.pickImage,
                          color: Get.isDarkMode ?
                          Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ]),
                ),
              )),
      
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
                margin: EdgeInsets.only(
                    bottom: Dimensions.paddingSizeExtraLarge,
                    right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
                    left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: messageController.isLoading ?
                SizedBox(
                  height: 20, width: 20,
                  child: Center(child: SpinKitCircle(
                    color: Theme.of(context).cardColor, size: 20,
                  )),
                ) :
                messageController.isSending ?
                SpinKitCircle(color: Theme.of(context).cardColor, size: 20) :
                messageController.isPickedImage ?
                SpinKitCircle(color: Theme.of(context).primaryColor, size: 20) :
                InkWell(
                  onTap: (){
                    if(messageController.conversationController.text.trim().isEmpty
                        && messageController.pickedImageFile!.isEmpty
                        && messageController.otherFile==null){
                      showCustomSnackBar('write_something'.tr, isError: true);
                    }
                    else if(messageController.conversationKey.currentState!.validate()){
                      messageController.sendMessage(widget.channelId, widget.tripId);
                    }
                    messageController.conversationController.clear();
      
                  },
                  child: Image.asset(
                    Images.sendMessage,
                    width: Dimensions.iconSizeMedium,
                    height: Dimensions.iconSizeMedium,
                    color: Theme.of(context).cardColor,
                  ),
                ),
              )
              ]) :
            SizedBox(height: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.block),
                  const SizedBox(width: 5),
      
                  Text("you_could't_replay_you_have_no_trip".tr),
                ]),
              ),
            ),
          ]);
        }),
      ),
    );
  }
}
