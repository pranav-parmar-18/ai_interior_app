part of 'interior_design_create_bloc.dart';

abstract class InteriorDeignCreateEvent extends Equatable {
  const InteriorDeignCreateEvent();

  @override
  List<Object> get props => [];
}

class InteriorDeignCreateInitialEvent extends InteriorDeignCreateEvent {}

class InteriorDeignCreateDataEvent extends InteriorDeignCreateEvent {
  final Map<String, dynamic> login;

  const InteriorDeignCreateDataEvent({required this.login});
}
