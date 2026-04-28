part of 'send_people_message_bloc.dart';

abstract class SendPeopleMessageState extends Equatable {
  SendPeopleMessageState();

  @override
  List<Object> get props => [];
}

class SendPeopleMessageInitialState extends SendPeopleMessageState {}

class SendPeopleMessageLoadingState extends SendPeopleMessageState {
  SendPeopleMessageLoadingState();
}

class SendPeopleMessageSuccessState extends SendPeopleMessageState {
    final SendPeopleMessageModelResponse? SendPeopleMessage;
  final String message;

  SendPeopleMessageSuccessState({
    required this.SendPeopleMessage,
    required this.message,
  });
}

class SendPeopleMessageFailureState extends SendPeopleMessageState {
  final String message;

  SendPeopleMessageFailureState({
    required this.message,
  });
}

class SendPeopleMessageExceptionState extends SendPeopleMessageState {
  final String message;

  SendPeopleMessageExceptionState({
    required this.message,
  });
}
