part of 'logout_bloc.dart';

abstract class CategoryState extends Equatable {
  CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitialState extends CategoryState {}

class CategoryLoadingState extends CategoryState {
  CategoryLoadingState();
}

class CategorySuccessState extends CategoryState {
  final CategoryModelResponse? categoryModalResponse;
  final String message;

  CategorySuccessState({
    required this.categoryModalResponse,
    required this.message,
  });
}

class CategoryFailureState extends CategoryState {
  final String message;

  CategoryFailureState({
    required this.message,
  });
}

class CategoryExceptionState extends CategoryState {
  final String message;

  CategoryExceptionState({
    required this.message,
  });
}
