import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';

class PendingRideRequestModel {
  String? responseCode;
  String? message;
  int? totalSize;
  String? limit;
  String? offset;
  List<TripDetail>? data;


  PendingRideRequestModel({this.responseCode, this.message, this.totalSize, this.limit, this.offset, this.data});

  PendingRideRequestModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <TripDetail>[];
      json['data'].forEach((v) { data!.add(TripDetail.fromJson(v)); });
    }

  }


}


