import 'package:ride_sharing_user_app/features/chat/domain/models/channel_model.dart';

class MessageModel {
    String? responseCode;
    String? message;
    int? totalSize;
    String? limit;
    String? offset;
    List<Message>? data;

   MessageModel({
     this.responseCode,
     this.message,
     this.totalSize,
     this.limit,
     this.offset,
     this.data,
   });

  MessageModel.fromJson(Map<String, dynamic> json){
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    data = List.from(json['data']).map((e)=>Message.fromJson(e)).toList();

  }

}

class Message {
   int? id;
   String? userId;
   String? message;
   String? tripId;
   String? updatedAt;
   String? createdAt;
   List<ConversationFiles>? conversationFiles;
   User? user;
   Message({
     this.id,
     this.userId,
     this.message,
     this.updatedAt,
     this.conversationFiles,
     this.user,
     this.tripId
   });

  Message.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    message = json['message'];
    tripId = json['trip_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    if (json['conversation_files'] != null) {
      conversationFiles = <ConversationFiles>[];
      json['conversation_files'].forEach((v) {
        conversationFiles!.add(ConversationFiles.fromJson(v));
      });
    }
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
}
class ConversationFiles {
  int? id;
  String? fileName;
  String? fileType;
  String? fileSize;

  ConversationFiles({this.id, this.fileName, this.fileType, this.fileSize});

  ConversationFiles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileName = json['file_name'];
    fileType = json['file_type'];
    fileSize = json['file_size'];
  }

}