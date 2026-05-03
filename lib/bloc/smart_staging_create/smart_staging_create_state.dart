part of 'smart_staging_create_bloc.dart';

abstract class SmartStagingCreateState extends Equatable {
  SmartStagingCreateState();

  @override
  List<Object> get props => [];
}

class SmartStagingCreateInitialState extends SmartStagingCreateState {}

class SmartStagingCreateLoadingState extends SmartStagingCreateState {
  SmartStagingCreateLoadingState();
}

class SmartStagingCreateSuccessState extends SmartStagingCreateState {
  final SmartStagingCreateModelResponse? login;
  final String message;

  SmartStagingCreateSuccessState({
    required this.login,
    required this.message,
  });
}

class SmartStagingCreateFailureState extends SmartStagingCreateState {
  final String message;

  SmartStagingCreateFailureState({
    required this.message,
  });
}

class SmartStagingCreateExceptionState extends SmartStagingCreateState {
  final String message;

  SmartStagingCreateExceptionState({
    required this.message,
  });
}
