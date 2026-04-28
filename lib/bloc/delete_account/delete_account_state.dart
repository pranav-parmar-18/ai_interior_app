part of 'delete_account_bloc.dart';

abstract class DeleteAccountState extends Equatable {
  DeleteAccountState();

  @override
  List<Object> get props => [];
}

class DeleteAccountInitialState extends DeleteAccountState {}

class DeleteAccountLoadingState extends DeleteAccountState {
  DeleteAccountLoadingState();
}

class DeleteAccountSuccessState extends DeleteAccountState {
  final CommonModelResponse? makeSongResponse;
  final String message;

  DeleteAccountSuccessState({
    required this.makeSongResponse,
    required this.message,
  });
}

class DeleteAccountFailureState extends DeleteAccountState {
  final String message;

  DeleteAccountFailureState({
    required this.message,
  });
}

class DeleteAccountExceptionState extends DeleteAccountState {
  final String message;

  DeleteAccountExceptionState({
    required this.message,
  });
}
