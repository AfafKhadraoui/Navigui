import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/education/education_repo_abstract.dart';
import 'education_state.dart';

class EducationCubit extends Cubit<EducationState> {
  final EducationRepositoryBase _educationRepository;

  EducationCubit(this._educationRepository) : super(EducationInitial());

  Future<void> loadArticles({
    String? categoryFilter,
    String? searchQuery,
  }) async {
    try {
      emit(EducationLoading());

      final result = await _educationRepository.getArticles(
        categoryId: categoryFilter,
        searchQuery: searchQuery,
      );

      if (result.isSuccess) {
        emit(EducationArticlesLoaded(
          articles: result.data!,
          categoryFilter: categoryFilter,
          searchQuery: searchQuery,
        ));
      } else {
        emit(EducationError(result.error ?? 'Failed to load articles'));
      }
    } catch (e) {
      emit(EducationError(e.toString()));
    }
  }

  Future<void> loadArticleDetail(String articleId) async {
    try {
      emit(EducationLoading());

      final result = await _educationRepository.getArticleById(articleId);

      if (result.isSuccess) {
        emit(EducationArticleDetailLoaded(result.data!));

        // Increment view count in background (don't wait)
        _educationRepository.incrementViewCount(articleId);
      } else {
        emit(EducationError(result.error ?? 'Failed to load article'));
      }
    } catch (e) {
      emit(EducationError(e.toString()));
    }
  }

  Future<void> searchArticles(String query) async {
    final currentState = state;
    if (currentState is EducationArticlesLoaded) {
      await loadArticles(
        searchQuery: query,
        categoryFilter: currentState.categoryFilter,
      );
    } else {
      await loadArticles(searchQuery: query);
    }
  }

  Future<void> filterByCategory(String category) async {
    final currentState = state;
    if (currentState is EducationArticlesLoaded) {
      await loadArticles(
        categoryFilter: category,
        searchQuery: currentState.searchQuery,
      );
    } else {
      await loadArticles(categoryFilter: category);
    }
  }

  Future<void> refreshArticles() async {
    final currentState = state;
    if (currentState is EducationArticlesLoaded) {
      await loadArticles(
        categoryFilter: currentState.categoryFilter,
        searchQuery: currentState.searchQuery,
      );
    } else {
      await loadArticles();
    }
  }

  Future<void> loadPopularArticles({int limit = 10}) async {
    try {
      emit(EducationLoading());

      final result =
          await _educationRepository.getPopularArticles(limit: limit);

      if (result.isSuccess) {
        emit(EducationArticlesLoaded(
          articles: result.data!,
          categoryFilter: null,
          searchQuery: null,
        ));
      } else {
        emit(EducationError(result.error ?? 'Failed to load popular articles'));
      }
    } catch (e) {
      emit(EducationError(e.toString()));
    }
  }

  Future<void> loadRecentArticles({int limit = 10}) async {
    try {
      emit(EducationLoading());

      final result = await _educationRepository.getRecentArticles(limit: limit);

      if (result.isSuccess) {
        emit(EducationArticlesLoaded(
          articles: result.data!,
          categoryFilter: null,
          searchQuery: null,
        ));
      } else {
        emit(EducationError(result.error ?? 'Failed to load recent articles'));
      }
    } catch (e) {
      emit(EducationError(e.toString()));
    }
  }

  Future<void> incrementLikesCount(String articleId) async {
    try {
      await _educationRepository.incrementLikesCount(articleId);
    } catch (e) {
      // Silent fail - don't interrupt user experience
      print('Error incrementing likes count: $e');
    }
  }

  Future<void> decrementLikesCount(String articleId) async {
    try {
      await _educationRepository.decrementLikesCount(articleId);
    } catch (e) {
      // Silent fail - don't interrupt user experience
      print('Error decrementing likes count: $e');
    }
  }
}
