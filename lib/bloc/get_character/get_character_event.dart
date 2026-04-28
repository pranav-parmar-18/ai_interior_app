part of 'get_character_bloc.dart';

abstract class GetCharacterEvent extends Equatable {
  const GetCharacterEvent();

  @override
  List<Object> get props => [];
}

class GetCharacterInitialEvent extends GetCharacterEvent {}

class GetCharacterDataEvent extends GetCharacterEvent {

final String id;
  const GetCharacterDataEvent({required this.id});
}
