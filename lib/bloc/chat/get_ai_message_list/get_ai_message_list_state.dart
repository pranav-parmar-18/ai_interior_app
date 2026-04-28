part of 'get_ai_message_list_bloc.dart';

abstract class GetAIMessageListState extends Equatable {
  GetAIMessageListState();

  @override
  List<Object> get props => [];
}

class GetAIMessageListInitialState extends GetAIMessageListState {}

class GetAIMessageListLoadingState extends GetAIMessageListState {
  GetAIMessageListLoadingState();
}

class GetAIMessageListSuccessState extends GetAIMessageListState {
  final GetAIMessageListResponse? exploreSongResponse;
  final String message;

  GetAIMessageListSuccessState({
    required this.exploreSongResponse,
    required this.message,
  });
}

class GetAIMessageListFailureState extends GetAIMessageListState {
  final String message;

  GetAIMessageListFailureState({
    required this.message,
  });
}

class GetAIMessageListExceptionState extends GetAIMessageListState {
  final String message;

  GetAIMessageListExceptionState({
    required this.message,
  });
}
