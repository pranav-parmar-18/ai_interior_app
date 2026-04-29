part of 'partner_list_bloc.dart';

abstract class RecentSingleAPIState extends Equatable {
  RecentSingleAPIState();

  @override
  List<Object> get props => [];
}

class RecentSingleAPIInitialState extends RecentSingleAPIState {}

class RecentSingleAPILoadingState extends RecentSingleAPIState {
  RecentSingleAPILoadingState();
}

class RecentSingleAPISuccessState extends RecentSingleAPIState {
  final RecentSingleAPIResponse? exploreSongResponse;
  final String message;

  RecentSingleAPISuccessState({
    required this.exploreSongResponse,
    required this.message,
  });
}

class RecentSingleAPIFailureState extends RecentSingleAPIState {
  final String message;

  RecentSingleAPIFailureState({
    required this.message,
  });
}

class RecentSingleAPIExceptionState extends RecentSingleAPIState {
  final String message;

  RecentSingleAPIExceptionState({
    required this.message,
  });
}
