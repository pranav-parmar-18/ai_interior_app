part of 'image_generator_bloc.dart';

abstract class ImageGeneratorEvent extends Equatable {
  const ImageGeneratorEvent();

  @override
  List<Object> get props => [];
}

class ImageGeneratorInitialEvent extends ImageGeneratorEvent {}

class ImageGeneratorDataEvent extends ImageGeneratorEvent {
  final Map<String, dynamic> imageGenData;

  const ImageGeneratorDataEvent({required this.imageGenData});
}
