part of 'send_ai_message_bloc.dart';

abstract class SendAIMessageEvent extends Equatable {
  const SendAIMessageEvent();

  @override
  List<Object> get props => [];
}

class SendAIMessageInitialEvent extends SendAIMessageEvent {}

class SendAIMessageDataEvent extends SendAIMessageEvent {
  final Map<String, dynamic> SendAIMessage;

  const SendAIMessageDataEvent({required this.SendAIMessage});
}
