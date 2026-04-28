part of 'delete_character_bloc.dart';

abstract class DeleteCharacterState extends Equatable {
  DeleteCharacterState();

  @override
  List<Object> get props => [];
}

class DeleteCharacterInitialState extends DeleteCharacterState {}

class DeleteCharacterLoadingState extends DeleteCharacterState {
  DeleteCharacterLoadingState();
}

class DeleteCharacterSuccessState extends DeleteCharacterState {
  final CommonModelResponse? makeSongResponse;
  final String message;

  DeleteCharacterSuccessState({
    required this.makeSongResponse,
    required this.message,
  });
}

class DeleteCharacterFailureState extends DeleteCharacterState {
  final String message;

  DeleteCharacterFailureState({
    required this.message,
  });
}

class DeleteCharacterExceptionState extends DeleteCharacterState {
  final String message;

  DeleteCharacterExceptionState({
    required this.message,
  });
}
