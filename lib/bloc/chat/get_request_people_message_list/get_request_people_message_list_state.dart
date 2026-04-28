part of 'get_request_people_message_list_bloc.dart';

abstract class GetRequestPeopleMessageListState extends Equatable {
  GetRequestPeopleMessageListState();

  @override
  List<Object> get props => [];
}

class GetRequestPeopleMessageListInitialState extends GetRequestPeopleMessageListState {}

class GetRequestPeopleMessageListLoadingState extends GetRequestPeopleMessageListState {
  GetRequestPeopleMessageListLoadingState();
}

class GetRequestPeopleMessageListSuccessState extends GetRequestPeopleMessageListState {
  final CommonModelResponse? exploreSongResponse;
  final String message;

  GetRequestPeopleMessageListSuccessState({
    required this.exploreSongResponse,
    required this.message,
  });
}

class GetRequestPeopleMessageListFailureState extends GetRequestPeopleMessageListState {
  final String message;

  GetRequestPeopleMessageListFailureState({
    required this.message,
  });
}

class GetRequestPeopleMessageListExceptionState extends GetRequestPeopleMessageListState {
  final String message;

  GetRequestPeopleMessageListExceptionState({
    required this.message,
  });
}
