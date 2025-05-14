import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_pop_scope_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_view_widget.dart';
import 'package:ride_sharing_user_app/features/help_and_support/controllers/help_and_support_controller.dart';
import 'package:ride_sharing_user_app/features/help_and_support/widgets/admin_conversation_bubble_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/image_file_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class SupportChatScreen extends StatefulWidget {
  final String channelId;
  const SupportChatScreen({super.key, required this.channelId});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {

  @override
  void initState() {
    if(Get.find<SplashController>().config?.driverQuestionAnswerStatus ?? false){
      Get.find<HelpAndSupportController>().updateShowFaq(true);
    }
    Get.find<HelpAndSupportController>().getConversation(widget.channelId, 1);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return CustomPopScopeWidget(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: ()=> Get.back(), icon: Icon(Icons.arrow_back_ios_outlined,color: Theme.of(context).textTheme.bodyMedium!.color)),
          title: Row(children: [
            Image.asset(Images.logo,height: 34,width: 34),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Text('admin'.tr, style: textBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color))
          ]),
          shadowColor: Colors.grey.withOpacity(0.3),
          elevation: 2,backgroundColor: Theme.of(context).cardColor,
        ),
        body: GetBuilder<HelpAndSupportController>(builder: (helpAndSupportController){
          return Stack(children: [
            Column(children: [
              (helpAndSupportController.messageModel != null && helpAndSupportController.messageModel!.data != null) ?
              helpAndSupportController.messageModel!.data!.isNotEmpty ?
              Expanded(child: SingleChildScrollView(
                controller: scrollController,
                reverse: true,
                child: Padding(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  child: PaginatedListViewWidget(
                    reverse: true,
                    scrollController: scrollController,
                    totalSize: helpAndSupportController.messageModel!.totalSize,
                    offset: (helpAndSupportController.messageModel != null && helpAndSupportController.messageModel!.offset != null) ?
                    int.parse(helpAndSupportController.messageModel!.offset.toString()) : null,
                    onPaginate: (int? offset) async {
                      await helpAndSupportController.getConversation(widget.channelId, offset!);
                    },

                    itemView: ListView.builder(
                      reverse: true,
                      itemCount: helpAndSupportController.messageModel!.data!.length,
                      padding: const EdgeInsets.all(0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return AdminConversationBubbleWidget(
                          message: helpAndSupportController.messageModel!.data![index],
                          index: index, length: helpAndSupportController.messageModel!.data!.length,
                          previousMessage: index == 0 ? null : helpAndSupportController.messageModel!.data![index-1],
                          nextMessage: index == (helpAndSupportController.messageModel!.data!.length - 1) ? null : helpAndSupportController.messageModel!.data![index+1],
                        );
                      },
                    ),
                  ),
                ),
              )) :
              const Expanded(child: NoDataWidget(title: 'start_conversation')) :
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center, children: [
                SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0),
              ],
              )),

              Container(
                color: (helpAndSupportController.pickedImageFile!.isNotEmpty || helpAndSupportController.documents.isNotEmpty) ?
                Theme.of(context).primaryColor.withOpacity(0.05) : null,
                child: Column( children: [
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  helpAndSupportController.pickedImageFile != null && helpAndSupportController.pickedImageFile!.isNotEmpty ?
                  Container(
                    height: 90, width: Get.width,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: helpAndSupportController.pickedImageFile!.length,
                      itemBuilder: (context,index){
                        return  Stack(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                height: 70, width: 70  ,
                                child: Image.file(
                                  File(helpAndSupportController.pickedImageFile![index].path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          Positioned(right: 0, top: 0,
                            child: InkWell(
                              child: const Icon(Icons.cancel, color: Colors.grey),
                              onTap: () => helpAndSupportController.pickMultipleImage(true,index: index),
                            ),
                          ),
                        ]);
                      },
                    ),
                  ) :
                  const SizedBox(),

                  helpAndSupportController.documents.isNotEmpty ?
                  SizedBox(
                    height: Get.height * 0.06, width: Get.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: helpAndSupportController.documents.length,
                      itemBuilder: (context, index){
                        return Container(
                          padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                          margin: EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                          color: Theme.of(context).cardColor,
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Image.asset(Images.filePreview,height: 24,width: 20),
                            const SizedBox(width: Dimensions.paddingSizeSeven),

                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(children: [
                                Text(helpAndSupportController.documents[index].file!.name.toString(),style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                InkWell(
                                  onTap: () => helpAndSupportController.removeFile(index),
                                  child: Image.asset(Images.crossIcon,height: Dimensions.paddingSizeSmall,width: Dimensions.paddingSizeSmall),
                                )
                              ]),

                              Text(
                                ImageFileHelper.calculateFileSize(helpAndSupportController.documents[index].file!.path!),
                                style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),fontSize: Dimensions.fontSizeExtraSmall),
                              )
                            ]),

                          ]),
                        );
                      },
                    ),
                  ) :
                  const SizedBox(),

                  if(helpAndSupportController.documents.isNotEmpty)
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                  /// Message Send field here.


                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Expanded(child: Container(
                      margin: const EdgeInsets.only(
                        left: Dimensions.paddingSizeSmall,
                        right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeExtraLarge,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.25)),
                        color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                      ),
                      child: Form(
                        key: helpAndSupportController.textKey,
                        child: Row(children: [
                          const SizedBox(width: Dimensions.paddingSizeDefault),

                          Expanded(child: TextField(
                            minLines: 1,
                            controller: helpAndSupportController.conversationController,
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
                            onChanged: (String newText) {
                              helpAndSupportController.updateShowFaq(false,isUpdate: true);
                            },
                          )),

                          InkWell(
                            onTap: () => helpAndSupportController.pickOtherFile(),
                            child: Image.asset(
                              height: 20,width: 20,
                              Images.pickFile,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            child: InkWell(
                              onTap: () => helpAndSupportController.pickMultipleImage(false),
                              child: Image.asset(
                                height: 20,width: 20,
                                Images.pickImage,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    )),

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.25)),
                        color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                      ),
                      margin: EdgeInsets.only(
                        bottom: Dimensions.paddingSizeExtraLarge,
                        right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
                        left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
                      ),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: helpAndSupportController.isLoading ?
                      SizedBox(
                        height: 20, width: 20,
                        child: Center(child: SpinKitCircle(
                          color: Theme.of(context).cardColor, size: 20,
                        )),
                      ) :
                      helpAndSupportController.isSending ?
                      SpinKitCircle(color: Theme.of(context).primaryColor, size: 20) :
                      helpAndSupportController.isPickedImage ?
                      SpinKitCircle(color: Theme.of(context).primaryColor, size: 20) :
                      InkWell(
                        onTap: (){
                          if((Get.find<SplashController>().config?.driverQuestionAnswerStatus ?? false) && helpAndSupportController.conversationController.text.trim().isEmpty
                              && helpAndSupportController.documents.isEmpty && helpAndSupportController.selectedImageList.isEmpty){
                            helpAndSupportController.updateShowFaq(!helpAndSupportController.showFaqQuestions,isUpdate: true);
                          }else{
                            if(helpAndSupportController.conversationController.text.trim().isEmpty
                                && helpAndSupportController.pickedImageFile!.isEmpty
                                && helpAndSupportController.otherFile==null){
                              showCustomSnackBar('write_something'.tr, isError: true);
                            }
                            else if(helpAndSupportController.textKey.currentState!.validate()){
                              helpAndSupportController.sendMessage(widget.channelId, helpAndSupportController.conversationController.text);
                            }
                            helpAndSupportController.conversationController.clear();
                          }

                        },
                        child: Image.asset(
                          ((Get.find<SplashController>().config?.driverQuestionAnswerStatus ?? false) && helpAndSupportController.conversationController.text.trim().isEmpty
                              && helpAndSupportController.documents.isEmpty && helpAndSupportController.selectedImageList.isEmpty) ?
                          Images.faqImageIcon : Images.sendMessage ,
                          width: Dimensions.iconSizeMedium,
                          height: Dimensions.iconSizeMedium,

                        ),
                      ),
                    )
                  ])
                ]),
              )
            ]),

            if(helpAndSupportController.showFaqQuestions)
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(bottom: Get.height * 0.1),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                          boxShadow: [BoxShadow(
                              color: Theme.of(context).hintColor.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 1
                          )]
                      ),
                      padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                      margin: Get.find<LocalizationController>().isLtr ?
                      EdgeInsets.only(right: Dimensions.paddingSizeDefault,left: Dimensions.paddingSizeSignUp) :
                      EdgeInsets.only(right: Dimensions.paddingSizeSignUp,left: Dimensions.paddingSizeDefault) ,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                        Text('faqs'.tr,style: textMedium),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Flexible(
                          child: ListView.separated(
                            itemCount: helpAndSupportController.predefineFawModel?.data?.length ?? 0,
                            shrinkWrap: true,
                            itemBuilder: (context, index){
                              return InkWell(
                                onTap: (){
                                  helpAndSupportController.sendMessage(widget.channelId, helpAndSupportController.predefineFawModel?.data?[index].id ?? '',fromFaq: true);
                                  helpAndSupportController.updateShowFaq(false,isUpdate: true);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                                    borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                                  ),
                                  child: Text(helpAndSupportController.predefineFawModel?.data?[index].question ?? ''),
                                ),
                              );
                            },
                            separatorBuilder: (context,index){
                              return const SizedBox(height: Dimensions.paddingSizeSmall);
                            },
                          ),
                        )

                      ]),
                    ),
                  ),
                ),
              ),
          ]);
        }),
      ),
    );
  }
}
