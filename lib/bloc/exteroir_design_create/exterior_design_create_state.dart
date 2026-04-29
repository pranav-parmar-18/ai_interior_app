part of 'exterior_design_create_bloc.dart';

abstract class ExteriorDeignCreateState extends Equatable {
  ExteriorDeignCreateState();

  @override
  List<Object> get props => [];
}

class ExteriorDeignCreateInitialState extends ExteriorDeignCreateState {}

class ExteriorDeignCreateLoadingState extends ExteriorDeignCreateState {
  ExteriorDeignCreateLoadingState();
}

class ExteriorDeignCreateSuccessState extends ExteriorDeignCreateState {
  final CommonModelResponse? login;
  final String message;

  ExteriorDeignCreateSuccessState({
    required this.login,
    required this.message,
  });
}

class ExteriorDeignCreateFailureState extends ExteriorDeignCreateState {
  final String message;

  ExteriorDeignCreateFailureState({
    required this.message,
  });
}

class ExteriorDeignCreateExceptionState extends ExteriorDeignCreateState {
  final String message;

  ExteriorDeignCreateExceptionState({
    required this.message,
  });
}
