class VehicleBrandModel {
  String? responseCode;
  String? message;
  int? totalSize;
  String? limit;
  String? offset;
  List<Brand>? data;

  VehicleBrandModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data,
        });

  VehicleBrandModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Brand>[];
      json['data'].forEach((v) {
        data!.add(Brand.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['message'] = message;
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Brand {
  String? id;
  String? name;
  String? description;
  String? image;
  int? isActive;
  List<VehicleModels>? vehicleModels;
  String? createdAt;

  Brand(
      {this.id,
        this.name,
        this.description,
        this.image,
        this.isActive,
        this.vehicleModels,
        this.createdAt});

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    isActive = json['is_active'] ? 1 : 0;
    if (json['vehicle_models'] != null) {
      vehicleModels = <VehicleModels>[];
      json['vehicle_models'].forEach((v) {
        vehicleModels!.add(VehicleModels.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['is_active'] = isActive;
    if (vehicleModels != null) {
      data['vehicle_models'] =
          vehicleModels!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    return data;
  }
}

class VehicleModels {
  String? id;
  String? name;
  int? seatCapacity;
  int? maximumWeight;
  int? hatchBagCapacity;
  String? engine;
  String? description;
  String? image;
  int? isActive;
  String? createdAt;

  VehicleModels(
      {this.id,
        this.name,
        this.seatCapacity,
        this.maximumWeight,
        this.hatchBagCapacity,
        this.engine,
        this.description,
        this.image,
        this.isActive,
        this.createdAt});

  VehicleModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    seatCapacity = json['seat_capacity'];
    maximumWeight = json['maximum_weight'];
    hatchBagCapacity = json['hatch_bag_capacity'];
    engine = json['engine'];
    description = json['description'];
    image = json['image'];
    isActive = json['is_active'] ? 1: 0;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['seat_capacity'] = seatCapacity;
    data['maximum_weight'] = maximumWeight;
    data['hatch_bag_capacity'] = hatchBagCapacity;
    data['engine'] = engine;
    data['description'] = description;
    data['image'] = image;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    return data;
  }
}
