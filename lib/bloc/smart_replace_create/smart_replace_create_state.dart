part of 'smart_replace_create_bloc.dart';

abstract class SmartReplaceCreateState extends Equatable {
  SmartReplaceCreateState();

  @override
  List<Object> get props => [];
}

class SmartReplaceCreateInitialState extends SmartReplaceCreateState {}

class SmartReplaceCreateLoadingState extends SmartReplaceCreateState {
  SmartReplaceCreateLoadingState();
}

class SmartReplaceCreateSuccessState extends SmartReplaceCreateState {
  final CommonModelResponse? login;
  final String message;

  SmartReplaceCreateSuccessState({
    required this.login,
    required this.message,
  });
}

class SmartReplaceCreateFailureState extends SmartReplaceCreateState {
  final String message;

  SmartReplaceCreateFailureState({
    required this.message,
  });
}

class SmartReplaceCreateExceptionState extends SmartReplaceCreateState {
  final String message;

  SmartReplaceCreateExceptionState({
    required this.message,
  });
}
