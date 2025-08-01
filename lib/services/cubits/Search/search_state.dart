part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

final class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {
  final List<LawyerModel> lawyers;
  SearchLoading(this.lawyers);
}

class SearchError extends SearchState{
  final String message;
  SearchError(this.message);
}
