import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ride_sharing_user_app/common_widgets/popup_banner/popup_banner.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/chat/domain/models/message_model.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';

class ConversationBubbleWidget extends StatefulWidget {
  final Message message;
  final Message? previousMessage;
  final int index;
  final int length;
  const ConversationBubbleWidget({super.key,  required this.message,  this.previousMessage, required this.index, required this.length});
  @override
  State<ConversationBubbleWidget> createState() => _ConversationBubbleWidgetState();
}

class _ConversationBubbleWidgetState extends State<ConversationBubbleWidget> {
  List<String> images = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    images = [];
     for (var element in widget.message.conversationFiles!) {
      images.add('${Get.find<SplashController>().config!.imageBaseUrl!.conversation}/${element.fileName ?? ''}');
     }
    return Column(crossAxisAlignment: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
     CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
      Padding(padding: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
      const EdgeInsets.fromLTRB(20, 5, 5, 5) : const EdgeInsets.fromLTRB(5, 5, 20, 5),
        child: Column(
          crossAxisAlignment: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
          CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            SizedBox(height:Dimensions.fontSizeExtraSmall),

           if((widget.length-1 == widget.index))...[
             Center(child: Text("${DateConverter.stringToLocalDateOnly(widget.message.createdAt??DateTime.now().toString())}, ${'trip'.tr}# ${widget.index==0 ? widget.message.tripId : widget.previousMessage?.tripId}",
               style: textRegular.copyWith(color: Theme.of(context).hintColor),)),

             const SizedBox(height: Dimensions.paddingSizeDefault,)
           ],


            Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
              MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
                const SizedBox() :
                Column(children: [
                  ClipRRect(borderRadius: BorderRadius.circular(50),
                      child: ImageWidget(height: 30, width: 30,
                          image: '${Get.find<SplashController>().config!.imageBaseUrl!.profileImageCustomer}/${widget.message.user!.profileImage}',
                      placeholder: Images.personPlaceholder,)
                  )]),



                const SizedBox(width: Dimensions.paddingSizeSmall,),
                Flexible(child: Column(crossAxisAlignment: (widget.message.user!.id! == Get.find<ProfileController>().driverId)?
                  CrossAxisAlignment.end:CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, children: [
                      if(widget.message.message != null)
                      Flexible(child: Padding(padding: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ? EdgeInsets.only(left:Get.width *0.15 ) :  EdgeInsets.only(right:Get.width *0.1),
                        child: Container(
                            decoration: BoxDecoration(
                              color: (widget.message.user!.id! == Get.find<ProfileController>().driverId)?
                              Theme.of(context).hintColor.withOpacity(0.20) : Theme.of(context).hintColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10)),
                            child:  Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                              child: Text(widget.message.message??'', style: textRegular.copyWith(),))),
                      )),


                      if( widget.message.message != null) const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      widget.message.conversationFiles!.isNotEmpty?
                      SizedBox(width: widget.message.conversationFiles!.length < 4 ? context.width : context.width *0.53,
                        child: Directionality(textDirection:Get.find<LocalizationController>().isLtr ? (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
                          TextDirection.rtl: TextDirection.ltr : (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?TextDirection.ltr : TextDirection.rtl,
                          child: GridView.builder(padding: EdgeInsets.zero,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1,
                              crossAxisCount: widget.message.conversationFiles!.length < 4 ? 3 : 2,
                              mainAxisSpacing: Dimensions.paddingSizeSmall,
                              crossAxisSpacing: Dimensions.paddingSizeSmall),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.message.conversationFiles!.length < 4 ? widget.message.conversationFiles!.length : 4,
                            itemBuilder: (BuildContext context, index){
                              return widget.message.conversationFiles![index].fileType == 'png' || widget.message.conversationFiles![index].fileType == 'jpg'?
                               Padding( padding: const EdgeInsets.only(right: 5,top: 0,bottom: 5),
                                  child: InkWell(onTap: ()=> PopupBanner(
                                      context: context, images: images,
                                      initIndex: index,dotsAlignment: Alignment.bottomCenter,
                                      onClick: (index){},autoSlide: false,fit: BoxFit.contain,
                                    showDownloadButton: false
                                  ).show(),
                                    child: Stack(children: [
                                          ClipRRect(borderRadius: BorderRadius.circular(5),
                                              child:ImageWidget(height: 100, width: 100, fit: BoxFit.cover,
                                                  image: '${Get.find<SplashController>().config!.imageBaseUrl!.conversation!}/${widget.message.conversationFiles![index].fileName ?? ''}')),

                                          (widget.message.conversationFiles!.length > 4 && index == 3) ?
                                          Container(height: 100,width: 100,color: Colors.transparent.withOpacity(0.5,),child: Center(child: Text('+${widget.message.conversationFiles!.length - 4}',style: textRegular.copyWith(color: Theme.of(context).cardColor, fontSize: 16),)),):
                                              const SizedBox()
                                        ]),
                                  )) :


                              InkWell(onTap : () async {
                                  final status = await Permission.storage.request();
                                  if(status.isGranted){
                                    Directory? directory = Directory('/storage/emulated/0/Download');
                                    if (!await directory.exists()) {
                                      directory = Platform.isAndroid
                                          ? await getExternalStorageDirectory() //FOR ANDROID
                                          : await getApplicationSupportDirectory();
                                    }
                                  }
                                },
                                child: Container(height: 50,width: 50,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).hoverColor),
                                  child: Stack(children: [
                                      Center(child: SizedBox(width: 50, child: Image.asset(Images.folder))),
                                      Center(child: Text('${widget.message.conversationFiles![index].fileName}'.substring(widget.message.conversationFiles![index].fileName!.length-7),
                                          maxLines: 5, overflow: TextOverflow.clip)),
                                    ])));

                            },),
                        ),
                      ):

                      const SizedBox.shrink(),
                    ],
                  ),
                ),

                const SizedBox(width: Dimensions.paddingSizeSmall,),
                (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
                ClipRRect(borderRadius: BorderRadius.circular(50),
                    child: ImageWidget(height: 30, width: 30,
                        image: '${Get.find<SplashController>().config!.imageBaseUrl!.profileImage!}/${widget.message.user!.profileImage}',
                      placeholder: Images.personPlaceholder,
                    )
                )
                    : const SizedBox(),
              ],
            ),


          ],
        ),
      ),

      Padding(padding: (widget.message.user!.id! == Get.find<ProfileController>().driverId) ?
      const EdgeInsets.fromLTRB(5, 0, 50, 15) : const EdgeInsets.fromLTRB(50, 0, 5, 15),
          child: Text(DateConverter.isoDateTimeStringToDifferentWithCurrentTime(widget.message.createdAt!),
              textDirection: TextDirection.ltr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,color: Theme.of(context).hintColor))),

      if((widget.message.tripId != widget.previousMessage?.tripId! && widget.previousMessage != null))
          Center(child: Text("${DateConverter.stringToLocalDateOnly(widget.previousMessage?.createdAt??DateTime.now().toString())}, ${'trip'.tr}# ${widget.index==0 ? widget.message.tripId : widget.previousMessage?.tripId}",
            style: textRegular.copyWith(color: Theme.of(context).hintColor),)),
    ],
    );
  }
}


