part of 'generate_message_media_bloc.dart';

abstract class GenerateMessageMediaEvent extends Equatable {
  const GenerateMessageMediaEvent();

  @override
  List<Object> get props => [];
}

class GenerateMessageMediaInitialEvent extends GenerateMessageMediaEvent {}

class GenerateMessageMediaDataEvent extends GenerateMessageMediaEvent {
  final Map<String, dynamic> GenerateMessageMedia;

  const GenerateMessageMediaDataEvent({required this.GenerateMessageMedia});
}
