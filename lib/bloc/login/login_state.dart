part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {
  LoginLoadingState();
}

class LoginSuccessState extends LoginState {
  final LoginModelResponse? login;
  final String message;

  LoginSuccessState({
    required this.login,
    required this.message,
  });
}

class LoginFailureState extends LoginState {
  final String message;

  LoginFailureState({
    required this.message,
  });
}

class LoginExceptionState extends LoginState {
  final String message;

  LoginExceptionState({
    required this.message,
  });
}
