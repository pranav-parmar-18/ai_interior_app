part of 'interior_design_create_bloc.dart';

abstract class InteriorDeignCreateState extends Equatable {
  InteriorDeignCreateState();

  @override
  List<Object> get props => [];
}

class InteriorDeignCreateInitialState extends InteriorDeignCreateState {}

class InteriorDeignCreateLoadingState extends InteriorDeignCreateState {
  InteriorDeignCreateLoadingState();
}

class InteriorDeignCreateSuccessState extends InteriorDeignCreateState {
  final InteriorDesignCreateModelResponse? login;
  final String message;

  InteriorDeignCreateSuccessState({
    required this.login,
    required this.message,
  });
}

class InteriorDeignCreateFailureState extends InteriorDeignCreateState {
  final String message;

  InteriorDeignCreateFailureState({
    required this.message,
  });
}

class InteriorDeignCreateExceptionState extends InteriorDeignCreateState {
  final String message;

  InteriorDeignCreateExceptionState({
    required this.message,
  });
}
