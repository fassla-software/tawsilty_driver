import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/review/domain/repositories/review_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class ReviewRepository implements ReviewRepositoryInterface{
  final ApiClient apiClient;

  ReviewRepository({required this.apiClient});


  @override
  Future<Response> getSavedReviewList(int offset, int isSaved ) async {
    return await apiClient.getData('${AppConstants.reviewList}$offset&is_saved=$isSaved');
  }

  @override
  Future<Response> savedReview(String id ) async {
    return await apiClient.postData('${AppConstants.saveReview}$id',{
      "_method" : 'put',
    });
  }

  @override
  Future<Response> submitReview(String id, int ratting, String comment ) async {
    return await apiClient.postData(AppConstants.submitReview,{
      "ride_request_id" : id,
      "rating" : ratting,
      "feedback" : comment
    });
  }

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
  Future getList({int? offset = 1}) async{
    return await apiClient.getData('${AppConstants.reviewList}$offset');
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }


}