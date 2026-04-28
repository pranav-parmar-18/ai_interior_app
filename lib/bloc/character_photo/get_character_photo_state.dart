part of 'get_character_photo_bloc.dart';

abstract class GetCharacterPhotoState extends Equatable {
  GetCharacterPhotoState();

  @override
  List<Object> get props => [];
}

class GetCharacterPhotoInitialState extends GetCharacterPhotoState {}

class GetCharacterPhotoLoadingState extends GetCharacterPhotoState {
  GetCharacterPhotoLoadingState();
}

class GetCharacterPhotoSuccessState extends GetCharacterPhotoState {
  final CharacterPhotosResponse? exploreSongResponse;
  final String message;

  GetCharacterPhotoSuccessState({
    required this.exploreSongResponse,
    required this.message,
  });
}

class GetCharacterPhotoFailureState extends GetCharacterPhotoState {
  final String message;

  GetCharacterPhotoFailureState({
    required this.message,
  });
}

class GetCharacterPhotoExceptionState extends GetCharacterPhotoState {
  final String message;

  GetCharacterPhotoExceptionState({
    required this.message,
  });
}
