class NotificationModel {
  int id;
  Data data;
  String createdAt;

  NotificationModel({required this.id, required this.data, required this.createdAt});

}

class Data {
  String? title;
  String? description;
  String? image;

  Data({ this.title, this.description, this.image});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    image = json['image'];
  }
}
