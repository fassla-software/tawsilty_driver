class ReviewModel {
  String? responseCode;
  String? message;
  int? totalSize;
  String? limit;
  String? offset;
  List<Review>? data;


  ReviewModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data
      });

  ReviewModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Review>[];
      json['data'].forEach((v) {
        data!.add(Review.fromJson(v));
      });
    }
  }

}

class Review {
  int? id;
  String? tripRequestId;
  GivenUser? givenUser;
  String? tripType;
  int? rating;
  String? feedback;
  bool? isSaved;
  String? createdAt;
  String? tripRefId;
  bool? isLoading;


  Review(
      {
        this.id,
        this.tripRequestId,
        this.givenUser,
        this.tripType,
        this.rating,
        this.feedback,
        this.isSaved,
        this.createdAt,
        this.tripRefId,
        this.isLoading
      });

  Review.fromJson(Map<String, dynamic> json) {

    id = json['id'];
    tripRequestId = json['trip_request_id'];
    givenUser = json['given_user'] != null
        ? GivenUser.fromJson(json['given_user'])
        : null;
    tripType = json['trip_type'];
    rating = json['rating'];
    feedback = json['feedback'];
    isSaved = json['is_saved'];
    createdAt = json['created_at'];
    tripRefId = json['trip_ref_id'];
    isLoading = false;
  }


}

class GivenUser {
  String? id;
  String? firstName;
  String? lastName;
  String? phone;
  String? profileImage;


  GivenUser(
      {this.id,
        this.firstName,
        this.lastName,
        this.phone,
        this.profileImage
      });

  GivenUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    profileImage = json['profile_image'];
  }

}
