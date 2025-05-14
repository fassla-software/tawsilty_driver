class LoyaltyPointModel {
  String? responseCode;
  String? message;
  int? totalSize;
  String? limit;
  String? offset;
  List<Points>? data;


  LoyaltyPointModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data
      });

  LoyaltyPointModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size']??0;
    if(json['limit'] != null){
      limit = json['limit'].toString();
    }else{
      limit = '10';
    }
    if(json['offset']!=null){
      offset = json['offset'].toString();
    }else{
      offset = '1';
    }

    if (json['data'] != null) {
      data = <Points>[];
      json['data'].forEach((v) {
        data!.add(Points.fromJson(v));
      });
    }

  }

}

class Points {
  String? userId;
  String? model;
  String? modelId;
  double? points;
  String? type;
  String? createdAt;

  Points(
      {this.userId,
        this.model,
        this.modelId,
        this.points,
        this.type,
        this.createdAt});

  Points.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    model = json['model'];
    modelId = json['model_id'];
    if(json['points'] != null){
      points = json['points'].toDouble();
    }else{
      points = 0;
    }

    type = json['type'];
    createdAt = json['created_at'];
  }

}
