part of 'get_people_message_details_bloc.dart';

abstract class GetPeopleMessageDetailsEvent extends Equatable {
  const GetPeopleMessageDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetPeopleMessageDetailsInitialEvent extends GetPeopleMessageDetailsEvent {}

class GetPeopleMessageDetailsDataEvent extends GetPeopleMessageDetailsEvent {

  final String id;
  const GetPeopleMessageDetailsDataEvent({required this.id});
}
