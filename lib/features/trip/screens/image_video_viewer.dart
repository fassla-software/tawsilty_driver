import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:video_player/video_player.dart';

class ImageVideoViewer extends StatefulWidget {
  final bool fromNetwork;
  final int clickedIndex;
  final List<Attachments>? attachments;
  final List<XFile>? proofImages;
  const ImageVideoViewer({super.key,this.attachments,required this.clickedIndex,this.proofImages,this.fromNetwork = false});

  @override
  State<ImageVideoViewer> createState() => _ImageVideoViewerState();
}

class _ImageVideoViewerState extends State<ImageVideoViewer> {
  late VideoPlayerController controller;
  late ChewieController chewController;
  late PageController pageController ;
  int currentIndex = 0;
  @override
  void initState() {
    currentIndex = widget.clickedIndex;
    pageController = PageController(initialPage: widget.clickedIndex);
    _loadVideo();
    super.initState();
  }

  Future _loadVideo() async {
    if(widget.fromNetwork){
      if(widget.attachments![currentIndex].file!.contains('.mp4') && widget.attachments![currentIndex].file != null){
        controller =  VideoPlayerController.networkUrl(Uri.parse(widget.attachments![currentIndex].file!));

      }
    }else{
      if(widget.proofImages![currentIndex].path.contains('.mp4')){
        controller = VideoPlayerController.file(File(widget.proofImages![currentIndex].path));

      }
    }

    chewController = ChewieController(
      videoPlayerController: controller,
      autoPlay: true,
      looping: true,
      allowFullScreen: false,
      placeholder: const Center(child: CircularProgressIndicator()),
    );

    chewController.play();
  }

  @override
  void dispose() {
    chewController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: PageView.builder(
          controller: pageController,
          itemBuilder: (context, index){
            return Column(children: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Row( children: [
                  Expanded(child: Text(
                    _extractFileName(
                      widget.fromNetwork ?
                      widget.attachments![currentIndex].file :
                      widget.proofImages![currentIndex].path,
                    ),
                    style: textRegular.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSeven),

                  InkWell(
                    onTap: ()=> Get.back(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(Images.crossIcon,height: 10,width: 10,color: Colors.white),
                    ),
                  )
                ]),
              ),
              SizedBox(height: Get.height * 0.01),

              widget.fromNetwork ?
              widget.attachments![currentIndex].file!.contains('.mp4') ? Flexible(
                child: Center(child: Chewie(controller: chewController)),
              ) : Expanded(
                  child: Image.network(widget.attachments![currentIndex].file!)
              ) : widget.proofImages![currentIndex].path.contains('.mp4') ? Flexible(
                child: Center(child: Chewie(controller: chewController)),
              ) : Expanded(
                child: Image.file(File(widget.proofImages![currentIndex].path)),
              ),

            ]);
          },
          itemCount: widget.fromNetwork ? widget.attachments?.length : widget.proofImages?.length,
          onPageChanged: (index) async{
            currentIndex = index;
            await _loadVideo();
            setState(() {});
          },
        ),
      ),
    );
  }

  String _extractFileName(String? url) {
    return Uri.parse(url ?? '').pathSegments.last;
  }

}
