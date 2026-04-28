part of 'send_people_message_bloc.dart';

abstract class SendPeopleMessageEvent extends Equatable {
  const SendPeopleMessageEvent();

  @override
  List<Object> get props => [];
}

class SendPeopleMessageInitialEvent extends SendPeopleMessageEvent {}

class SendPeopleMessageDataEvent extends SendPeopleMessageEvent {
  final Map<String, dynamic> SendPeopleMessage;

  const SendPeopleMessageDataEvent({required this.SendPeopleMessage});
}
