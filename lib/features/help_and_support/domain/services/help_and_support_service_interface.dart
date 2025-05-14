import 'dart:io';
import 'package:ride_sharing_user_app/data/api_client.dart';

abstract class HelpAndSupportServiceInterface{
  Future<dynamic> createChannel();
  Future<dynamic> getPredefineFaqList();
  Future<dynamic> getConversation(String channelId,int offset);
  Future<dynamic> sendMessage({String? message, String? channelId,  List<MultipartBody>? images,  List<MultipartDocument>? documents });
  Future<dynamic> sendFaqMessage({String? questionId, String? channelId});
  Future<HttpClientResponse> downloadFile(String url);
}