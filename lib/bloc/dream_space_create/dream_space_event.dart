part of 'dream_space_bloc.dart';

abstract class DreamSpaceCreateEvent extends Equatable {
  const DreamSpaceCreateEvent();

  @override
  List<Object> get props => [];
}

class DreamSpaceCreateInitialEvent extends DreamSpaceCreateEvent {}

class DreamSpaceCreateDataEvent extends DreamSpaceCreateEvent {
  final Map<String, dynamic> login;

  const DreamSpaceCreateDataEvent({required this.login});
}
