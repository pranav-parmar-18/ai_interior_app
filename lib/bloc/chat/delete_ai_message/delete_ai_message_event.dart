part of 'delete_ai_message_bloc.dart';

abstract class DeleteAIMessageEvent extends Equatable {
  const DeleteAIMessageEvent();

  @override
  List<Object> get props => [];
}

class KeyLoginInitialEvent extends DeleteAIMessageEvent {}

class DeleteAIMessageDataEvent extends DeleteAIMessageEvent {
  final String id;

  const DeleteAIMessageDataEvent({required this.id});
}
