part of 'get_user_details_bloc.dart';

abstract class GetUsersEvent extends Equatable {
  const GetUsersEvent();

  @override
  List<Object> get props => [];
}

class GetUsersInitialEvent extends GetUsersEvent {}

class GetUsersDataEvent extends GetUsersEvent {

final  String id;
   const GetUsersDataEvent({required this.id});
}
