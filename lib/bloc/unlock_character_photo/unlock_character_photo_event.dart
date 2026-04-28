part of 'unlock_character_photo_bloc.dart';

abstract class UnlockCharacterPhotoEvent extends Equatable {
  const UnlockCharacterPhotoEvent();

  @override
  List<Object> get props => [];
}

class UnlockCharacterPhotoInitialEvent extends UnlockCharacterPhotoEvent {}

class UnlockCharacterPhotoDataEvent extends UnlockCharacterPhotoEvent {
  final Map<String, dynamic> UnlockCharacterPhoto;

  const UnlockCharacterPhotoDataEvent({required this.UnlockCharacterPhoto});
}
