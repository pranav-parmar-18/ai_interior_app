part of 'get_people_message_list_bloc.dart';

abstract class GetPeopleMessageListState extends Equatable {
  GetPeopleMessageListState();

  @override
  List<Object> get props => [];
}

class GetPeopleMessageListInitialState extends GetPeopleMessageListState {}

class GetPeopleMessageListLoadingState extends GetPeopleMessageListState {
  GetPeopleMessageListLoadingState();
}

class GetPeopleMessageListSuccessState extends GetPeopleMessageListState {
  final GetPeopleRequestMessageListResponse? exploreSongResponse;
  final String message;

  GetPeopleMessageListSuccessState({
    required this.exploreSongResponse,
    required this.message,
  });
}

class GetPeopleMessageListFailureState extends GetPeopleMessageListState {
  final String message;

  GetPeopleMessageListFailureState({
    required this.message,
  });
}

class GetPeopleMessageListExceptionState extends GetPeopleMessageListState {
  final String message;

  GetPeopleMessageListExceptionState({
    required this.message,
  });
}
