

import 'package:ride_sharing_user_app/features/review/domain/repositories/review_repository_interface.dart';
import 'package:ride_sharing_user_app/features/review/domain/services/review_service_interface.dart';

class ReviewService implements ReviewServiceInterface{
  final ReviewRepositoryInterface reviewRepositoryInterface;
  ReviewService({required this.reviewRepositoryInterface});

  @override
  Future getReviewList(int offset) {
    return reviewRepositoryInterface.getList(offset: offset);
  }

  @override
  Future getSavedReviewList(int offset, int isSaved) {
    return reviewRepositoryInterface.getSavedReviewList(offset, isSaved);
  }

  @override
  Future savedReview(String id) {
    return reviewRepositoryInterface.savedReview(id);
  }

  @override
  Future submitReview(String id, int ratting, String comment) {
    return reviewRepositoryInterface.submitReview(id, ratting, comment);
  }

}