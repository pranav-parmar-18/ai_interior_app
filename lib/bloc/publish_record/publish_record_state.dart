part of 'publish_record_bloc.dart';

abstract class PublishRecordState extends Equatable {
  PublishRecordState();

  @override
  List<Object> get props => [];
}

class PublishRecordInitialState extends PublishRecordState {}

class PublishRecordLoadingState extends PublishRecordState {
  PublishRecordLoadingState();
}

class PublishRecordSuccessState extends PublishRecordState {
  final CommonModelResponse? login;
  final String message;

  PublishRecordSuccessState({
    required this.login,
    required this.message,
  });
}

class PublishRecordFailureState extends PublishRecordState {
  final String message;

  PublishRecordFailureState({
    required this.message,
  });
}

class PublishRecordExceptionState extends PublishRecordState {
  final String message;

  PublishRecordExceptionState({
    required this.message,
  });
}
