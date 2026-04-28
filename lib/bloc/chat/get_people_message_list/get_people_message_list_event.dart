part of 'get_people_message_list_bloc.dart';

abstract class GetPeopleMessageListEvent extends Equatable {
  const GetPeopleMessageListEvent();

  @override
  List<Object> get props => [];
}

class GetPeopleMessageListInitialEvent extends GetPeopleMessageListEvent {}

class GetPeopleMessageListDataEvent extends GetPeopleMessageListEvent {


  const GetPeopleMessageListDataEvent();
}
