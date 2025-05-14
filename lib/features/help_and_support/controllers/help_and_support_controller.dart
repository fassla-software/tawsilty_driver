import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/chat/domain/models/message_model.dart';
import 'package:ride_sharing_user_app/features/help_and_support/domain/models/predefined_faq_model.dart';
import 'package:ride_sharing_user_app/features/help_and_support/domain/services/help_and_support_service_interface.dart';
import 'package:ride_sharing_user_app/features/help_and_support/screens/support_chat_screen.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';

class HelpAndSupportController extends GetxController implements GetxService {
  final HelpAndSupportServiceInterface helpAndSupportServiceInterface;
  HelpAndSupportController({required this.helpAndSupportServiceInterface});

  List<String> helpAndSupportTypeList = ['help_and_support', 'legal'];
  int _helpAndSupportIndex = 0;
  int get helpAndSupportIndex => _helpAndSupportIndex;
  MessageModel? messageModel;
  List<XFile>? _pickedImageFiles = [];
  List<XFile>? get pickedImageFile => _pickedImageFiles;
  bool _isPickedImage = false;
  bool get isPickedImage => _isPickedImage;
  PlatformFile? objFile;
  List<MultipartBody> _selectedImageList = [];
  List<MultipartBody> get selectedImageList => _selectedImageList;
  var conversationController = TextEditingController();
  final GlobalKey<FormState> textKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isSending = false;
  List<MultipartDocument> documents = [];
  FilePickerResult? _otherFile;
  FilePickerResult? get otherFile => _otherFile;
  bool showFaqQuestions = false;
  PredefineFawModel? predefineFawModel;

  void updateShowFaq(bool action, {bool isUpdate = false}) {
    showFaqQuestions = action;
    if (isUpdate) {
      update();
    }
  }

  void setHelpAndSupportIndex(int index) {
    _helpAndSupportIndex = index;
    update();
  }

  void pickMultipleImage(bool isRemove, {int? index}) async {
    showFaqQuestions = false;
    if (isRemove) {
      if (index != null) {
        _pickedImageFiles!.removeAt(index);
        _selectedImageList.removeAt(index);
      }
    } else {
      _isPickedImage = true;
      Future.delayed(const Duration(seconds: 1)).then((value) {
        update();
      });

      _pickedImageFiles = await ImagePicker().pickMultiImage(imageQuality: 40);
      if (_pickedImageFiles != null) {
        for (int i = 0; i < _pickedImageFiles!.length; i++) {
          _selectedImageList
              .add(MultipartBody('files[$i]', _pickedImageFiles![i]));
        }
      }
      _isPickedImage = false;
    }
    update();
  }

  Future<bool> pickOtherFile() async {
    showFaqQuestions = false;
    _otherFile = (await FilePicker.platform.pickFiles(withReadStream: true))!;
    if (_otherFile != null) {
      objFile = _otherFile!.files.single;
      documents.add(MultipartDocument('upload_documents[]', objFile));
    }
    update();
    return true;
  }

  void removeFile(int index) async {
    documents.removeAt(index);
    update();
  }

