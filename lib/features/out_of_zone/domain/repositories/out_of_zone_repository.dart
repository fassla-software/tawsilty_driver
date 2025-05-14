
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/domain/repositories/out_of_zone_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class OutOfZoneRepository implements OutOfZoneRepositoryInterface{
  final ApiClient apiClient;
  OutOfZoneRepository({required this.apiClient});




  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Response> getZoneList() async{
    return await apiClient.getData(AppConstants.getZoneList);
  }

}