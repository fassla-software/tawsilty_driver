class FinalFareModel {
  String? responseCode;
  String? message;
  FinalFare? data;


  FinalFareModel(
      {this.responseCode,
        this.message,
        this.data,
      });

  FinalFareModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    data = json['data'] != null ? FinalFare.fromJson(json['data']) : null;

  }

}

class FinalFare {
  String? id;
  String? refId;
  double? estimatedFare;
  double? actualFare;
  double? estimatedDistance;
  double? paidFare;
  double? actualDistance;
  String? paymentStatus;
  String? paymentMethod;
  double? couponAmount;
  double? discountAmount;
  String? note;
  String? otp;
  int? riseRequestCount;
  String? type;
  String? createdAt;
  String? entrance;
  String? encodedPolyline;
  String? currentStatus;
  bool? isPaused;
  Coupon? coupon;
  Discount? discount;
  String? screenshot;
  double? distanceWiseFare;
  PickupCoordinates? pickupCoordinates;
  String? pickupAddress;
  PickupCoordinates? destinationCoordinates;
  String? destinationAddress;
  PickupCoordinates? startCoordinates;
  PickupCoordinates? dropCoordinates;
  PickupCoordinates? customerRequestCoordinates;
  String? intermediateAddresses;
  double? idleFee;
  double? delayFee;
  double? cancellationFee;
  String? cancelledBy;
  double? vatTax;
  double? tips;
  double? waitingTime;
  double? delayTime;
  double? idleTime;
  double? actualTime;
  double? estimatedTime;

  FinalFare(
      {this.id,
        this.refId,
        this.estimatedFare,
        this.actualFare,
        this.estimatedDistance,
        this.paidFare,
        this.actualDistance,
        this.paymentStatus,
        this.paymentMethod,
        this.couponAmount,
        this.discountAmount,
        this.note,
        this.otp,
        this.riseRequestCount,
        this.type,
        this.createdAt,
        this.entrance,
        this.encodedPolyline,
        this.currentStatus,
        this.isPaused,
        this.coupon,
        this.discount,
        this.screenshot,
        this.distanceWiseFare,
        this.pickupCoordinates,
        this.pickupAddress,
        this.destinationCoordinates,
        this.destinationAddress,
        this.startCoordinates,
        this.dropCoordinates,
        this.customerRequestCoordinates,
        this.intermediateAddresses,
        this.idleFee,
        this.delayFee,
        this.cancellationFee,
        this.cancelledBy,
        this.vatTax,
        this.tips,
        this.waitingTime,
        this.delayTime,
        this.idleTime,
        this.actualTime,
        this.estimatedTime});

  FinalFare.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    refId = json['ref_id'];
    if(json['estimated_fare'] != null){
      estimatedFare = json['estimated_fare'].toDouble();
    }

    if(json['actual_fare'] != null){
      actualFare = json['actual_fare'].toDouble();
    }

    if(json['estimated_distance'] != null){
      estimatedDistance = json['estimated_distance'].toDouble();
    }
    if(json['paid_fare'] != null){
      paidFare = json['paid_fare'].toDouble();
    }
    if(json['actual_distance'] != null){
      actualDistance = json['actual_distance'].toDouble();
    }


    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    if(json['coupon_amount'] != null)
    {
      couponAmount = json['coupon_amount'].toDouble();
    }
    if(json['discount_amount'] != null){
      discountAmount = json['discount_amount'].toDouble();
    }else{
      discountAmount = 0;
    }

    note = json['note'];
    otp = json['otp'];
    riseRequestCount = json['rise_request_count'];
    type = json['type'];
    createdAt = json['created_at'];
    entrance = json['entrance'];
    encodedPolyline = json['encoded_polyline'];
    currentStatus = json['current_status'];
    isPaused = json['is_paused'];
    coupon =
    json['coupon'] != null ? Coupon.fromJson(json['coupon']) : null;
    discount = json['discount'] != null ? Discount.fromJson(json['discount']) : null;
    screenshot = json['screenshot'];
    if(json['distance_wise_fare'] != null){
      distanceWiseFare = json['distance_wise_fare'].toDouble();
    }

    pickupCoordinates = json['pickup_coordinates'] != null
        ? PickupCoordinates.fromJson(json['pickup_coordinates'])
        : null;
    pickupAddress = json['pickup_address'];
    destinationCoordinates = json['destination_coordinates'] != null
        ? PickupCoordinates.fromJson(json['destination_coordinates'])
        : null;
    destinationAddress = json['destination_address'];
    startCoordinates = json['start_coordinates'] != null
        ? PickupCoordinates.fromJson(json['start_coordinates'])
        : null;
    dropCoordinates = json['drop_coordinates'] != null
        ? PickupCoordinates.fromJson(json['drop_coordinates'])
        : null;