  Future<void> createChannel({bool fromSplash = false}) async {
    isLoading = true;
    Response response = await helpAndSupportServiceInterface.createChannel();
    if (response.statusCode == 200) {
      isLoading = false;
      Map map = response.body;
      String channelId = map['data']['channel']['id'];
      if (fromSplash) {
        Get.offAll(() => SupportChatScreen(channelId: channelId));
      } else {
        Get.to(() => SupportChatScreen(channelId: channelId));
      }
    } else {
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> sendMessage(String channelId, String message,
      {bool fromFaq = false}) async {
    isSending = true;
    update();
    Response response = fromFaq
        ? await helpAndSupportServiceInterface.sendFaqMessage(
            questionId: message, channelId: channelId)
        : await helpAndSupportServiceInterface.sendMessage(
            message: message,
            channelId: channelId,
            images: _selectedImageList,
            documents: documents);
    if (response.statusCode == 200) {
      isSending = false;
      getConversation(channelId, 1);
      conversationController.text = '';
      _pickedImageFiles = [];
      _selectedImageList = [];
      documents = [];
      _otherFile = null;
      objFile = null;
    } else if (response.statusCode == 400) {
      isSending = false;
      String message = response.body['errors'][0]['message'];
      if (message.contains("png  jpg  jpeg  csv  txt  xlx  xls  pdf")) {
        message = "the_files_types_must_be";
      }
      if (message.contains("failed to upload")) {
        message = "failed_to_upload";
      }
      _pickedImageFiles = [];
      _selectedImageList = [];
      documents = [];
      _otherFile = null;
      objFile = null;
      showCustomSnackBar(message.tr);
    } else {
      isSending = false;
      _pickedImageFiles = [];
      _selectedImageList = [];
      documents = [];
      _otherFile = null;
      objFile = null;
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
  }

  Future<Response> getConversation(String channelId, int offset) async {
    isLoading = true;
    Response response =
        await helpAndSupportServiceInterface.getConversation(channelId, offset);
    if (response.statusCode == 200) {
      if (offset == 1) {
        messageModel = MessageModel.fromJson(response.body);
      } else {
        messageModel!.totalSize =
            MessageModel.fromJson(response.body).totalSize;
        messageModel!.offset = MessageModel.fromJson(response.body).offset;
        messageModel!.data!.addAll(MessageModel.fromJson(response.body).data!);
      }
      isLoading = false;
    } else {
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  bool isSameUserWithPreviousMessage(
      Message? previousConversation, Message? currentConversation) {
    if (previousConversation?.user?.id == currentConversation?.user?.id &&
        previousConversation?.message != null &&
        currentConversation?.message != null) {
      return true;
    }
    return false;
  }

  bool isSameUserWithNextMessage(
      Message? currentConversation, Message? nextConversation) {
    if (currentConversation?.user?.id == nextConversation?.user?.id &&
        nextConversation?.message != null &&
        currentConversation?.message != null) {
      return true;
    }
    return false;
  }

  void getPredefineFaqList() async {
    Response response =
        await helpAndSupportServiceInterface.getPredefineFaqList();
    if (response.statusCode == 200) {
      predefineFawModel = PredefineFawModel.fromJson(response.body);
    } else {
      ApiChecker.checkApi(response);
    }
  }

  void downloadFile({required String url, required String fileName}) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    if (GetPlatform.isIOS) {
      HttpClientResponse apiResponse =
          await helpAndSupportServiceInterface.downloadFile(url);
      if (apiResponse.statusCode == 200) {
        List<int> downloadData = [];
        Directory downloadDirectory;

        if (Platform.isIOS) {
          downloadDirectory = await getApplicationDocumentsDirectory();
        } else {
          downloadDirectory = Directory('/storage/emulated/0/Download');
          if (!await downloadDirectory.exists())
            downloadDirectory = (await getExternalStorageDirectory())!;
        }

        String filePathName = "${downloadDirectory.path}/$fileName";
        File savedFile = File(filePathName);
        bool fileExists = await savedFile.exists();

        if (fileExists) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text('file_already_downloaded'.tr)));
          // await OpenFile.open(filePathName);
        } else {
          apiResponse.listen((d) => downloadData.addAll(d), onDone: () {
            savedFile.writeAsBytes(downloadData);
          });
          showCustomSnackBar('downloaded_successfully'.tr, isError: false);
        }
      } else {
        showCustomSnackBar('download_failed'.tr, isError: true);
      }
    } else {
      String? task;
      Directory downloadDirectory = Directory('/storage/emulated/0/Download');
      String filePathName = "${downloadDirectory.path}/$fileName";
      File savedFile = File(filePathName);
      bool fileExists = await savedFile.exists();

      if (fileExists) {
        showCustomSnackBar('file_already_downloaded'.tr);
        // await OpenFile.open(filePathName);
      } else {
        task = await FlutterDownloader.enqueue(
          url: url,
          savedDir: downloadDirectory.path,
          fileName: fileName,
          showNotification: true,
          saveInPublicStorage: true,
          openFileFromNotification: true,
        );

        if (task != null) {
          showCustomSnackBar('downloaded_successfully'.tr, isError: false);
        } else {
          showCustomSnackBar('download_failed'.tr, isError: true);
        }
      }
    }
  }
}
