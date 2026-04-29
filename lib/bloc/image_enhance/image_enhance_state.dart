part of 'image_enhance_bloc.dart';

abstract class ImageEnhanceState extends Equatable {
  ImageEnhanceState();

  @override
  List<Object> get props => [];
}

class ImageEnhanceInitialState extends ImageEnhanceState {}

class ImageEnhanceLoadingState extends ImageEnhanceState {
  ImageEnhanceLoadingState();
}

class ImageEnhanceSuccessState extends ImageEnhanceState {
  final CommonModelResponse? login;
  final String message;

  ImageEnhanceSuccessState({
    required this.login,
    required this.message,
  });
}

class ImageEnhanceFailureState extends ImageEnhanceState {
  final String message;

  ImageEnhanceFailureState({
    required this.message,
  });
}

class ImageEnhanceExceptionState extends ImageEnhanceState {
  final String message;

  ImageEnhanceExceptionState({
    required this.message,
  });
}
