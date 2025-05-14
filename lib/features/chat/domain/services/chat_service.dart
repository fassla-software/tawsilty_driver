import 'package:file_picker/src/platform_file.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:ride_sharing_user_app/features/chat/domain/services/chat_service_interface.dart';

class ChatService implements ChatServiceInterface{
final ChatRepositoryInterface chatRepositoryInterface;
 ChatService({required this.chatRepositoryInterface});

  @override
  Future createChannel(String userId, String tripId) {
    return chatRepositoryInterface.createChannel(userId,tripId);
  }

  @override
  Future getChannelList(int offset) {
    return chatRepositoryInterface.getChannelList(offset);
  }

  @override
  Future getConversation(String channelId, int offset) {
    return chatRepositoryInterface.getConversation(channelId, offset);
  }

  @override
  Future sendMessage(String message, String channelID, String tripId, List<MultipartBody> file, PlatformFile? platformFile) {
    return chatRepositoryInterface.sendMessage(message, channelID, tripId, file, platformFile);
  }

  @override
  Future findChannelRideStatus(String channelId) {
    return chatRepositoryInterface.findChannelRideStatus(channelId);
  }


}