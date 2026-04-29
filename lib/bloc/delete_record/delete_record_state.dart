part of 'delete_record_bloc.dart';

abstract class DeleteRecordState extends Equatable {
  DeleteRecordState();

  @override
  List<Object> get props => [];
}

class DeleteRecordInitialState extends DeleteRecordState {}

class DeleteRecordLoadingState extends DeleteRecordState {
  DeleteRecordLoadingState();
}

class DeleteRecordSuccessState extends DeleteRecordState {
  final CommonModelResponse? login;
  final String message;

  DeleteRecordSuccessState({
    required this.login,
    required this.message,
  });
}

class DeleteRecordFailureState extends DeleteRecordState {
  final String message;

  DeleteRecordFailureState({
    required this.message,
  });
}

class DeleteRecordExceptionState extends DeleteRecordState {
  final String message;

  DeleteRecordExceptionState({
    required this.message,
  });
}
