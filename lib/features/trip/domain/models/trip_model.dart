import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';

class TripModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<TripDetail>? data;

  TripModel(
      {
        this.totalSize,
        this.limit,
        this.offset,
        this.data,
      });

  TripModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <TripDetail>[];
      json['data'].forEach((v) {
        data!.add(TripDetail.fromJson(v));
      });
    }

  }

}

