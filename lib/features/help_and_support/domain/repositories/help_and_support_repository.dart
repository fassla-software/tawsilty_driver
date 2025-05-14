import 'dart:io';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/help_and_support/domain/repositories/help_and_support_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class HelpAndSupportRepository implements HelpAndSupportRepositoryInterface{
  final ApiClient apiClient;
  const HelpAndSupportRepository({required this.apiClient});



  @override
  Future<Response> createChannel() async {
    return await apiClient.postData(AppConstants.createChannelWithAdmin, {"_method": "put"});
  }

  @override
  Future<Response> sendMessage({String? message, String? channelId, List<MultipartBody>? images, List<MultipartDocument>? documents}) async{
    return await apiClient.postMultipartMergeWithImageAndDocument(
        AppConstants.sendMessageToAdmin,
        {
          "message": message ?? '',
          "channel_id" : channelId ?? '',
          "_method":"put"
        },
        images,
      documents: documents
    );
  }

  @override
  Future<Response> sendFaqMessage({String? questionId, String? channelId}) async {
    return await apiClient.postData(AppConstants.sendFaqMessageToAdmin, {
      "channel_id" : channelId ?? '',
      "question_id" : questionId ?? '',
      "_method": "put"
    });
  }

  @override
  Future<Response> getConversation(String channelId,int offset) async {
    return await apiClient.getData('${AppConstants.conversationList}?channel_id=$channelId&limit=20&offset=$offset');
  }

  @override
  Future<Response> getPredefineFaqList() async {
    return await apiClient.getData(AppConstants.predefineFawQuestionList);
  }

  @override
  Future<HttpClientResponse> downloadFile(String? url) async {
    HttpClient client = HttpClient();
    final response = await client.getUrl(Uri.parse(url!)).then((HttpClientRequest request) {
      return request.close();
    },
    );
    return response;
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }


}