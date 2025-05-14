class WithdrawModel {
  String? responseCode;
  String? message;
  int? totalSize;
  String? limit;
  String? offset;
  List<Withdraw>? data;


  WithdrawModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data
      });

  WithdrawModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Withdraw>[];
      json['data'].forEach((v) {
        data!.add(Withdraw.fromJson(v));
      });
    }
  }
}

class Withdraw {
  int? id;
  String? methodName;
  List<MethodFields>? methodFields;
  bool? isDefault;
  bool? isActive;
  String? createdAt;

  Withdraw(
      {this.id,
        this.methodName,
        this.methodFields,
        this.isDefault,
        this.isActive,
        this.createdAt});

  Withdraw.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    methodName = json['method_name'];
    if (json['method_fields'] != null) {
      methodFields = <MethodFields>[];
      json['method_fields'].forEach((v) {
        methodFields!.add(MethodFields.fromJson(v));
      });
    }
    isDefault = json['is_default'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
  }
}

class MethodFields {
  String? inputType;
  String? inputName;
  String? placeholder;
  int? isRequired;

  MethodFields(
      {this.inputType, this.inputName, this.placeholder, this.isRequired});

  MethodFields.fromJson(Map<String, dynamic> json) {
    inputType = json['input_type'];
    inputName = json['input_name'];
    placeholder = json['placeholder'];
    if(json['is_required'] != null){
      try{
        isRequired = json['is_required'];
      }catch(e){
        isRequired = json['is_required']?1:0;
      }
    }

  }

}
