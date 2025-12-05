import 'package:equatable/equatable.dart';
import '../../../data/models/job_post.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchResultsLoaded extends SearchState {
  final List<JobPost> results;
  final String query;
  final Map<String, dynamic> filters;
  final List<String> recentSearches;

  const SearchResultsLoaded({
    required this.results,
    required this.query,
    required this.filters,
    required this.recentSearches,
  });

  @override
  List<Object?> get props => [results, query, filters, recentSearches];
}

class SearchEmpty extends SearchState {
  final String query;

  const SearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
