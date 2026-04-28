part of 'get_request_people_message_list_bloc.dart';

abstract class GetRequestPeopleMessageListEvent extends Equatable {
  const GetRequestPeopleMessageListEvent();

  @override
  List<Object> get props => [];
}

class GetRequestPeopleMessageListInitialEvent extends GetRequestPeopleMessageListEvent {}

class GetRequestPeopleMessageListDataEvent extends GetRequestPeopleMessageListEvent {


  const GetRequestPeopleMessageListDataEvent();
}
