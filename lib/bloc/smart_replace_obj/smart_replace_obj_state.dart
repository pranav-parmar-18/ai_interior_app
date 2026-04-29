part of 'smart_replace_obj_bloc.dart';

abstract class SmartReplaceObjState extends Equatable {
  SmartReplaceObjState();

  @override
  List<Object> get props => [];
}

class SmartReplaceObjInitialState extends SmartReplaceObjState {}

class SmartReplaceObjLoadingState extends SmartReplaceObjState {
  SmartReplaceObjLoadingState();
}

class SmartReplaceObjSuccessState extends SmartReplaceObjState {
  final CommonModelResponse? login;
  final String message;

  SmartReplaceObjSuccessState({
    required this.login,
    required this.message,
  });
}

class SmartReplaceObjFailureState extends SmartReplaceObjState {
  final String message;

  SmartReplaceObjFailureState({
    required this.message,
  });
}

class SmartReplaceObjExceptionState extends SmartReplaceObjState {
  final String message;

  SmartReplaceObjExceptionState({
    required this.message,
  });
}
