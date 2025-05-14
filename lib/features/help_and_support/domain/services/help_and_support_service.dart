import 'dart:io';

import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/help_and_support/domain/repositories/help_and_support_repository_interface.dart';
import 'package:ride_sharing_user_app/features/help_and_support/domain/services/help_and_support_service_interface.dart';

class HelpAndSupportService implements HelpAndSupportServiceInterface{
  final HelpAndSupportRepositoryInterface helpAndSupportRepositoryInterface;
  const HelpAndSupportService({required this.helpAndSupportRepositoryInterface});

  @override
  Future createChannel() {
    return helpAndSupportRepositoryInterface.createChannel();
  }

  @override
  Future sendMessage({String? message, String? channelId, List<MultipartBody>? images, List<MultipartDocument>? documents}) {
    return helpAndSupportRepositoryInterface.sendMessage(message: message, channelId: channelId, images: images, documents: documents);
  }

  @override
  Future sendFaqMessage({String? questionId, String? channelId, List<MultipartBody>? images, List<MultipartDocument>? documents}) {
    return helpAndSupportRepositoryInterface.sendFaqMessage(questionId: questionId, channelId: channelId);
  }

  @override
  Future getConversation(String channelId, int offset) {
    return helpAndSupportRepositoryInterface.getConversation(channelId, offset);
  }

  @override
  Future getPredefineFaqList() {
    return helpAndSupportRepositoryInterface.getPredefineFaqList();
  }

  @override
  Future<HttpClientResponse> downloadFile(String url) async{
    return await helpAndSupportRepositoryInterface.downloadFile(url);
  }
}