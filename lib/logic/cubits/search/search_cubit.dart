import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../data/repositories/job_repo.dart'; // TODO: Update to new repo structure
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  // TODO: Update to new repo structure
  // final JobRepository _jobRepository;
  // final List<String> _recentSearches = [];

  SearchCubit() : super(SearchInitial());

  // TODO: Implement with new repository structure
  // Future<void> search({
  //   required String query,
  //   Map<String, dynamic>? filters,
  // }) async {
  //   if (query.trim().isEmpty) {
  //     emit(SearchInitial());
  //     return;
  //   }

  //   try {
  //     emit(SearchLoading());

  //     // Add to recent searches
  //     if (!_recentSearches.contains(query)) {
  //       _recentSearches.insert(0, query);
  //       if (_recentSearches.length > 10) {
  //         _recentSearches.removeLast();
  //       }
  //     }

  //     final results = await _jobRepository.searchJobs(
  //       query: query,
  //       filters: filters ?? {},
  //     );

  //     if (results.isEmpty) {
  //       emit(SearchEmpty(query));
  //     } else {
  //       emit(SearchResultsLoaded(
  //         results: results,
  //         query: query,
  //         filters: filters ?? {},
  //         recentSearches: List.from(_recentSearches),
  //       ));
  //     }
  //   } catch (e) {
  //     emit(SearchError(e.toString()));
  //   }
  // }

  // TODO: Implement with new repository structure
  // Future<void> applyFilters({
  //   required String query,
  //   required Map<String, dynamic> filters,
  // }) async {
  //   await search(query: query, filters: filters);
  // }

  // TODO: Implement with new repository structure
  // void clearSearch() {
  //   emit(SearchInitial());
  // }

  // TODO: Implement with new repository structure
  // void clearRecentSearches() {
  //   _recentSearches.clear();
  //   final currentState = state;
  //   if (currentState is SearchResultsLoaded) {
  //     emit(SearchResultsLoaded(
  //       results: currentState.results,
  //       query: currentState.query,
  //       filters: currentState.filters,
  //       recentSearches: [],
  //     ));
  //   }
  // }

  // TODO: Implement with new repository structure
  // List<String> getRecentSearches() {
  //   return List.from(_recentSearches);
  // }
}
