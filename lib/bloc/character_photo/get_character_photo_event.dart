part of 'get_character_photo_bloc.dart';

abstract class GetCharacterPhotoEvent extends Equatable {
  const GetCharacterPhotoEvent();

  @override
  List<Object> get props => [];
}

class GetCharacterPhotoInitialEvent extends GetCharacterPhotoEvent {}

class GetCharacterPhotoDataEvent extends GetCharacterPhotoEvent {
final String id;

  const GetCharacterPhotoDataEvent({required this.id});
}
