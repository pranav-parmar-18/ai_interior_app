part of 'recent_list_bloc.dart';

abstract class RecentListState extends Equatable {
  RecentListState();

  @override
  List<Object> get props => [];
}

class RecentListInitialState extends RecentListState {}

class RecentListLoadingState extends RecentListState {
  RecentListLoadingState();
}

class RecentListSuccessState extends RecentListState {
  final RecentListModelResponse? exploreSongResponse;
  final String message;

  RecentListSuccessState({
    required this.exploreSongResponse,
    required this.message,
  });
}

class RecentListFailureState extends RecentListState {
  final String message;

  RecentListFailureState({required this.message});
}

class RecentListExceptionState extends RecentListState {
  final String message;

  RecentListExceptionState({required this.message});
}
