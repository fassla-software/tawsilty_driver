
class ConfigModel {
  String? businessName;
  String? logo;
  bool? bidOnFare;
  String? countryCode;
  String? businessAddress;
  String? businessContactPhone;
  String? businessContactEmail;
  String? businessSupportPhone;
  String? businessSupportEmail;
  String? baseUrl;
  String? webSocketUrl;
  String? webSocketPort;
  String? webSocketKey;
  ImageBaseUrl? imageBaseUrl;
  String? currencyDecimalPoint;
  String? currencyCode;
  String? currencySymbolPosition;
  AboutUs? aboutUs;
  AboutUs? privacyPolicy;
  AboutUs? termsAndConditions;
  AboutUs? legal;
  bool? smsVerification;
  bool? emailVerification;
  String? mapApiKey;
  int? paginationLimit;
  String? facebookLogin;
  String? googleLogin;
  List<String>? timeZones;
  bool? verification;
  bool? conversionStatus;
  int? conversionRate;
  int? otpResendTime;
  bool? selfRegistration;
  String? currencySymbol;
  bool? reviewStatus;
  MaintenanceMode? maintenanceMode;
  double? completionRadius;
  bool? isDemo;
  bool? levelStatus;
  bool? referralEarningStatus;
  int? parcelReturnTime;
  String? parcelReturnTimeType;
  double? parcelReturnFeeTimeExceed;
  bool? parcelReturnTimeFeeStatus;
  double? androidAppMinimumVersion;
  double? iosAppMinimumVersion;
  String? androidAppUrl;
  String? iosAppUrl;
  bool? isFirebaseOtpVerification;
  bool? isSmsGateway;
  AboutUs? refundPolicy;
  bool? chattingSetupStatus;
  bool? driverQuestionAnswerStatus;
  String? websocketScheme;


  ConfigModel(
      {this.businessName,
        this.logo,
        this.bidOnFare,
        this.countryCode,
        this.businessAddress,
        this.businessContactPhone,
        this.businessContactEmail,
        this.businessSupportPhone,
        this.businessSupportEmail,
        this.baseUrl,
        this.webSocketUrl,
        this.webSocketPort,
        this.webSocketKey,
        this.imageBaseUrl,
        this.currencyDecimalPoint,
        this.currencyCode,
        this.currencySymbolPosition,
        this.aboutUs,
        this.privacyPolicy,
        this.termsAndConditions,
        this.legal,
        this.smsVerification,
        this.emailVerification,
        this.mapApiKey,
        this.paginationLimit,
        this.facebookLogin,
        this.googleLogin,
        this.timeZones,
        this.verification,
        this.conversionStatus,
        this.conversionRate,
        this.otpResendTime,
        this.selfRegistration,
        this.currencySymbol,
        this.reviewStatus,
        this.maintenanceMode,
        this.completionRadius,
        this.isDemo,
        this.levelStatus,
        this.referralEarningStatus,
        this.parcelReturnTime,
        this.parcelReturnFeeTimeExceed,
        this.parcelReturnTimeType,
        this.parcelReturnTimeFeeStatus,
        this.iosAppUrl,
        this.androidAppUrl,
        this.iosAppMinimumVersion,
        this.androidAppMinimumVersion,
        this.isFirebaseOtpVerification,
        this.isSmsGateway,
        this.refundPolicy,
        this.websocketScheme,
        this.driverQuestionAnswerStatus,
        this.chattingSetupStatus

      });

