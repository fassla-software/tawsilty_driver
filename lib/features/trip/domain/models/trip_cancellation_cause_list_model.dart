class TripCancellationCauseList {
  String? responseCode;
  String? message;
  String? totalSize;
  String? limit;
  String? offset;
  Data? data;
  List<String>? errors;

  TripCancellationCauseList(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data,
        this.errors});

  TripCancellationCauseList.fromJson(Map<String, dynamic> json) {
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
  List<String>? ongoingRide;
  List<String>? acceptedRide;

  Data({this.ongoingRide, this.acceptedRide});

  Data.fromJson(Map<String, dynamic> json) {
    ongoingRide = json['ongoing_ride'].cast<String>();
    acceptedRide = json['accepted_ride'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['ongoing_ride'] = ongoingRide;
    data['accepted_ride'] = acceptedRide;
    return data;
  }
}