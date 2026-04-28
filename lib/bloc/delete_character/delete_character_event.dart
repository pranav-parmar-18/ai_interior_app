part of 'delete_character_bloc.dart';

abstract class DeleteCharacterEvent extends Equatable {
  const DeleteCharacterEvent();

  @override
  List<Object> get props => [];
}

class KeyLoginInitialEvent extends DeleteCharacterEvent {}

class DeleteCharacterDataEvent extends DeleteCharacterEvent {
  final String id;

  const DeleteCharacterDataEvent({required this.id});
}
