import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../data/repositories/review_repo.dart'; // TODO: Update to new repo structure
import 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository _reviewRepository;

  ReviewCubit(this._reviewRepository) : super(ReviewInitial());

  Future<void> loadReviews({
    int? employerId,
    int? studentId,
  }) async {
    try {
      emit(ReviewLoading());
      final reviews = await _reviewRepository.getReviews(
        employerId: employerId,
        studentId: studentId,
      );

      // Calculate average rating
      double averageRating = 0.0;
      if (reviews.isNotEmpty) {
        final totalRating = reviews.fold<double>(
          0.0,
          (sum, review) => sum + review.rating,
        );
        averageRating = totalRating / reviews.length;
      }

      // Calculate rating distribution
      final Map<int, int> ratingDistribution = {
        5: 0,
        4: 0,
        3: 0,
        2: 0,
        1: 0,
      };
      for (var review in reviews) {
        ratingDistribution[review.rating.round()] =
            (ratingDistribution[review.rating.round()] ?? 0) + 1;
      }

      emit(ReviewsLoaded(
        reviews: reviews,
        averageRating: averageRating,
        ratingDistribution: ratingDistribution,
      ));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> submitReview({
    required int revieweeId,
    required String revieweeType,
    required double rating,
    required String comment,
    int? jobId,
  }) async {
    try {
      emit(ReviewLoading());
      final review = await _reviewRepository.submitReview(
        revieweeId: revieweeId,
        revieweeType: revieweeType,
        rating: rating,
        comment: comment,
        jobId: jobId,
      );
      emit(ReviewSubmitted(review));
      // Reload reviews
      if (revieweeType == 'employer') {
        await loadReviews(employerId: revieweeId);
      } else {
        await loadReviews(studentId: revieweeId);
      }
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> updateReview({
    required int reviewId,
    double? rating,
    String? comment,
  }) async {
    try {
      emit(ReviewLoading());
      final review = await _reviewRepository.updateReview(
        reviewId: reviewId,
        rating: rating,
        comment: comment,
      );
      emit(ReviewUpdated(review));
      // Reload reviews - need to know the reviewee type and id
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> deleteReview(int reviewId) async {
    try {
      await _reviewRepository.deleteReview(reviewId);
      emit(ReviewDeleted(reviewId));
      // Note: Reload might be needed but we don't have context here
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> refreshReviews({int? employerId, int? studentId}) async {
    await loadReviews(employerId: employerId, studentId: studentId);
  }
}
