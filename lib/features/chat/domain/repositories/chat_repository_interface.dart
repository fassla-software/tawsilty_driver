
import 'package:file_picker/file_picker.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/interface/repository_interface.dart';

abstract class ChatRepositoryInterface implements RepositoryInterface {

  Future<Response> createChannel(String userId,String tripId);
  Future<Response> getChannelList(int offset);
  Future<Response> getConversation(String channelId,int offset);
  Future<Response> findChannelRideStatus(String channelId);
  Future<Response> sendMessage(String message,String channelID, String tripId, List<MultipartBody> file, PlatformFile? platformFile);
}