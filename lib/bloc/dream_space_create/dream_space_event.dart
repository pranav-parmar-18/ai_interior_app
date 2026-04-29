part of 'dream_space_bloc.dart';

abstract class CreateUserEvent extends Equatable {
  const CreateUserEvent();

  @override
  List<Object> get props => [];
}

class CreateUserInitialEvent extends CreateUserEvent {}

class CreateUserDataEvent extends CreateUserEvent {
  final Map<String, dynamic> login;

  const CreateUserDataEvent({required this.login});
}
