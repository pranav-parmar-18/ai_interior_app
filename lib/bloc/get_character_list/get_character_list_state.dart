part of 'get_character_list_bloc.dart';

abstract class GetCharactersListState extends Equatable {
  GetCharactersListState();

  @override
  List<Object> get props => [];
}

class GetCharactersListInitialState extends GetCharactersListState {}

class GetCharactersListLoadingState extends GetCharactersListState {
  GetCharactersListLoadingState();
}

class GetCharactersListSuccessState extends GetCharactersListState {
  final GetCharacterListResponse? exploreSongResponse;
  final String message;

  GetCharactersListSuccessState({
    required this.exploreSongResponse,
    required this.message,
  });
}

class GetCharactersListFailureState extends GetCharactersListState {
  final String message;

  GetCharactersListFailureState({
    required this.message,
  });
}

class GetCharactersListExceptionState extends GetCharactersListState {
  final String message;

  GetCharactersListExceptionState({
    required this.message,
  });
}