  ConfigModel.fromJson(Map<String, dynamic> json) {
    businessName = json['business_name'];
    logo = json['logo'];
    bidOnFare = json['bid_on_fare'];
    if(json['country_code'] != null && json['country_code'] != ""){
      countryCode = json['country_code']??'BD';
    }else{
      countryCode = 'BD';
    }
    businessAddress = json['business_address'];
    businessContactPhone = json['business_contact_phone'];
    businessContactEmail = json['business_contact_email'];
    businessSupportPhone = json['business_support_phone'];
    businessSupportEmail = json['business_support_email'];
    baseUrl = json['base_url'];
    webSocketUrl = json['websocket_url'];
    webSocketPort = json['websocket_port'];
    webSocketKey = json['websocket_key'];
    imageBaseUrl = json['image_base_url'] != null
        ? ImageBaseUrl.fromJson(json['image_base_url'])
        : null;
    currencyDecimalPoint = json['currency_decimal_point'];
    currencyCode = json['currency_code'];
    currencySymbolPosition = json['currency_symbol_position'];
    aboutUs = json['about_us'] != null
        ? AboutUs.fromJson(json['about_us'])
        : null;
    privacyPolicy = json['privacy_policy'] != null
        ? AboutUs.fromJson(json['privacy_policy'])
        : null;
    termsAndConditions = json['terms_and_conditions'] != null
        ? AboutUs.fromJson(json['terms_and_conditions'])
        : null;
    legal = json['legal'] != null
        ? AboutUs.fromJson(json['legal'])
        : null;
    smsVerification = json['sms_verification'];
    emailVerification = json['email_verification'];
    mapApiKey = json['map_api_key'];
    paginationLimit = json['pagination_limit'];
    facebookLogin = json['facebook_login'].toString();
    googleLogin = json['google_login'].toString();
    isDemo = json['is_demo'];
    levelStatus = json['level_status'];
    verification = '${json['verification']}'.contains('true');
    conversionStatus = json['conversion_status']??true;
    if(json['conversion_rate'] != null){
      conversionRate = json['conversion_rate'];
    }else{
      conversionRate = 0;
    }
    otpResendTime = int.parse(json['otp_resend_time'].toString());
    selfRegistration = json['self_registration'];
    currencySymbol = json['currency_symbol'];
    reviewStatus = json['review_status'];
    parcelReturnTime = json['return_time_for_driver'];
    parcelReturnTimeType = json['return_time_type_for_driver'];
    parcelReturnTimeFeeStatus = json['parcel_return_time_fee_status'] ?? false;
    parcelReturnFeeTimeExceed = double.parse(json['return_fee_for_driver_time_exceed'].toString());
    maintenanceMode = json['maintenance_mode'] != null
        ? MaintenanceMode.fromJson(json['maintenance_mode'])
        : null;
    if(json['driver_completion_radius'] != null){
      try{
        completionRadius = json['driver_completion_radius'].toDouble();
      }catch(e){
        completionRadius = double.parse(json['driver_completion_radius'].toString());
      }
    }
    referralEarningStatus = json['referral_earning_status'];
    androidAppMinimumVersion = json['app_minimum_version_for_android'].toDouble();
    androidAppUrl = json['app_url_for_android'];
    iosAppMinimumVersion = json['app_minimum_version_for_ios'].toDouble();
    iosAppUrl = json['app_url_for_ios'];
    isFirebaseOtpVerification = json['firebase_otp_verification'];
    isSmsGateway = json['sms_gateway'];
    chattingSetupStatus = json['chatting_setup_status'];
    driverQuestionAnswerStatus = json['driver_question_answer_status'];
    websocketScheme = json['websocket_scheme'];
    refundPolicy = json['about_us'] != null
        ? AboutUs.fromJson(json['about_us'])
        : null;

  }

}



class ImageBaseUrl {
  String? profileImageCustomer;
  String? profileImageAdmin;
  String? banner;
  String? vehicleCategory;
  String? vehicleModel;
  String? vehicleBrand;
  String? profileImage;
  String? identityImage;
  String? documents;
  String? pages;
  String? conversation;

  ImageBaseUrl(
      {this.profileImageCustomer,
        this.banner,
        this.vehicleCategory,
        this.vehicleModel,
        this.vehicleBrand,
        this.profileImage,
        this.identityImage,
        this.documents,
        this.pages,
        this.conversation,
        this.profileImageAdmin
      });

