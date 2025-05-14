import 'package:ride_sharing_user_app/features/profile/domain/models/categoty_model.dart';
import 'package:ride_sharing_user_app/features/profile/domain/models/vehicle_brand_model.dart';

class ProfileModel {
  String? responseCode;
  ProfileInfo? data;

  ProfileModel({
    this.responseCode,
    this.data,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    data = json['data'] != null ? ProfileInfo.fromJson(json['data']) : null;
  }
}

class ProfileInfo {
  String? id;
  String? firstName;
  String? lastName;
  Level? level;
  Vehicle? vehicle;
  String? email;
  String? phone;
  String? identificationNumber;
  String? identificationType;
  String? profileImage;
  String? phoneVerifiedAt;
  String? userType;
  Details? details;
  int? vehicleStatus;
  Wallet? wallet;
  int? loyaltyPoint;
  TimeTrack? timeTrack;
  double? avgRatting;
  List<String>? identificationImage;
  bool? isOldIdentificationImage;
  double? tripIncome;
  double? totalTips;
  double? totalEarning;
  double? totalCommission;
  double? paidAmount;
  double? levelUpRewardAmount;

  ProfileInfo(
      {this.id,
      this.firstName,
      this.lastName,
      this.level,
      this.vehicle,
      this.email,
      this.phone,
      this.identificationNumber,
      this.identificationType,
      this.profileImage,
      this.phoneVerifiedAt,
      this.userType,
      this.details,
      this.vehicleStatus,
      this.wallet,
      this.loyaltyPoint,
      this.timeTrack,
      this.avgRatting,
      this.identificationImage,
      this.isOldIdentificationImage,
      this.tripIncome,
      this.totalTips,
      this.totalEarning,
      this.totalCommission,
      this.paidAmount,
      this.levelUpRewardAmount});

  ProfileInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    level = json['level'] != null ? Level.fromJson(json['level']) : null;
    vehicle =
        json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    email = json['email'];
    phone = json['phone'];
    identificationNumber = json['identification_number'];
    identificationType = json['identification_type'];
    profileImage = json['profile_image'] ?? '';
    phoneVerifiedAt = json['phone_verified_at'];
    userType = json['user_type'];
    details =
        json['details'] != null ? Details.fromJson(json['details']) : null;
    vehicleStatus = json['vehicle_status'];
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    loyaltyPoint = json['loyalty_points'];
    timeTrack = json['time_track'] != null
        ? TimeTrack.fromJson(json['time_track'])
        : null;
    avgRatting = json['rating'].toDouble();
    tripIncome = json['trip_income'].toDouble();
    totalTips = json['total_tips'].toDouble();
    totalEarning = json['total_earning'].toDouble();
    totalCommission = json['total_commission'].toDouble();
    paidAmount = json['paid_amount'].toDouble();
    levelUpRewardAmount = json['level_up_reward_amount'].toDouble();
    if (json['old_identification_image'] == null &&
        json['identification_image'] == null) {
      identificationImage = null;
    } else if (json['old_identification_image'] == null) {
      identificationImage = json['identification_image'].cast<String>();
      isOldIdentificationImage = false;
    } else {
      identificationImage = json['old_identification_image'].cast<String>();
      isOldIdentificationImage = true;
    }
  }
}

class Level {
  String? id;
  int? sequence;
  String? name;
  String? rewardType;
  String? rewardAmount;
  String? image;
  int? minRide;
  int? minRidePoint;
  int? minEarn;
  int? minEarnPoint;
  int? maxCancel;
  int? maxCancelPoint;
  int? reviewReceived;
  int? reviewReceivedPoint;
  String? userType;
  int? isActive;

  Level(
      {this.id,
      this.sequence,
      this.name,
      this.rewardType,
      this.rewardAmount,
      this.image,
      this.minRide,
      this.minRidePoint,
      this.minEarn,
      this.minEarnPoint,
      this.maxCancel,
      this.maxCancelPoint,
      this.reviewReceived,
      this.reviewReceivedPoint,
      this.userType,
      this.isActive});

  Level.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sequence = json['sequence'];
    name = json['name'];
    rewardType = json['reward_type'];
    rewardAmount = json['reward_amount'];
    image = json['image'];
    minRide = json['min_ride'];
    minRidePoint = json['min_ride_point'];
    minEarn = json['min_earn'];
    minEarnPoint = json['min_earn_point'];
    maxCancel = json['max_cancel'];
    maxCancelPoint = json['max_cancel_point'];
    reviewReceived = json['review_received'];
    reviewReceivedPoint = json['review_received_point'];
    userType = json['user_type'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sequence'] = sequence;
    data['name'] = name;
    data['reward_type'] = rewardType;
    data['reward_amount'] = rewardAmount;
    data['image'] = image;
    data['min_ride'] = minRide;
    data['min_ride_point'] = minRidePoint;
    data['min_earn'] = minEarn;
    data['min_earn_point'] = minEarnPoint;
    data['max_cancel'] = maxCancel;
    data['max_cancel_point'] = maxCancelPoint;
    data['review_received'] = reviewReceived;
    data['review_received_point'] = reviewReceivedPoint;
    data['user_type'] = userType;
    data['is_active'] = isActive;
    return data;
  }
}

