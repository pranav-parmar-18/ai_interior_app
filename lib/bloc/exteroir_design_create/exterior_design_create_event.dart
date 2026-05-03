part of 'exterior_design_create_bloc.dart';

abstract class ExteriorDeignCreateEvent extends Equatable {
  const ExteriorDeignCreateEvent();

  @override
  List<Object> get props => [];
}

class ExteriorDeignCreateInitialEvent extends ExteriorDeignCreateEvent {}

class ExteriorDeignCreateDataEvent extends ExteriorDeignCreateEvent {
  final Map<String, dynamic> login;
  final File image;
  const ExteriorDeignCreateDataEvent({required this.login, required this.image});
}
