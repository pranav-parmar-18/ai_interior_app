part of 'image_generator_bloc.dart';

abstract class ImageGeneratorState extends Equatable {
  ImageGeneratorState();

  @override
  List<Object> get props => [];
}

class ImageGeneratorInitialState extends ImageGeneratorState {}

class ImageGeneratorLoadingState extends ImageGeneratorState {
  ImageGeneratorLoadingState();
}

class ImageGeneratorSuccessState extends ImageGeneratorState {
  final ImageGeneratorModelResponse? imgResponse;
  final String message;

  ImageGeneratorSuccessState({
    required this.imgResponse,
    required this.message,
  });
}

class ImageGeneratorFailureState extends ImageGeneratorState {
  final String message;

  ImageGeneratorFailureState({
    required this.message,
  });
}

class ImageGeneratorExceptionState extends ImageGeneratorState {
  final String message;

  ImageGeneratorExceptionState({
    required this.message,
  });
}
