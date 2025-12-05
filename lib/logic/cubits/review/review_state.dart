import 'package:equatable/equatable.dart';
import '../../../data/models/review_model.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewsLoaded extends ReviewState {
  final List<ReviewModel> reviews;
  final double averageRating;
  final Map<int, int> ratingDistribution;

  const ReviewsLoaded({
    required this.reviews,
    required this.averageRating,
    required this.ratingDistribution,
  });

  @override
  List<Object?> get props => [reviews, averageRating, ratingDistribution];
}

class ReviewSubmitted extends ReviewState {
  final ReviewModel review;

  const ReviewSubmitted(this.review);

  @override
  List<Object?> get props => [review];
}

class ReviewUpdated extends ReviewState {
  final ReviewModel review;

  const ReviewUpdated(this.review);

  @override
  List<Object?> get props => [review];
}

class ReviewDeleted extends ReviewState {
  final int reviewId;

  const ReviewDeleted(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class ReviewError extends ReviewState {
  final String message;

  const ReviewError(this.message);

  @override
  List<Object?> get props => [message];
}
