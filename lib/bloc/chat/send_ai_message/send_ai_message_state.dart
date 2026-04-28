part of 'send_ai_message_bloc.dart';

abstract class SendAIMessageState extends Equatable {
  SendAIMessageState();

  @override
  List<Object> get props => [];
}

class SendAIMessageInitialState extends SendAIMessageState {}

class SendAIMessageLoadingState extends SendAIMessageState {
  SendAIMessageLoadingState();
}

class SendAIMessageSuccessState extends SendAIMessageState {
  final SendAIMessageModelResponse? SendAIMessage;
  final String message;

  SendAIMessageSuccessState({
    required this.SendAIMessage,
    required this.message,
  });
}

class SendAIMessageFailureState extends SendAIMessageState {
  final String message;

  SendAIMessageFailureState({
    required this.message,
  });
}

class SendAIMessageExceptionState extends SendAIMessageState {
  final String message;

  SendAIMessageExceptionState({
    required this.message,
  });
}
