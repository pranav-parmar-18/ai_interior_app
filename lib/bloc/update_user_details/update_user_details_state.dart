part of 'update_user_details_bloc.dart';

abstract class UpdateUserDetailsState extends Equatable {
  UpdateUserDetailsState();

  @override
  List<Object> get props => [];
}

class UpdateUserDetailsInitialState extends UpdateUserDetailsState {}

class UpdateUserDetailsLoadingState extends UpdateUserDetailsState {
  UpdateUserDetailsLoadingState();
}

class UpdateUserDetailsSuccessState extends UpdateUserDetailsState {
  final CommonModelResponse? categoryModalResponse;
  final String message;

  UpdateUserDetailsSuccessState({
    required this.categoryModalResponse,
    required this.message,
  });
}

class UpdateUserDetailsFailureState extends UpdateUserDetailsState {
  final String message;

  UpdateUserDetailsFailureState({
    required this.message,
  });
}

class UpdateUserDetailsExceptionState extends UpdateUserDetailsState {
  final String message;

  UpdateUserDetailsExceptionState({
    required this.message,
  });
}
