

abstract class ReviewServiceInterface {
  Future<dynamic> getReviewList(int offset );
  Future<dynamic> getSavedReviewList(int offset, int isSaved );
  Future<dynamic> savedReview(String id );
  Future<dynamic> submitReview(String id, int ratting, String comment );
}