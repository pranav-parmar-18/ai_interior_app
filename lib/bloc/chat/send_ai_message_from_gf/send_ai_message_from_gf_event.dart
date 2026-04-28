part of 'send_ai_message_from_gf_bloc.dart';

abstract class SendAIMessageFromGFEvent extends Equatable {
  const SendAIMessageFromGFEvent();

  @override
  List<Object> get props => [];
}

class SendAIMessageFromGFInitialEvent extends SendAIMessageFromGFEvent {}

class SendAIMessageFromGFDataEvent extends SendAIMessageFromGFEvent {
  final Map<String, dynamic> SendAIMessageFromGF;

  const SendAIMessageFromGFDataEvent({required this.SendAIMessageFromGF});
}
