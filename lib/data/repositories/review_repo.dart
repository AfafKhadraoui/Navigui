import '../models/review_model.dart';

/// Review/Rating data repository
/// Handles review and rating-related data operations
class ReviewRepository {
  Future<List<ReviewModel>> getReviews({
    int? employerId,
    int? studentId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockReviews();
  }

  Future<ReviewModel> submitReview({
    required int revieweeId,
    required String revieweeType,
    required double rating,
    required String comment,
    int? jobId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ReviewModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      reviewerId: '1',
      revieweeId: revieweeId.toString(),
      rating: rating,
      communicationRating: rating,
      paymentRating: rating,
      workEnvironmentRating: rating,
      overallExperienceRating: rating,
      qualityRating: rating,
      timeRespectRating: rating,
      comment: comment,
      createdAt: DateTime.now(),
      jobId: jobId?.toString(),
    );
  }

  Future<ReviewModel> updateReview({
    required int reviewId,
    double? rating,
    String? comment,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final reviews = _getMockReviews();
    return reviews.firstWhere((r) => r.id == reviewId.toString());
  }

  Future<void> deleteReview(int reviewId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  List<ReviewModel> _getMockReviews() {
    return [
      ReviewModel(
        id: '1',
        reviewerId: '1',
        revieweeId: '2',
        rating: 4.5,
        communicationRating: 4.5,
        paymentRating: 5.0,
        workEnvironmentRating: 4.0,
        overallExperienceRating: 4.5,
        qualityRating: 4.5,
        timeRespectRating: 4.5,
        comment: 'Great employer to work with!',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ReviewModel(
        id: '2',
        reviewerId: '2',
        revieweeId: '1',
        rating: 5.0,
        communicationRating: 5.0,
        paymentRating: 5.0,
        workEnvironmentRating: 5.0,
        overallExperienceRating: 5.0,
        qualityRating: 5.0,
        timeRespectRating: 5.0,
        comment: 'Excellent work and professional.',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
}
