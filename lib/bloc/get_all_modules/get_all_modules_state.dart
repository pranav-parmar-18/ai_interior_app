part of 'get_all_modules_bloc.dart';

abstract class GetAllModulesState extends Equatable {
  GetAllModulesState();

  @override
  List<Object> get props => [];
}

class GetAllModulesInitialState extends GetAllModulesState {}

class GetAllModulesLoadingState extends GetAllModulesState {
  GetAllModulesLoadingState();
}

class GetAllModulesSuccessState extends GetAllModulesState {
  final CommonModelResponse? photoModelResponse;
  final String message;

  GetAllModulesSuccessState({
    required this.photoModelResponse,
    required this.message,
  });
}

class GetAllModulesFailureState extends GetAllModulesState {
  final String message;

  GetAllModulesFailureState({
    required this.message,
  });
}

class GetAllModulesExceptionState extends GetAllModulesState {
  final String message;

  GetAllModulesExceptionState({
    required this.message,
  });
}
