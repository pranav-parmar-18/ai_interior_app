part of 'generate_message_media_bloc.dart';

abstract class GenerateMessageMediaState extends Equatable {
  GenerateMessageMediaState();

  @override
  List<Object> get props => [];
}

class GenerateMessageMediaInitialState extends GenerateMessageMediaState {}

class GenerateMessageMediaLoadingState extends GenerateMessageMediaState {
  GenerateMessageMediaLoadingState();
}

class GenerateMessageMediaSuccessState extends GenerateMessageMediaState {
  final CommonModelResponse? GenerateMessageMedia;
  final String message;

  GenerateMessageMediaSuccessState({
    required this.GenerateMessageMedia,
    required this.message,
  });
}

class GenerateMessageMediaFailureState extends GenerateMessageMediaState {
  final String message;

  GenerateMessageMediaFailureState({
    required this.message,
  });
}

class GenerateMessageMediaExceptionState extends GenerateMessageMediaState {
  final String message;

  GenerateMessageMediaExceptionState({
    required this.message,
  });
}
