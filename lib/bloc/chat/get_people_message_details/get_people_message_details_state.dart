part of 'get_people_message_details_bloc.dart';

abstract class GetPeopleMessageDetailsState extends Equatable {
  GetPeopleMessageDetailsState();

  @override
  List<Object> get props => [];
}

class GetPeopleMessageDetailsInitialState extends GetPeopleMessageDetailsState {}

class GetPeopleMessageDetailsLoadingState extends GetPeopleMessageDetailsState {
  GetPeopleMessageDetailsLoadingState();
}

class GetPeopleMessageDetailsSuccessState extends GetPeopleMessageDetailsState {
  final GetAiMessageDetailsResponse? exploreSongResponse;
  final String message;

  GetPeopleMessageDetailsSuccessState({
    required this.exploreSongResponse,
    required this.message,
  });
}

class GetPeopleMessageDetailsFailureState extends GetPeopleMessageDetailsState {
  final String message;

  GetPeopleMessageDetailsFailureState({
    required this.message,
  });
}

class GetPeopleMessageDetailsExceptionState extends GetPeopleMessageDetailsState {
  final String message;

  GetPeopleMessageDetailsExceptionState({
    required this.message,
  });
}
