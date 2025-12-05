import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/job_repo.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final JobRepository _jobRepository;
  final List<String> _recentSearches = [];

  SearchCubit(this._jobRepository) : super(SearchInitial());

  Future<void> search({
    required String query,
    Map<String, dynamic>? filters,
  }) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    try {
      emit(SearchLoading());

      // Add to recent searches
      if (!_recentSearches.contains(query)) {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 10) {
          _recentSearches.removeLast();
        }
      }

      final results = await _jobRepository.searchJobs(
        query: query,
        filters: filters ?? {},
      );

      if (results.isEmpty) {
        emit(SearchEmpty(query));
      } else {
        emit(SearchResultsLoaded(
          results: results,
          query: query,
          filters: filters ?? {},
          recentSearches: List.from(_recentSearches),
        ));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> applyFilters({
    required String query,
    required Map<String, dynamic> filters,
  }) async {
    await search(query: query, filters: filters);
  }

  void clearSearch() {
    emit(SearchInitial());
  }

  void clearRecentSearches() {
    _recentSearches.clear();
    final currentState = state;
    if (currentState is SearchResultsLoaded) {
      emit(SearchResultsLoaded(
        results: currentState.results,
        query: currentState.query,
        filters: currentState.filters,
        recentSearches: [],
      ));
    }
  }

  List<String> getRecentSearches() {
    return List.from(_recentSearches);
  }
}
