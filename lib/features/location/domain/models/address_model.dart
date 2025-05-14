class AddressModel {
  String? responseCode;
  String? message;
  int? totalSize;
  String? limit;
  String? offset;
  List<Address>? data;


  AddressModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data,
        });

  AddressModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Address>[];
      json['data'].forEach((v) {
        data!.add(Address.fromJson(v));
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

class Address {
  int? id;
  String? userId;
  String? latitude;
  String? longitude;
  String? street;
  String? house;
  String? contactPersonName;
  String? contactPersonPhone;
  String? address;
  String? addressLabel;
  String? createdAt;

  Address(
      {this.id,
        this.userId,
        this.latitude,
        this.longitude,
        this.street,
        this.house,
        this.contactPersonName,
        this.contactPersonPhone,
        this.address,
        this.addressLabel,
        this.createdAt});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    street = json['street'];
    house = json['house'];
    contactPersonName = json['contact_person_name'];
    contactPersonPhone = json['contact_person_phone'];
    address = json['address'];
    addressLabel = json['address_label'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['street'] = street;
    data['house'] = house;
    data['contact_person_name'] = contactPersonName;
    data['contact_person_phone'] = contactPersonPhone;
    data['address'] = address;
    data['address_label'] = addressLabel;
    data['created_at'] = createdAt;
    return data;
  }
}
