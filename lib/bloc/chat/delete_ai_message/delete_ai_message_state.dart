part of 'delete_ai_message_bloc.dart';

abstract class DeleteAIMessageState extends Equatable {
  DeleteAIMessageState();

  @override
  List<Object> get props => [];
}

class DeleteAIMessageInitialState extends DeleteAIMessageState {}

class DeleteAIMessageLoadingState extends DeleteAIMessageState {
  DeleteAIMessageLoadingState();
}

class DeleteAIMessageSuccessState extends DeleteAIMessageState {
  final CommonModelResponse? makeSongResponse;
  final String message;

  DeleteAIMessageSuccessState({
    required this.makeSongResponse,
    required this.message,
  });
}

class DeleteAIMessageFailureState extends DeleteAIMessageState {
  final String message;

  DeleteAIMessageFailureState({
    required this.message,
  });
}

class DeleteAIMessageExceptionState extends DeleteAIMessageState {
  final String message;

  DeleteAIMessageExceptionState({
    required this.message,
  });
}
