import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/popup_banner/popup_banner.dart';
import 'package:ride_sharing_user_app/features/chat/domain/models/message_model.dart';
import 'package:ride_sharing_user_app/features/help_and_support/controllers/help_and_support_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/support_chat_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class AdminConversationBubbleWidget extends StatefulWidget {
  final Message message;
  final Message? previousMessage;
  final Message? nextMessage;
  final int index;
  final int length;
  const AdminConversationBubbleWidget({super.key,  required this.message,  this.previousMessage, required this.index, required this.length, this.nextMessage});

  @override
  State<AdminConversationBubbleWidget> createState() => _AdminConversationBubbleWidgetState();
}

class _AdminConversationBubbleWidgetState extends State<AdminConversationBubbleWidget> {
  List<String> images = [];
  final ReceivePort _port = ReceivePort();


  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState((){ });
    });
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }


  @override
  Widget build(BuildContext context) {
    bool isSameUserWithPreviousMessage = Get.find<HelpAndSupportController>().isSameUserWithPreviousMessage(widget.previousMessage, widget.message);
    bool isSameUserWithNextMessage = Get.find<HelpAndSupportController>().isSameUserWithNextMessage(widget.message, widget.nextMessage);
    images = [];
    for (var element in widget.message.conversationFiles!) {
      images.add('${Get.find<SplashController>().config!.imageBaseUrl!.conversation}/${element.fileName ?? ''}');
    }

    return Column(
      crossAxisAlignment: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
      CrossAxisAlignment.end :
      CrossAxisAlignment.start, children: [
      Padding(
        padding: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
        const EdgeInsets.fromLTRB(20, 0, 5, 0) :
        const EdgeInsets.fromLTRB(5, 0, 20, 0),
        child: Column(
          crossAxisAlignment: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
          CrossAxisAlignment.start :
          CrossAxisAlignment.end, children: [

          if((widget.length-1 == widget.index))...[
            Center(child: Text(
              SupportChatHelper.chatTimeCalculation(widget.message.createdAt!),
              style: textRegular.copyWith(color: Theme.of(context).hintColor),
            )),

            const SizedBox(height: Dimensions.paddingSizeDefault)
          ],

          Row(
            crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
            MainAxisAlignment.end :
            MainAxisAlignment.start,
            children: [
              (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
              const SizedBox() :
              Column(children: [
                ClipRRect(borderRadius: BorderRadius.circular(50),
                  child: (isSameUserWithNextMessage && isSameUserWithPreviousMessage) || isSameUserWithPreviousMessage ?
                  const SizedBox(width: 30) :
                  ImageWidget(
                  height: 30, width: 30,
                  image: '${Get.find<SplashController>().config!.imageBaseUrl!.profileImageAdmin}/${widget.message.user!.profileImage}',
                    placeholder: Images.personPlaceholder,
                ),
                ),
              ]),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Flexible(child: Column(
                crossAxisAlignment: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
                CrossAxisAlignment.end :
                CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, children: [
                if(widget.message.message != null)
                  Flexible(child: Padding(
                    padding: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
                    Get.find<LocalizationController>().isLtr ?
                    EdgeInsets.only(left:Get.width *0.15 ) :
                    EdgeInsets.only(right:Get.width *0.15 ) :
                    Get.find<LocalizationController>().isLtr ?
                    EdgeInsets.only(right:Get.width *0.1) :
                    EdgeInsets.only(left:Get.width *0.1) ,
                    child: Container(
                      decoration: BoxDecoration(
                        color: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
                        Theme.of(context).primaryColor.withOpacity(0.9) :
                        Theme.of(context).primaryColor.withOpacity(0.08),
                        borderRadius: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
                        calculateRadiusForDriver(isSameUserWithNextMessage, isSameUserWithPreviousMessage) :
                        calculateRadiusForAdmin(isSameUserWithNextMessage, isSameUserWithPreviousMessage),
                      ),
                      child:  Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Text(widget.message.message??'', style: textRegular.copyWith(
                            color: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
                            Get.isDarkMode ? null :
                            Theme.of(context).cardColor :
                            null
                        )),
                      ),
                    ),
                  )),

                if( widget.message.message != null)
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                widget.message.conversationFiles!.isNotEmpty ?
                SizedBox(
                  width: widget.message.conversationFiles!.length < 4 ?
                  context.width :
                  context.width *0.53,
                  child: Directionality(
                    textDirection:Get.find<LocalizationController>().isLtr ?
                    (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
                    TextDirection.rtl :
                    TextDirection.ltr :
                    (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
                    TextDirection.ltr :
                    TextDirection.rtl,
                    child: GridView.builder(padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1,
                        crossAxisCount: widget.message.conversationFiles!.length < 4 ? 3 : 2,
                        mainAxisSpacing: Dimensions.paddingSizeSmall,
                        crossAxisSpacing: Dimensions.paddingSizeSmall,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.message.conversationFiles!.length < 4 ? widget.message.conversationFiles!.length : 4,
                      itemBuilder: (BuildContext context, index){
                        return widget.message.conversationFiles![index].fileType == 'png' || widget.message.conversationFiles![index].fileType == 'jpg' || widget.message.conversationFiles![index].fileType == 'jpeg'?
                        Padding(
                          padding: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
                          const EdgeInsets.only(right: 5,top: 0,bottom: 5) :
                          const EdgeInsets.only(left: 5,top: 0,bottom: 5),
                          child: InkWell(
                            onTap: ()=> PopupBanner(
                                context: context, images: images,
                                initIndex: index,dotsAlignment: Alignment.bottomCenter,
                                onClick: (index){
                                  Get.find<HelpAndSupportController>().downloadFile(
                                      url: '${Get.find<SplashController>().config!.imageBaseUrl!.conversation!}/${widget.message.conversationFiles![index].fileName ?? ''}',
                                      fileName: widget.message.conversationFiles![index].fileName ?? ''
                                  );
                                },autoSlide: false,fit: BoxFit.contain,
                              showDownloadButton: true
                            ).show(),
                            child: Stack(children: [
                              ClipRRect(borderRadius: BorderRadius.circular(5),
                                child:ImageWidget(
                                  height: 100, width: 100, fit: BoxFit.cover,
                                  image: '${Get.find<SplashController>().config!.imageBaseUrl!.conversation!}/${widget.message.conversationFiles![index].fileName ?? ''}',
                                ),
                              ),

                              (widget.message.conversationFiles!.length > 4 && index == 3) ?
                              Container(
                                height: 100,width: 100,
                                color: Colors.transparent.withOpacity(0.5),
                                child: Center(child: Text(
                                  '+${widget.message.conversationFiles!.length - 4}',
                                  style: textRegular.copyWith(color: Theme.of(context).cardColor, fontSize: 16),
                                )),
                              ):
                              const SizedBox()
                            ]),
                          ),
                        ) :

                        InkWell(
                          onTap : () async {
                            Get.find<HelpAndSupportController>().downloadFile(
                                url: '${Get.find<SplashController>().config!.imageBaseUrl!.conversation!}/${widget.message.conversationFiles![index].fileName ?? ''}',
                                fileName: widget.message.conversationFiles![index].fileName ?? ''
                            );
                          },
                          child: Container(
                            margin:  (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
                            const EdgeInsets.only(right: 5,top: 0,bottom: 10) :
                            const EdgeInsets.only(left: 5,top: 0,bottom: 0),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSeven),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).hoverColor),
                            child: Column(children: [
                                Row(children: [
                                  Expanded(child: Image.asset(Images.filePreview, height: 24,width: 24)),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  Column(children: [
                                    Text(
                                      '${widget.message.conversationFiles![index].fileName}'.substring(widget.message.conversationFiles![index].fileName!.length-7),
                                      maxLines: 5, overflow: TextOverflow.clip,style: textRegular.copyWith(fontSize: 12),
                                    ),

                                    Text('${widget.message.conversationFiles![index].fileSize}',maxLines: 5, overflow: TextOverflow.clip,style: textRegular.copyWith(fontSize: 10))
                                  ]),

                                ]),
                              const SizedBox(height: Dimensions.paddingSizeDefault),

                              Container(
                                height: 30,width: 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeSeven))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(Images.downloadIcon),
                                ),
                              )
                              ]),
                          ),
                        );
                      },
                    ),
                  ),
                ) :
                const SizedBox.shrink(),
              ],
              )),
              const SizedBox(width: Dimensions.paddingSizeSmall),

            ],
          ),

        ],
        ),
      ),


      if(!SupportChatHelper.isMessageSameDate(widget.message.createdAt!, widget.previousMessage?.createdAt))
        Center(child: Text(
          SupportChatHelper.chatTimeCalculation(widget.message.createdAt!),
          style: textRegular.copyWith(color: Theme.of(context).hintColor),
        )),
    ],
    );
  }

  BorderRadius calculateRadiusForDriver(bool isSameUserWithNextMessage, bool isSameUserWithPreviousMessage){
    if(Get.find<LocalizationController>().isLtr){
      return isSameUserWithNextMessage && isSameUserWithPreviousMessage ? BorderRadius.only() :
      isSameUserWithNextMessage ?
      BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeDefault), bottomRight: Radius.circular(Dimensions.paddingSizeDefault),topLeft: Radius.circular(Dimensions.paddingSizeDefault)) :
      isSameUserWithPreviousMessage ?
      BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeDefault), topRight: Radius.circular(Dimensions.paddingSizeDefault),topLeft: Radius.circular(Dimensions.paddingSizeDefault)) :
      BorderRadius.circular(Dimensions.paddingSizeDefault);
    }else{
      return isSameUserWithNextMessage && isSameUserWithPreviousMessage ? BorderRadius.only() :
      isSameUserWithNextMessage ?
      BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeDefault), bottomRight: Radius.circular(Dimensions.paddingSizeDefault),topRight: Radius.circular(Dimensions.paddingSizeDefault)) :
      isSameUserWithPreviousMessage ?
      BorderRadius.only(bottomRight: Radius.circular(Dimensions.paddingSizeDefault), topRight: Radius.circular(Dimensions.paddingSizeDefault),topLeft: Radius.circular(Dimensions.paddingSizeDefault)) :
      BorderRadius.circular(Dimensions.paddingSizeDefault);
    }

  }

  BorderRadius calculateRadiusForAdmin(bool isSameUserWithNextMessage, bool isSameUserWithPreviousMessage){
   if(Get.find<LocalizationController>().isLtr){
     return isSameUserWithNextMessage && isSameUserWithPreviousMessage ? BorderRadius.only() :
     isSameUserWithNextMessage ?
     BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeDefault), bottomRight: Radius.circular(Dimensions.paddingSizeDefault),topRight: Radius.circular(Dimensions.paddingSizeDefault)) :
     isSameUserWithPreviousMessage ?
     BorderRadius.only(bottomRight: Radius.circular(Dimensions.paddingSizeDefault), topRight: Radius.circular(Dimensions.paddingSizeDefault),topLeft: Radius.circular(Dimensions.paddingSizeDefault)) :
     BorderRadius.circular(Dimensions.paddingSizeDefault);
   }else{
     return isSameUserWithNextMessage && isSameUserWithPreviousMessage ? BorderRadius.only() :
     isSameUserWithNextMessage ?
     BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeDefault), bottomRight: Radius.circular(Dimensions.paddingSizeDefault),topLeft: Radius.circular(Dimensions.paddingSizeDefault)) :
     isSameUserWithPreviousMessage ?
     BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeDefault), topRight: Radius.circular(Dimensions.paddingSizeDefault),topLeft: Radius.circular(Dimensions.paddingSizeDefault)) :
     BorderRadius.circular(Dimensions.paddingSizeDefault);
   }

  }


}
