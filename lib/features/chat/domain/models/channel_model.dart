class ChannelModel {
  String? responseCode;
  String? message;
  int? totalSize;
  String? limit;
  String? offset;
  List<Data>? data;


  ChannelModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data,
      });

  ChannelModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

}

class Data {
  String? id;
  String? updatedAt;
  String? tripId;
  int? unReadCount;
  List<ChannelUsers>? channelUsers;
  LastChannelConversations? lastChannelConversations;

  Data({this.id, this.updatedAt, this.channelUsers, this.lastChannelConversations,});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tripId = json['trip_id'];
    updatedAt = json['updated_at'];
    unReadCount = json['unread_customer_channel_conversations'];
    if (json['channel_users'] != null) {
      channelUsers = <ChannelUsers>[];
      json['channel_users'].forEach((v) {
        channelUsers!.add(ChannelUsers.fromJson(v));
      });
    }
    lastChannelConversations = json['last_channel_conversations'] != null
        ? LastChannelConversations.fromJson(
        json['last_channel_conversations'])
        : null;
  }

}

class ChannelUsers {
  int? id;
  String? channelId;
  String? userId;
  int? isRead;
  String? updatedAt;
  User? user;

  ChannelUsers(
      {this.id,
        this.channelId,
        this.userId,
        this.isRead,
        this.updatedAt,
        this.user});

  ChannelUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    channelId = json['channel_id'];
    userId = json['user_id'];
    isRead = json['is_read'] ? 1 : 0;
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? profileImage;
  String? userType;

  User(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.profileImage,
        this.userType
        });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    profileImage = json['profile_image'];
    userType = json['user_type'];

  }

}
class LastChannelConversations {


   String? message;
  LastChannelConversations({
    this.message,

  });

  LastChannelConversations.fromJson(Map<String, dynamic> json){
    message = json['message'];
  }
}
