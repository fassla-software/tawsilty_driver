import 'dart:convert';
import 'dart:io';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/chat/domain/services/chat_service_interface.dart';
import 'package:ride_sharing_user_app/features/chat/screens/message_screen.dart';
import 'package:ride_sharing_user_app/features/chat/domain/models/channel_model.dart';
import 'package:ride_sharing_user_app/features/chat/domain/models/message_model.dart';
import 'package:ride_sharing_user_app/common_widgets/snackbar_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/pusher_helper.dart';

class ChatController extends GetxController implements GetxService{
  final ChatServiceInterface chatServiceInterface;

  ChatController({required this.chatServiceInterface});


  List <XFile>? _pickedImageFiles =[];
  List <XFile>? get pickedImageFile => _pickedImageFiles;
  FilePickerResult? _otherFile;
  FilePickerResult? get otherFile => _otherFile;
  File? _file;
  PlatformFile? objFile;
  File? get file=> _file;
  List<MultipartBody> _selectedImageList = [];
  List<MultipartBody> get selectedImageList => _selectedImageList;
  final List<dynamic> _conversationList=[];
  List<dynamic> get conversationList => _conversationList;
  final bool _paginationLoading = true;
  bool get paginationLoading => _paginationLoading;
  int? _messagePageSize;
  final int _messageOffset = 1;
  int? get messagePageSize => _messagePageSize;
  int? get messageOffset => _messageOffset;
  int? _pageSize;
  final int _offset = 1;
  bool isLoading = false;
  final String _name='';
  String get name => _name;
  final String _image='';
  String get image => _image;
  int? get pageSize => _pageSize;
  int? get offset => _offset;
  var conversationController = TextEditingController();
  final GlobalKey<FormState> conversationKey  = GlobalKey<FormState>();
  bool _isPickedImage = false;
  bool get isPickedImage => _isPickedImage;

  @override
  void onInit(){
    super.onInit();
    conversationController.text = '';
  }


  void pickMultipleImage(bool isRemove,{int? index}) async {
    if(isRemove) {
      if(index != null){
        _pickedImageFiles!.removeAt(index);
        _selectedImageList.removeAt(index);
      }
    }else {
      _isPickedImage = true;
      Future.delayed(const Duration(seconds: 1)).then((value) {
        update();
      });

      _pickedImageFiles = await ImagePicker().pickMultiImage(imageQuality: 40);
      if (_pickedImageFiles != null) {
        for(int i =0; i< _pickedImageFiles!.length; i++){
          _selectedImageList.add(MultipartBody('files[$i]',_pickedImageFiles![i]));
        }
      }
      _isPickedImage = false;
    }
    update();
  }


  void pickOtherFile(bool isRemove) async {
    if(isRemove){
      _otherFile=null;
      _file = null;
    }else{
      _otherFile = (await FilePicker.platform.pickFiles(withReadStream: true))!;
      if (_otherFile != null) {
        objFile = _otherFile!.files.single;
      }
    }
    update();
  }

  void removeFile() async {
    _otherFile=null;
    update();
  }

  cleanOldData(){
    _pickedImageFiles = [];
    _selectedImageList = [];
    _otherFile = null;
    _file = null;
  }

  ChannelModel? channelModel;

