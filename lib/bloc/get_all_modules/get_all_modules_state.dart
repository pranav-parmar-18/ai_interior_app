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
  final List<AppModule>? modules;
  final String message;

  GetAllModulesSuccessState({
    required this.modules,
    required this.message,
  });

  @override
  List<Object> get props => [modules ?? [], message];
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
