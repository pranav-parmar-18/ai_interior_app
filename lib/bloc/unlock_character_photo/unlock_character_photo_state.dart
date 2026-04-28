part of 'unlock_character_photo_bloc.dart';

abstract class UnlockCharacterPhotoState extends Equatable {
  UnlockCharacterPhotoState();

  @override
  List<Object> get props => [];
}

class UnlockCharacterPhotoInitialState extends UnlockCharacterPhotoState {}

class UnlockCharacterPhotoLoadingState extends UnlockCharacterPhotoState {
  UnlockCharacterPhotoLoadingState();
}

class UnlockCharacterPhotoSuccessState extends UnlockCharacterPhotoState {
  final CommonModelResponse? UnlockCharacterPhoto;
  final String message;

  UnlockCharacterPhotoSuccessState({
    required this.UnlockCharacterPhoto,
    required this.message,
  });
}

class UnlockCharacterPhotoFailureState extends UnlockCharacterPhotoState {
  final String message;

  UnlockCharacterPhotoFailureState({
    required this.message,
  });
}

class UnlockCharacterPhotoExceptionState extends UnlockCharacterPhotoState {
  final String message;

  UnlockCharacterPhotoExceptionState({
    required this.message,
  });
}
