import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/date_picker_widget.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/text_field_title_widget.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/profile/domain/models/categoty_model.dart';
import 'package:ride_sharing_user_app/features/profile/domain/models/profile_model.dart';
import 'package:ride_sharing_user_app/features/profile/domain/models/vehicle_body.dart';
import 'package:ride_sharing_user_app/features/profile/domain/models/vehicle_brand_model.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class VehicleAddScreen extends StatefulWidget {
  final Vehicle? vehicleInfo;
  const VehicleAddScreen({super.key,this.vehicleInfo});

  @override
  State<VehicleAddScreen> createState() => _VehicleAddScreenState();
}

class _VehicleAddScreenState extends State<VehicleAddScreen> {
  TextEditingController licencePlateNumberController = TextEditingController();
  TextEditingController licenceExpiryDateController = TextEditingController();
  TextEditingController vinNumberController = TextEditingController();
  TextEditingController transmissionController = TextEditingController();
  TextEditingController parcelWeightCapacity = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  FocusNode licencePlateFocus = FocusNode();
  FocusNode licenceExpiryFocus = FocusNode();
  FocusNode vinNumberFocus = FocusNode();
  FocusNode transmissionFocus = FocusNode();
  FocusNode parcelWeightFocus = FocusNode();

  PlatformFile? fileNamed;
  File? file;
  int? fileSize;



  @override
  void initState() {
    Get.find<ProfileController>().getVehicleBrandList(1);
    Get.find<ProfileController>().getCategoryList(1);
    Get.find<ProfileController>().clearVehicleData();
    if(widget.vehicleInfo != null){
      licencePlateNumberController.text = widget.vehicleInfo!.licencePlateNumber!;
      Get.find<ProfileController>().setStartDate(DateTime.parse(widget.vehicleInfo!.licenceExpireDate!));
      Get.find<ProfileController>().setFuelType(widget.vehicleInfo!.fuelType!, false);
      parcelWeightCapacity.text = (widget.vehicleInfo?.parcelWeightCapacity ?? '').toString();
    }
    super.initState();
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 50,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: widget.vehicleInfo == null ? 'vehicle_setup'.tr : 'update_vehicle'.tr,
        regularAppbar: true,
      ),
      body: GetBuilder<ProfileController>(builder: (profileController) {
        return SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if(widget.vehicleInfo == null)
              Padding(
                padding: const EdgeInsets.only(
                  top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault,
                ),
                child: Text('vehicle_information'.tr, style: textMedium.copyWith(
                  color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge,
                )),
              ),

              if(widget.vehicleInfo == null)
              Text('add_vehicle_details'.tr, style: textRegular.copyWith(color: Theme.of(context).hintColor)),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  TextFieldTitleWidget(title: 'vehicle_brand'.tr),

                  if(profileController.brandList.isNotEmpty)
                    Container(
                      width: Get.width * 0.45, padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeOverLarge),
                      ),
                      child: DropdownButton(
                        items: profileController.brandList.map((item) {
                          return  DropdownMenuItem<Brand>(
                            value: item,
                            child: Text(item.name!.tr,style: textRegular.copyWith(
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                            )),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          profileController.setBrandIndex(newVal!, true);
                        },
                        isExpanded: true,
                        underline: const SizedBox(),
                        value: profileController.selectedBrand ?? Brand(id: 'abc', name: 'Select Brand Model'),
                      ),
                    ),
                ]),

                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if(profileController.modelList.isNotEmpty)
                    TextFieldTitleWidget(title: 'vehicle_model'.tr),

