part of 'create_style_transfer_bloc.dart';

abstract class CreateStyleTransferState extends Equatable {
  CreateStyleTransferState();

  @override
  List<Object> get props => [];
}

class CreateStyleTransferInitialState extends CreateStyleTransferState {}

class CreateStyleTransferLoadingState extends CreateStyleTransferState {
  CreateStyleTransferLoadingState();
}

class CreateStyleTransferSuccessState extends CreateStyleTransferState {
  final CreateStyleTransferResponse? login;
  final String message;

  CreateStyleTransferSuccessState({
    required this.login,
    required this.message,
  });
}

class CreateStyleTransferFailureState extends CreateStyleTransferState {
  final String message;

  CreateStyleTransferFailureState({
    required this.message,
  });
}

class CreateStyleTransferExceptionState extends CreateStyleTransferState {
  final String message;

  CreateStyleTransferExceptionState({
    required this.message,
  });
}
