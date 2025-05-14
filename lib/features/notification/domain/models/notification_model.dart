class NotificationsModel {
  String? responseCode;
  String? message;
  int? totalSize;
  String? limit;
  String? offset;
  List<Notifications>? data;


  NotificationsModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data,
        });

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Notifications>[];
      json['data'].forEach((v) {
        data!.add(Notifications.fromJson(v));
      });
    }

  }

}

class Notifications {
  int? id;
  String? userId;
  String? rideRequestId;
  String? title;
  String? description;
  String? type;
  String? action;
  String? createdAt;

  Notifications(
      {this.id,
        this.userId,
        this.rideRequestId,
        this.title,
        this.description,
        this.type,
        this.action,
        this.createdAt});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    rideRequestId = json['ride_request_id'];
    title = json['title'];
    description = json['description'];
    type = json['type'];
    action = json['action'];
    createdAt = json['created_at'];
  }


}
