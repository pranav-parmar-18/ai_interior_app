part of 'create_user_bloc.dart';

abstract class CreateUserState extends Equatable {
  CreateUserState();

  @override
  List<Object> get props => [];
}

class CreateUserInitialState extends CreateUserState {}

class CreateUserLoadingState extends CreateUserState {
  CreateUserLoadingState();
}

class CreateUserSuccessState extends CreateUserState {
  final CommonModelResponse? login;
  final String message;

  CreateUserSuccessState({
    required this.login,
    required this.message,
  });
}

class CreateUserFailureState extends CreateUserState {
  final String message;

  CreateUserFailureState({
    required this.message,
  });
}

class CreateUserExceptionState extends CreateUserState {
  final String message;

  CreateUserExceptionState({
    required this.message,
  });
}