  Future<void> getChannelList(int offset) async{
    Response response = await chatServiceInterface.getChannelList(offset);
    if(response.statusCode == 200){
      if(offset == 1 ){
        channelModel = ChannelModel.fromJson(response.body);
      }else{
        channelModel!.totalSize =  ChannelModel.fromJson(response.body).totalSize;
        channelModel!.offset =  ChannelModel.fromJson(response.body).offset;
        channelModel!.data!.addAll(ChannelModel.fromJson(response.body).data!);
      }
      isLoading = false;
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<void> createChannel(String userId, {required tripId}) async{
    isLoading = true;
    Response response = await chatServiceInterface.createChannel(userId,tripId);
    if(response.statusCode == 200){
      isLoading = false;
      Map map = response.body;
      String channelId = map['data']['channel']['id'];
      String tripId = map['data']['channel']['trip_id'];
      Get.to(()=> MessageScreen(channelId : channelId, tripId: tripId,userName:  map['data']['user']['first_name']+' '+ map['data']['user']['last_name'],));
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }



  MessageModel? messageModel;
  Future<Response> getConversation(String channelId, int offset) async{
    isLoading = true;
    Response response = await chatServiceInterface.getConversation(channelId, offset);
    if(response.statusCode == 200){
      if(offset == 1 ){
        messageModel = MessageModel.fromJson(response.body);

      }else{
        messageModel!.totalSize =  MessageModel.fromJson(response.body).totalSize;
        messageModel!.offset =  MessageModel.fromJson(response.body).offset;
        messageModel!.data!.addAll(MessageModel.fromJson(response.body).data!);
      }
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


  bool isSending = false;
  Future<void> sendMessage(String channelId, String tripId) async{
    isSending = true;
    update();
    Response response = await chatServiceInterface.sendMessage(conversationController.value.text, channelId , tripId,_selectedImageList, objFile);
    if(response.statusCode == 200){
      isSending = false;
      getConversation(channelId, 1);
      conversationController.text='';
      _pickedImageFiles = [];
      _selectedImageList = [];
      _otherFile=null;
      objFile =null;
      _file=null;
    }
    else if(response.statusCode == 400){
      isSending = false;
      String message = response.body['errors'][0]['message'];
      if(message.contains("png  jpg  jpeg  csv  txt  xlx  xls  pdf")){
        message = "the_files_types_must_be";
      }
      if(message.contains("failed to upload")){
        message = "failed_to_upload";
      }
      _pickedImageFiles = [];
      _selectedImageList = [];
      _otherFile=null;
      objFile =null;
      _file=null;
      SnackBarWidget(message.tr);
    }
    else{
      isSending = false;
      _pickedImageFiles = [];
      _selectedImageList = [];
      _otherFile=null;
      objFile =null;
      _file=null;
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
  }

   late PrivateChannel channel;

  String id ="";

  void subscribeMessageChannel(String tripId){
    id = "";
    if(id == ""){
      id = tripId;
    }

    if (Get.find<SplashController>().pusherConnectionStatus != null || Get.find<SplashController>().pusherConnectionStatus == 'Connected'){
      channel = PusherHelper.pusherClient!.privateChannel("private-driver-ride-chat.$id", authorizationDelegate:
      EndpointAuthorizableChannelTokenAuthorizationDelegate.forPrivateChannel(
        authorizationEndpoint: Uri.parse('https://${Get.find<SplashController>().config!.webSocketUrl}/broadcasting/auth'),
        headers:  {
          "Accept": "application/json",
          "Authorization": "Bearer ${Get.find<AuthController>().getUserToken()}",
          "Access-Control-Allow-Origin": "*",
          'Access-Control-Allow-Methods':"PUT, GET, POST, DELETE, OPTIONS"
        },
      ));
      if(channel.currentStatus == null){
        channel.subscribe();

        channel.bind("driver-ride-chat.$id").listen((event) {
          if(id == jsonDecode(event.data!)['channel_conversation']['channel']['trip_id']){
            messageModel!.data!.insert(0,Message.fromJson(jsonDecode(event.data!)['channel_conversation']));
            update();
          }
        });
      }
    }

  }



  bool _channelRideStatus = true;
  bool get channelRideStatus => _channelRideStatus;
  void findChannelRideStatus(String channelId) async{
    Response response = await chatServiceInterface.findChannelRideStatus(channelId);
     if(response.body['data'] == "cancelled" || response.body['data'] == 'completed'){
       _channelRideStatus = false;
     }else{
       _channelRideStatus = true;
     }
     update();
  }



}