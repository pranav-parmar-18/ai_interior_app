part of 'explore_bloc.dart';

abstract class ExploreState extends Equatable {
  ExploreState();

  @override
  List<Object> get props => [];
}

class ExploreInitialState extends ExploreState {}

class ExploreLoadingState extends ExploreState {
  ExploreLoadingState();
}

class ExploreSuccessState extends ExploreState {
  final ExploreModelResponse? exploreSongResponse;
  final String message;

  ExploreSuccessState({
    required this.exploreSongResponse,
    required this.message,
  });
}

class ExploreFailureState extends ExploreState {
  final String message;

  ExploreFailureState({
    required this.message,
  });
}

class ExploreExceptionState extends ExploreState {
  final String message;

  ExploreExceptionState({
    required this.message,
  });
}
