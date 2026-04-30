part of 'get_user_details_bloc.dart';

abstract class GetUsersState extends Equatable {
  GetUsersState();

  @override
  List<Object> get props => [];
}

class GetUsersInitialState extends GetUsersState {}

class GetUsersLoadingState extends GetUsersState {
  GetUsersLoadingState();
}

class GetUsersSuccessState extends GetUsersState {
  final CommonModelResponse? user;
  final String message;

  GetUsersSuccessState({
    required this.user,
    required this.message,
  });
}

class GetUsersFailureState extends GetUsersState {
  final String message;

  GetUsersFailureState({
    required this.message,
  });
}

class GetUsersExceptionState extends GetUsersState {
  final String message;

  GetUsersExceptionState({
    required this.message,
  });
}
