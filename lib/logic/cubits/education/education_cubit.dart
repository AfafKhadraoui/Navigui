import 'package:flutter_bloc/flutter_bloc.dart';
import 'education_state.dart';

class EducationCubit extends Cubit<EducationState> {
  // Note: You'll need to create an EducationRepository
  // final EducationRepository _educationRepository;

  EducationCubit() : super(EducationInitial());

  Future<void> loadArticles({
    String? categoryFilter,
    String? searchQuery,
  }) async {
    try {
      emit(EducationLoading());
      // TODO: Replace with actual repository call
      // final articles = await _educationRepository.getArticles(
      //   category: categoryFilter,
      //   searchQuery: searchQuery,
      // );

      // Mock data for now
      emit(EducationArticlesLoaded(
        articles: [],
        categoryFilter: categoryFilter,
        searchQuery: searchQuery,
      ));
    } catch (e) {
      emit(EducationError(e.toString()));
    }
  }

  Future<void> loadArticleDetail(int articleId) async {
    try {
      emit(EducationLoading());
      // TODO: Replace with actual repository call
      // final article = await _educationRepository.getArticleById(articleId);
      // emit(EducationArticleDetailLoaded(article));
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
}
