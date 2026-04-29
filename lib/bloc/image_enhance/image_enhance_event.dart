part of 'image_enhance_bloc.dart';

abstract class ImageEnhanceEvent extends Equatable {
  const ImageEnhanceEvent();

  @override
  List<Object> get props => [];
}

class ImageEnhanceInitialEvent extends ImageEnhanceEvent {}

class ImageEnhanceDataEvent extends ImageEnhanceEvent {
  final Map<String, dynamic> login;

  const ImageEnhanceDataEvent({required this.login});
}
