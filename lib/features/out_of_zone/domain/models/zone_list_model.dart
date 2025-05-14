
class ZoneListModel {
  String? responseCode;
  String? message;
  int? totalSize;
  String? limit;
  String? offset;
  List<Data>? data;
  List<String>? errors;

  ZoneListModel({this.responseCode, this.message, this.totalSize, this.limit, this.offset, this.data, this.errors});

  ZoneListModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) { data!.add(Data.fromJson(v)); });
    }
    errors = json['errors'].cast<String>();
  }
}

class Data {
  String? id;
  String? name;
  int? readableId;
  ZoneCoordinates? zoneCoordinates;
  bool? isActive;
  String? createdAt;

  Data({this.id, this.name, this.readableId, this.zoneCoordinates, this.isActive, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    readableId = json['readable_id'];
    zoneCoordinates = json['zone_coordinates'] != null ? ZoneCoordinates.fromJson(json['zone_coordinates']) : null;
    isActive = json['is_active'];
    createdAt = json['created_at'];
  }
}

class ZoneCoordinates {
  String? type;
  List<LatLngPoint>? coordinatesPoint;

  ZoneCoordinates({this.type, this.coordinatesPoint});

  ZoneCoordinates.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null) {
      coordinatesPoint = <LatLngPoint>[];
      json['coordinates'].forEach((obj) {
        obj.forEach((v){coordinatesPoint!.add(LatLngPoint(v[1], v[0]));});
      });
    }
  }
}

class LatLngPoint {
  final double latitude;
  final double longitude;
  LatLngPoint(this.latitude, this.longitude);
}