class Vehicle {
  String? id;
  Brand? brand;
  VehicleModels? model;
  Category? category;
  String? licencePlateNumber;
  String? licenceExpireDate;
  String? vinNumber;
  String? transmission;
  String? fuelType;
  String? ownership;
  List<String>? documents;
  int? isActive;
  String? createdAt;
  String? parcelWeightCapacity;

  Vehicle(
      {this.id,
      this.brand,
      this.model,
      this.category,
      this.licencePlateNumber,
      this.licenceExpireDate,
      this.vinNumber,
      this.transmission,
      this.fuelType,
      this.ownership,
      this.documents,
      this.isActive,
      this.createdAt,
      this.parcelWeightCapacity});

  Vehicle.fromJson(Map<String, dynamic> json) {
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
    model =
        json['model'] != null ? VehicleModels.fromJson(json['model']) : null;
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    licencePlateNumber = json['licence_plate_number'];
    licenceExpireDate = json['licence_expire_date'];
    vinNumber = json['vin_number'];
    id = json['id'];
    transmission = json['transmission'];
    fuelType = json['fuel_type'];
    ownership = json['ownership'];
    documents = json['documents'].cast<String>();
    isActive = json['is_active'] ? 1 : 0;
    createdAt = json['created_at'];
    parcelWeightCapacity = json['parcel_weight_capacity'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    if (model != null) {
      data['model'] = model!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['licence_plate_number'] = licencePlateNumber;
    data['licence_expire_date'] = licenceExpireDate;
    data['vin_number'] = vinNumber;
    data['transmission'] = transmission;
    data['fuel_type'] = fuelType;
    data['ownership'] = ownership;
    data['documents'] = documents;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;

    return data;
  }
}

class Details {
  int? id;
  String? userId;
  String? isOnline;
  String? availabilityStatus;
  String? updatedAt;
  String? online;
  String? offline;
  double? onlineTime;
  double? onDrivingTime;
  double? idleTime;
  List<String>? services;

  Details(
      {this.id,
      this.userId,
      this.isOnline,
      this.availabilityStatus,
      this.updatedAt,
      this.online,
      this.offline,
      this.onlineTime,
      this.onDrivingTime,
      this.idleTime,
      this.services});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    isOnline = json['is_online'];
    availabilityStatus = json['availability_status'];
    updatedAt = json['updated_at'];
    online = json['online'];
    offline = json['offline'];
    onlineTime =
        json['online_time'] != null ? json['online_time'].toDouble() : 0;
    onDrivingTime = json['on_driving_time'] != null
        ? json['on_driving_time'].toDouble()
        : 0;
    idleTime = json['idle_time'] != null ? json['idle_time'].toDouble() : 0;
    if (json['service'] != null) {
      services = [];
      for (String value in json['service']) {
        services!.add(value);
      }
    }
  }
}

class Wallet {
  String? id;
  double? payableBalance;
  double? receivableBalance;
  double? receivedBalance;
  double? pendingBalance;
  double? walletBalance;
  double? totalWithdrawn;
  double? referralEarn;

  Wallet(
      {this.id,
      this.payableBalance,
      this.receivableBalance,
      this.receivedBalance,
      this.pendingBalance,
      this.walletBalance,
      this.totalWithdrawn,
      this.referralEarn});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    payableBalance = json['payable_balance'].toDouble();
    receivableBalance = json['receivable_balance'].toDouble();
    if (json['received_balance'] != null) {
      try {
        receivedBalance = json['received_balance'].toDouble();
      } catch (e) {
        receivedBalance = double.parse(json['received_balance']);
      }
    } else {
      receivedBalance = 0;
    }
    pendingBalance = json['pending_balance'].toDouble();
    walletBalance = json['wallet_balance'].toDouble();
    totalWithdrawn = json['total_withdrawn'].toDouble();
    referralEarn = json['referral_earn'].toDouble();
  }
}

class TimeTrack {
  int? id;
  String? date;
  int? totalOnline;
  int? totalOffline;
  int? totalIdle;
  int? totalDriving;

  TimeTrack(
      {this.id,
      this.date,
      this.totalOnline,
      this.totalOffline,
      this.totalIdle,
      this.totalDriving});

  TimeTrack.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    totalOnline = json['total_online'];
    totalOffline = json['total_offline'];
    totalIdle = json['total_idle'];
    totalDriving = json['total_driving'];
  }
}
