part of 'dream_space_bloc.dart';

abstract class DreamSpaceCreateState extends Equatable {
  DreamSpaceCreateState();

  @override
  List<Object> get props => [];
}

class DreamSpaceCreateInitialState extends DreamSpaceCreateState {}

class DreamSpaceCreateLoadingState extends DreamSpaceCreateState {
  DreamSpaceCreateLoadingState();
}

class DreamSpaceCreateSuccessState extends DreamSpaceCreateState {
  final CommonModelResponse? login;
  final String message;

  DreamSpaceCreateSuccessState({
    required this.login,
    required this.message,
  });
}

class DreamSpaceCreateFailureState extends DreamSpaceCreateState {
  final String message;

  DreamSpaceCreateFailureState({
    required this.message,
  });
}

class DreamSpaceCreateExceptionState extends DreamSpaceCreateState {
  final String message;

  DreamSpaceCreateExceptionState({
    required this.message,
  });
}
