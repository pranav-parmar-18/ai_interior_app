part of 'send_ai_message_from_gf_bloc.dart';

abstract class SendAIMessageFromGFState extends Equatable {
  SendAIMessageFromGFState();

  @override
  List<Object> get props => [];
}

class SendAIMessageFromGFInitialState extends SendAIMessageFromGFState {}

class SendAIMessageFromGFLoadingState extends SendAIMessageFromGFState {
  SendAIMessageFromGFLoadingState();
}

class SendAIMessageFromGFSuccessState extends SendAIMessageFromGFState {
  final CommonModelResponse? SendAIMessageFromGF;
  final String message;

  SendAIMessageFromGFSuccessState({
    required this.SendAIMessageFromGF,
    required this.message,
  });
}

class SendAIMessageFromGFFailureState extends SendAIMessageFromGFState {
  final String message;

  SendAIMessageFromGFFailureState({required this.message});
}

class SendAIMessageFromGFExceptionState extends SendAIMessageFromGFState {
  final String message;

  SendAIMessageFromGFExceptionState({required this.message});
}
