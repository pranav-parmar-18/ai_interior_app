part of 'duplicate_character_bloc.dart';

abstract class DuplicateCharacterState extends Equatable {
  DuplicateCharacterState();

  @override
  List<Object> get props => [];
}

class DuplicateCharacterInitialState extends DuplicateCharacterState {}

class DuplicateCharacterLoadingState extends DuplicateCharacterState {
  DuplicateCharacterLoadingState();
}

class DuplicateCharacterSuccessState extends DuplicateCharacterState {
  final CommonModelResponse? categoryModalResponse;
  final String message;

  DuplicateCharacterSuccessState({
    required this.categoryModalResponse,
    required this.message,
  });
}

class DuplicateCharacterFailureState extends DuplicateCharacterState {
  final String message;

  DuplicateCharacterFailureState({
    required this.message,
  });
}

class DuplicateCharacterExceptionState extends DuplicateCharacterState {
  final String message;

  DuplicateCharacterExceptionState({
    required this.message,
  });
}