                  if(profileController.modelList.isNotEmpty)
                    Container(
                      width: Get.width * 0.45, padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeOverLarge),
                      ),
                      child: DropdownButton(items: profileController.modelList.map((item) {
                        return  DropdownMenuItem<VehicleModels>(
                          value: item,
                          child:  Text(item.name!.tr,style: textRegular.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          )),
                        );
                      }).toList(),
                        onChanged: (newVal) {
                          profileController.setModelIndex(newVal!, true);
                        },
                        isExpanded: true,
                        underline: const SizedBox(),
                        value: profileController.selectedModel,
                      ),
                    ),
                ]),
              ]),

              TextFieldTitleWidget(title: 'vehicle_category'.tr),
              if(profileController.categoryList.isNotEmpty)
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeOverLarge),
                  ),
                  child: DropdownButton(
                    items: profileController.categoryList.map((item) {
                      return  DropdownMenuItem<Category>(
                        value: item,
                        child:  Text(item.name!.tr,style: textRegular.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        )),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      profileController.setCategoryIndex(newVal!, true);
                    },
                    isExpanded: true,
                    underline: const SizedBox(),
                    value: profileController.selectedCategory,
                  ),
                ),

              TextFieldTitleWidget(title: 'vehicle_color'.tr),

              TextField(
                controller: parcelWeightCapacity,
                focusNode: parcelWeightFocus,
                style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyMedium?.color),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                cursorColor: Theme.of(context).primaryColor,
                textCapitalization: TextCapitalization.words,
                autofocus: false,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:  BorderSide(width: 0.5,
                        color: Theme.of(context).hintColor.withOpacity(0.5)),
                  ),

                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:  BorderSide(width: 0.5, color: Theme.of(context).hintColor.withOpacity(0.5)),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:  BorderSide(width: 0.5, color: Theme.of(context).primaryColor),
                  ),
                  hintText: 'enter_color'.tr,
                  fillColor: Theme.of(context).cardColor,
                  hintStyle: textRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
                  ),
                  filled: true,

                ),
                onSubmitted: (text) => FocusScope.of(context).requestFocus(licencePlateFocus),
              ),

              TextFieldTitleWidget(title: 'licence_plate_number'.tr),

              TextField(
                controller: licencePlateNumberController,
                focusNode: licencePlateFocus,
                style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyMedium?.color),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                cursorColor: Theme.of(context).primaryColor,
                textCapitalization: TextCapitalization.words,
                autofocus: false,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:  BorderSide(width: 0.5,
                        color: Theme.of(context).hintColor.withOpacity(0.5)),
                  ),

                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:  BorderSide(width: 0.5, color: Theme.of(context).hintColor.withOpacity(0.5)),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:  BorderSide(width: 0.5, color: Theme.of(context).primaryColor),
                  ),
                  hintText: 'EX: DB-3212',
                  fillColor: Theme.of(context).cardColor,
                  hintStyle: textRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
                  ),
                  filled: true,
                ),
                onSubmitted: (text) => FocusScope.of(context).requestFocus(licenceExpiryFocus),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              DatePickerWidget(
                title: 'licence_expire_date'.tr,
                text: profileController.startDate != null ?
                profileController.dateFormat.format(profileController.startDate!).toString() : 'dd-mm-yyyy',
                image: Images.calender,
                requiredField: true,
                selectDate: () => profileController.selectDate("start", context),
              ),

              TextFieldTitleWidget(title: 'fuel_type'.tr,),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge),
                ),
                child: DropdownButton<String>(
                  value: profileController.selectedFuelType,
                  items: profileController.fuelType.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.tr,style: textRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      )),
                    );
                  }).toList(),
                  onChanged: (value) {
                    profileController.setFuelType(value!, true);
                  },
                  isExpanded: true,
                  underline: const SizedBox(),
                ),
              ),

              if(widget.vehicleInfo == null)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, Dimensions.paddingSizeDefault, 0, 0),
                child: DottedBorder(
                  dashPattern: const [4,5],
                  borderType: BorderType.RRect,
                  color: Theme.of(context).hintColor,
                  radius: const Radius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                    ),
                    child: InkWell(
                      onTap: ()async{
                        bool res = await profileController.pickOtherFile(false);
                        if(res){
                          _scrollDown();
                        }
                      },
                      child: Builder(builder: (context) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center, children: [
                          SizedBox(width: 50,child: Image.asset(Images.upload)),

                          Text('upload_documents'.tr),

                          profileController.selectedFileForImport !=null ?
                          Text(fileNamed != null? fileNamed!.name:'',maxLines: 2,overflow: TextOverflow.ellipsis) :
                          Text('upload_file'.tr, style: textRegular.copyWith()),
                        ],
                        );
                      }),
                    ),
                  ),
                ),
              ),

              if(profileController.listOfDocuments.isNotEmpty)
                ListView.builder(
                  itemCount: profileController.listOfDocuments.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: ()=> profileController.removeFile(index),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, Dimensions.paddingSizeDefault, 0, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge),
                            color: Theme.of(context).cardColor,
                            boxShadow: [BoxShadow(
                              color: Theme.of(context).hintColor.withOpacity(.25),
                              spreadRadius: 1, blurRadius: 1, offset: const Offset(0,1),
                            )],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            child: Row(children: [
                              SizedBox(width: Dimensions.iconSizeMedium,child: Image.asset(Images.clip)),

                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Expanded(child: Text(
                                profileController.listOfDocuments[index].files.first.name,
                                maxLines: 1,overflow: TextOverflow.ellipsis,
                              )),
                              const Icon(Icons.clear, color: Colors.red,size: 20)
                            ]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              profileController.creating ?
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0),
              ]) :
              ButtonWidget(
                radius: Dimensions.radiusExtraLarge,
                buttonText: widget.vehicleInfo == null ? 'save'.tr : 'update'.tr,
                onPressed: (){
                  String brandId = profileController.selectedBrand!.id!;
                  String modelId = profileController.selectedModel.id!;
                  String categoryId = profileController.selectedCategory.id!;
                  String licencePlateNumber = licencePlateNumberController.text.trim();
                  String expireDate = profileController.dateFormat.format(profileController.startDate??DateTime.now()).toString();
                  String vinNumber = vinNumberController.text.trim();
                  String transmission = transmissionController.text.trim();
                  String fuelType = profileController.selectedFuelType;
                  if(profileController.selectedBrand!.id == 'abc'){
                    showCustomSnackBar('select_vehicle_brand'.tr);
                  }else if(profileController.selectedModel.id == 'abc'){
                    showCustomSnackBar('select_vehicle_model'.tr);
                  }else if(profileController.selectedCategory.id == 'abc'){
                    showCustomSnackBar('select_vehicle_category'.tr);
                  }
                  else if(licencePlateNumber.isEmpty){
                    showCustomSnackBar('licence_plate_number_is_required'.tr);
                  }else if(expireDate.isEmpty){
                    showCustomSnackBar('expire_date_is_required'.tr);
                  }else if(fuelType == 'Select Fuel type'){
                    showCustomSnackBar('fuel_type_is_required'.tr);
                  }else{
                    VehicleBody body = VehicleBody(
                        brandId: brandId,
                        modelId: modelId,
                        categoryId: categoryId,
                        licencePlateNumber: licencePlateNumber,
                        licenceExpireDate: expireDate,
                        vinNumber: vinNumber,
                        transmission: transmission,
                        fuelType: fuelType,
                        driverId: profileController.profileInfo!.id??"123456789",
                        ownership: 'driver',
                        parcelCapacityWeight: parcelWeightCapacity.text.trim()
                    );
                    if(widget.vehicleInfo == null){
                      profileController.addNewVehicle(body);
                    }else{
                      profileController.updateVehicle(body,Get.find<ProfileController>().driverId).then((onValue){
                        if(onValue.statusCode == 200){
                          Get.back();
                        }
                      });
                    }
                  }
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            ]),
          ),
        );
      }),
    );
  }
}
