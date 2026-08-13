part of 'smart_replace_create_bloc.dart';

abstract class SmartReplaceCreateEvent extends Equatable {
  const SmartReplaceCreateEvent();

  @override
  List<Object> get props => [];
}

class SmartReplaceCreateInitialEvent extends SmartReplaceCreateEvent {}

class SmartReplaceCreateDataEvent extends SmartReplaceCreateEvent {
  final Map<String, dynamic> login;
  final File image;
  final File mask;

  const SmartReplaceCreateDataEvent({
    required this.login,
    required this.image,
    required this.mask,
  });

  @override
  List<Object> get props => [login, image, mask];
}