  ImageBaseUrl.fromJson(Map<String, dynamic> json) {
    profileImageCustomer = json['profile_image_customer'];
    profileImageAdmin = json['profile_image_admin'];
    banner = json['banner'];
    vehicleCategory = json['vehicle_category'];
    vehicleModel = json['vehicle_model'];
    vehicleBrand = json['vehicle_brand'];
    profileImage = json['profile_image'];
    identityImage = json['identity_image'];
    documents = json['documents'];
    pages = json['pages'];
    conversation = json['conversation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profile_image_customer'] = profileImageCustomer;
    data['banner'] = banner;
    data['vehicle_category'] = vehicleCategory;
    data['vehicle_model'] = vehicleModel;
    data['vehicle_brand'] = vehicleBrand;
    data['profile_image'] = profileImage;
    data['identity_image'] = identityImage;
    data['documents'] = documents;
    data['pages'] = pages;
    return data;
  }
}
class AboutUs {
  String? image;
  String? name;
  String? shortDescription;
  String? longDescription;

  AboutUs({this.image, this.name, this.shortDescription, this.longDescription});

  AboutUs.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    shortDescription = json['short_description'];
    longDescription = json['long_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['short_description'] = shortDescription;
    data['long_description'] = longDescription;
    return data;
  }
}

class MaintenanceMode {
  int? maintenanceStatus;
  SelectedMaintenanceSystem? selectedMaintenanceSystem;
  MaintenanceMessages? maintenanceMessages;
  MaintenanceTypeAndDuration? maintenanceTypeAndDuration;

  MaintenanceMode(
      { maintenanceStatus,
         selectedMaintenanceSystem,
         maintenanceMessages,  maintenanceTypeAndDuration});

  MaintenanceMode.fromJson(Map<String, dynamic> json) {
    maintenanceStatus = json['maintenance_status'];
    selectedMaintenanceSystem = json['selected_maintenance_system'] != null
        ? SelectedMaintenanceSystem.fromJson(
        json['selected_maintenance_system'])
        : null;
    maintenanceMessages = json['maintenance_messages'] != null
        ? MaintenanceMessages.fromJson(json['maintenance_messages'])
        : null;

    maintenanceTypeAndDuration = json['maintenance_type_and_duration'] != null
        ? MaintenanceTypeAndDuration.fromJson(
        json['maintenance_type_and_duration'])
        : null;
  }

}

class SelectedMaintenanceSystem {
  int? userApp;
  int? driverApp;

  SelectedMaintenanceSystem(
      { this.userApp, this.driverApp});

  SelectedMaintenanceSystem.fromJson(Map<String, dynamic> json) {
    userApp = json['user_app'];
    driverApp = json['driver_app'];
  }

}

class MaintenanceMessages {
  int? businessNumber;
  int? businessEmail;
  String? maintenanceMessage;
  String? messageBody;

  MaintenanceMessages(
      {this.businessNumber,
        this.businessEmail,
        this.maintenanceMessage,
        this.messageBody});

  MaintenanceMessages.fromJson(Map<String, dynamic> json) {
    businessNumber = json['business_number'];
    businessEmail = json['business_email'];
    maintenanceMessage = json['maintenance_message'];
    messageBody = json['message_body'];
  }

}

class MaintenanceTypeAndDuration {
  String? maintenanceDuration;
  String? startDate;
  String? endDate;

  MaintenanceTypeAndDuration(
      {String? maintenanceDuration, String? startDate, String? endDate}) {
    if (maintenanceDuration != null) {
       maintenanceDuration = maintenanceDuration;
    }
    if (startDate != null) {
       startDate = startDate;
    }
    if (endDate != null) {
       endDate = endDate;
    }
  }

  MaintenanceTypeAndDuration.fromJson(Map<String, dynamic> json) {
    maintenanceDuration = json['maintenance_duration'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

}