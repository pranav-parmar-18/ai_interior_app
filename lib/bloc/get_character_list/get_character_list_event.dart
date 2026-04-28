part of 'get_character_list_bloc.dart';

abstract class GetCharactersListEvent extends Equatable {
  const GetCharactersListEvent();

  @override
  List<Object> get props => [];
}

class GetCharactersListInitialEvent extends GetCharactersListEvent {}

class GetCharactersListDataEvent extends GetCharactersListEvent {


  const GetCharactersListDataEvent();
}
