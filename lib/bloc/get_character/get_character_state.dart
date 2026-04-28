part of 'get_character_bloc.dart';

abstract class GetCharacterState extends Equatable {
  GetCharacterState();

  @override
  List<Object> get props => [];
}

class GetCharacterInitialState extends GetCharacterState {}

class GetCharacterLoadingState extends GetCharacterState {
  GetCharacterLoadingState();
}

class GetCharacterSuccessState extends GetCharacterState {
  final CharacterResponse? characterResponse;
  final String message;

  GetCharacterSuccessState({
    required this.characterResponse,
    required this.message,
  });
}

class GetCharacterFailureState extends GetCharacterState {
  final String message;

  GetCharacterFailureState({
    required this.message,
  });
}

class GetCharacterExceptionState extends GetCharacterState {
  final String message;

  GetCharacterExceptionState({
    required this.message,
  });
}
