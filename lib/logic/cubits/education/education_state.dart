import 'package:equatable/equatable.dart';
import '../../../data/models/education_article_model.dart';

abstract class EducationState extends Equatable {
  const EducationState();

  @override
  List<Object?> get props => [];
}

class EducationInitial extends EducationState {}

class EducationLoading extends EducationState {}

class EducationArticlesLoaded extends EducationState {
  final List<EducationArticleModel> articles;
  final String? categoryFilter;
  final String? searchQuery;

  const EducationArticlesLoaded({
    required this.articles,
    this.categoryFilter,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [articles, categoryFilter, searchQuery];
}

class EducationArticleDetailLoaded extends EducationState {
  final EducationArticleModel article;

  const EducationArticleDetailLoaded(this.article);

  @override
  List<Object?> get props => [article];
}

class EducationError extends EducationState {
  final String message;

  const EducationError(this.message);

  @override
  List<Object?> get props => [message];
}
