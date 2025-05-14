class LevelModel {
  String? responseCode;
  String? message;
  int? totalSize;
  int? limit;
  int? offset;
  Data? data;
  List<String>? errors;

  LevelModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data,
        this.errors});

  LevelModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
    errors = json['errors'].cast<String>();
  }

}

class Data {
  NextLevel? nextLevel;
  CurrentLevel? currentLevel;
  CompletedCurrentLevelTarget? completedCurrentLevelTarget;
  bool? isCompleted;

  Data({this.nextLevel, this.currentLevel, this.completedCurrentLevelTarget,this.isCompleted});

  Data.fromJson(Map<String, dynamic> json) {
    nextLevel = json['next_level'] != null
        ?  NextLevel.fromJson(json['next_level'])
        : null;
    currentLevel = json['current_level'] != null
        ?  CurrentLevel.fromJson(json['current_level'])
        : null;
    completedCurrentLevelTarget = json['completed_current_level_target'] != null
        ?  CompletedCurrentLevelTarget.fromJson(
        json['completed_current_level_target'])
        : null;
    isCompleted = json['level_completed'];
  }

}

class NextLevel {
  String? id;
  int? sequence;
  String? name;
  String? rewardType;
  String? rewardAmount;
  String? image;
  double? targetedRide;
  double? targetedRidePoint;
  double? targetedAmount;
  double? targetedAmountPoint;
  double? targetedCancel;
  double? targetedCancelPoint;
  double? targetedReview;
  double? targetedReviewPoint;
  String? userType;
  int? isActive;

  NextLevel(
      {this.id,
        this.sequence,
        this.name,
        this.rewardType,
        this.rewardAmount,
        this.image,
        this.targetedRide,
        this.targetedRidePoint,
        this.targetedAmount,
        this.targetedAmountPoint,
        this.targetedCancel,
        this.targetedCancelPoint,
        this.targetedReview,
        this.targetedReviewPoint,
        this.userType,
        this.isActive});

  NextLevel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sequence = json['sequence'];
    name = json['name'];
    rewardType = json['reward_type'];
    rewardAmount = json['reward_amount'];
    image = json['image'];
    targetedRide = double.parse(json['targeted_ride'].toString());
    targetedRidePoint = double.parse(json['targeted_ride_point'].toString());
    targetedAmount = double.parse(json['targeted_amount'].toString());
    targetedAmountPoint = double.parse(json['targeted_amount_point'].toString());
    targetedCancel = double.parse(json['targeted_cancel'].toString());
    targetedCancelPoint = double.parse(json['targeted_cancel_point'].toString());
    targetedReview = double.parse(json['targeted_review'].toString());
    targetedReviewPoint = double.parse(json['targeted_review_point'].toString());
    userType = json['user_type'];
    isActive = json['is_active'];
  }

}

class CurrentLevel {
  String? id;
  int? sequence;
  String? name;
  String? rewardType;
  String? rewardAmount;
  String? image;
  double? targetedRide;
  double? targetedRidePoint;
  double? targetedAmount;
  double? targetedAmountPoint;
  double? targetedCancel;
  double? targetedCancelPoint;
  double? targetedReview;
  double? targetedReviewPoint;
  String? userType;
  int? isActive;

  CurrentLevel(
      {this.id,
        this.sequence,
        this.name,
        this.rewardType,
        this.rewardAmount,
        this.image,
        this.targetedRide,
        this.targetedRidePoint,
        this.targetedAmount,
        this.targetedAmountPoint,
        this.targetedCancel,
        this.targetedCancelPoint,
        this.targetedReview,
        this.targetedReviewPoint,
        this.userType,
        this.isActive});

  CurrentLevel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sequence = json['sequence'];
    name = json['name'];
    rewardType = json['reward_type'];
    rewardAmount = json['reward_amount'];
    image = json['image'];
    targetedRide = double.parse(json['targeted_ride'].toString());
    targetedRidePoint = double.parse(json['targeted_ride_point'].toString());
    targetedAmount = double.parse(json['targeted_amount'].toString());
    targetedAmountPoint = double.parse(json['targeted_amount_point'].toString());
    targetedCancel = double.parse(json['targeted_cancel'].toString());
    targetedCancelPoint = double.parse(json['targeted_cancel_point'].toString());
    targetedReview = double.parse(json['targeted_review'].toString());
    targetedReviewPoint = double.parse(json['targeted_review_point'].toString());
    userType = json['user_type'];
    isActive = json['is_active'];
  }

}

class CompletedCurrentLevelTarget {
  double? reviewGiven;
  double? rideComplete;
  double? earningAmount;
  double? cancellationRate;
  double? reviewGivenPoint;
  double? rideCompletePoint;
  double? earningAmountPoint;
  double? cancellationRatePoint;

  CompletedCurrentLevelTarget(
      {this.reviewGiven,
        this.rideComplete,
        this.earningAmount,
        this.cancellationRate,
        this.reviewGivenPoint,
        this.cancellationRatePoint,
        this.earningAmountPoint,
        this.rideCompletePoint
      });

  CompletedCurrentLevelTarget.fromJson(Map<String, dynamic> json) {
    reviewGiven = double.parse(json['review_given'].toString());
    rideComplete = double.parse(json['ride_complete'].toString());
    earningAmount = double.parse(json['earning_amount'].toString());
    cancellationRate = double.parse(json['cancellation_rate'].toString());
    reviewGivenPoint = double.parse(json['review_given_point'].toString());
    rideCompletePoint = double.parse(json['ride_complete_point'].toString());
    earningAmountPoint = double.parse(json['earning_amount_point'].toString());
    cancellationRatePoint = double.parse(json['cancellation_rate_point'].toString());
  }

}
