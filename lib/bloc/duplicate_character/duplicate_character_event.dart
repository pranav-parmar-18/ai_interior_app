part of 'duplicate_character_bloc.dart';

abstract class DuplicateCharacterEvent extends Equatable {
  const DuplicateCharacterEvent();

  @override
  List<Object> get props => [];
}

class DuplicateCharacterInitialEvent extends DuplicateCharacterEvent {}

class DuplicateCharacterDataEvent extends DuplicateCharacterEvent {
  final Map<String, dynamic> makeSongData;

  const DuplicateCharacterDataEvent({required this.makeSongData});
}
