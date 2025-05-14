import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/review/domain/services/review_service_interface.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/review/domain/models/review_model.dart';


class ReviewController extends GetxController implements GetxService{
  final ReviewServiceInterface reviewServiceInterface;

  ReviewController({required this.reviewServiceInterface});

  int _reviewTypeIndex = 0;
  int get reviewTypeIndex => _reviewTypeIndex;
  bool isLoading = false;
  List<String> reviewTypeList =['reviews', 'saved'];


  void setReviewIndex(int index){
    _reviewTypeIndex = index;
      getReviewList(1);

    update();
  }

  ReviewModel? reviewModel;

  Future<void> getReviewList([int? offset]) async {
    isLoading = true;
    if(offset ==1){
      reviewModel = null;
      update();
    }
    Response response;
    if(_reviewTypeIndex == 1){
      response = await reviewServiceInterface.getSavedReviewList(offset!, 1);
    }else{
       response = await reviewServiceInterface.getReviewList(offset!);
    }
    if (response.statusCode == 200) {
      if(offset == 1){
        reviewModel = null;
        reviewModel = ReviewModel.fromJson(response.body);
      }else{
        reviewModel!.data!.addAll(ReviewModel.fromJson(response.body).data!);
        reviewModel!.offset = ReviewModel.fromJson(response.body).offset;
        reviewModel!.totalSize = ReviewModel.fromJson(response.body).totalSize;
      }
    } else {
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
  }


  Future<Response> saveReview(String id, int index) async {
    isLoading = true;
    reviewModel!.data![index].isLoading = true;
    update();
    Response response = await reviewServiceInterface.savedReview(id);
    if (response.statusCode == 200 ) {
      reviewModel = null;
      await getReviewList(1);
      if(_reviewTypeIndex == 0){
        if(reviewModel!.data![index].isSaved!){
          showCustomSnackBar('review_saved_successfully'.tr, isError: false);
        }else{
          showCustomSnackBar('review_removed_successfully_from_saved_list'.tr, isError: false);
        }
      }else{
        showCustomSnackBar('review_removed_successfully_from_saved_list'.tr, isError: false);
      }
     // reviewModel!.data![index].isSaved = !reviewModel!.data![index].isSaved!;

      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


  Future<Response> submitReview(String id, int ratting, String comment) async {
    isLoading = true;
    update();
    Response response = await reviewServiceInterface.submitReview(id, ratting, comment);
    if (response.statusCode == 200 ) {
      Get.back();
      showCustomSnackBar('review_submitted_successfully'.tr, isError: false);
      Get.offAll(()=> const DashboardScreen());
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


}