    customerRequestCoordinates = json['customer_request_coordinates'] != null
        ? PickupCoordinates.fromJson(json['customer_request_coordinates'])
        : null;

    intermediateAddresses = json['intermediate_addresses'];
    if(json['idle_fee'] != null){
      idleFee = json['idle_fee'].toDouble();
    }
    if(json['delay_fee'] != null){
      delayFee = json['delay_fee'].toDouble();
    }
    if(json['cancellation_fee'] != null){
      cancellationFee = json['cancellation_fee'].toDouble();
    }

    cancelledBy = json['cancelled_by'];
    if(json['vat_tax'] != null){
      vatTax = json['vat_tax'].toDouble();
    }

    if(json['tips'] != null){
      tips = json['tips'].toDouble();
    }
    if(json['waiting_time'] != null){
      waitingTime = json['waiting_time'].toDouble();
    }
    if(json['delay_time'] != null){
      delayTime = json['delay_time'].toDouble();
    }
    if(json['idle_time'] != null){
      idleTime = json['idle_time'].toDouble();
    }
    if(json['actual_time'] != null){
      actualTime = json['actual_time'].toDouble();
    }

    if(json['estimated_time'] != null){
      estimatedTime = json['estimated_time'].toDouble();
    }

  }

}





class Coupon {
  String? id;
  String? name;
  String? description;
  String? customerId;
  String? minTripAmount;
  String? maxCouponAmount;
  String? coupon;
  String? amountType;
  String? couponType;
  String? couponCode;
  int? limit;
  String? startDate;
  String? endDate;
  String? rules;
  int? isActive;
  String? createdAt;

  Coupon(
      {this.id,
        this.name,
        this.description,
        this.customerId,
        this.minTripAmount,
        this.maxCouponAmount,
        this.coupon,
        this.amountType,
        this.couponType,
        this.couponCode,
        this.limit,
        this.startDate,
        this.endDate,
        this.rules,
        this.isActive,
        this.createdAt});

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    customerId = json['customer_id'];
    minTripAmount = json['min_trip_amount'];
    maxCouponAmount = json['max_coupon_amount'];
    coupon = json['coupon'];
    amountType = json['amount_type'];
    couponType = json['coupon_type'];
    couponCode = json['coupon_code'];
    limit = json['limit'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    rules = json['rules'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
  }

}


class PickupCoordinates {
  String? type;
  List<double>? coordinates;

  PickupCoordinates({this.type, this.coordinates});

  PickupCoordinates.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

}

class Discount {
  String? id;
  String? title;
  String? shortDescription;
  String? termsConditions;
  String? image;
  int? discountAmount;
  List<String>? zoneDiscount;
  List<String>? customerLevelDiscount;
  List<String>? customerDiscount;
  List<String>? moduleDiscount;
  String? discountAmountType;
  int? maxDiscountAmount;
  int? minTripAmount;
  int? limit;
  String? startDate;
  String? endDate;
  bool? isActive;
  String? createdAt;

  Discount(
      {this.id,
        this.title,
        this.shortDescription,
        this.termsConditions,
        this.image,
        this.discountAmount,
        this.zoneDiscount,
        this.customerLevelDiscount,
        this.customerDiscount,
        this.moduleDiscount,
        this.discountAmountType,
        this.maxDiscountAmount,
        this.minTripAmount,
        this.limit,
        this.startDate,
        this.endDate,
        this.isActive,
        this.createdAt});

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    shortDescription = json['short_description'];
    termsConditions = json['terms_conditions'];
    image = json['image'];
    discountAmount = json['discount_amount'];
    zoneDiscount = json['zone_discount'].cast<String>();
    customerLevelDiscount = json['customer_level_discount'].cast<String>();
    customerDiscount = json['customer_discount'].cast<String>();
    moduleDiscount = json['module_discount'].cast<String>();
    discountAmountType = json['discount_amount_type'];
    maxDiscountAmount = json['max_discount_amount'];
    minTripAmount = json['min_trip_amount'];
    limit = json['limit'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['short_description'] = shortDescription;
    data['terms_conditions'] = termsConditions;
    data['image'] = image;
    data['discount_amount'] = discountAmount;
    data['zone_discount'] = zoneDiscount;
    data['customer_level_discount'] = customerLevelDiscount;
    data['customer_discount'] = customerDiscount;
    data['module_discount'] = moduleDiscount;
    data['discount_amount_type'] = discountAmountType;
    data['max_discount_amount'] = maxDiscountAmount;
    data['min_trip_amount'] = minTripAmount;
    data['limit'] = limit;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    return data;
  }
}
