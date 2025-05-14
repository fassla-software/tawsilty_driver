class LeaderBoardModel {
  String? responseCode;
  String? message;
  int? totalSize;
  String? limit;
  String? offset;
  List<Leader>? data;


  LeaderBoardModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data,
     });

  LeaderBoardModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Leader>[];
      json['data'].forEach((v) {
        data!.add(Leader.fromJson(v));
      });
    }

  }

}

class Leader {
  String? driverId;
  int? totalRecords;
  String? income;
  Driver? driver;

  Leader({this.driverId, this.totalRecords, this.income, this.driver});

  Leader.fromJson(Map<String, dynamic> json) {
    driverId = json['driver_id'];
    totalRecords = json['total_records'];
    income = json['income'];
    driver =
    json['driver'] != null ? Driver.fromJson(json['driver']) : null;
  }


}

class Driver {
  String? id;
  String? userLevelId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? profileImage;


  Driver(
      {this.id,
        this.userLevelId,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.profileImage,
       });

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userLevelId = json['user_level_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    profileImage = json['profile_image'];
  }
}
