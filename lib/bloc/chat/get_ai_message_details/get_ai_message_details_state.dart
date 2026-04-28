part of 'get_ai_message_details_bloc.dart';

abstract class GetAIMessageDetailsState extends Equatable {
  GetAIMessageDetailsState();

  @override
  List<Object> get props => [];
}

class GetAIMessageDetailsInitialState extends GetAIMessageDetailsState {}

class GetAIMessageDetailsLoadingState extends GetAIMessageDetailsState {
  GetAIMessageDetailsLoadingState();
}

class GetAIMessageDetailsSuccessState extends GetAIMessageDetailsState {
  final GetAiMessageDetailsResponse? getAiMessageDetails;
  final String message;

  GetAIMessageDetailsSuccessState({
    required this.getAiMessageDetails,
    required this.message,
  });
}

class GetAIMessageDetailsFailureState extends GetAIMessageDetailsState {
  final String message;

  GetAIMessageDetailsFailureState({
    required this.message,
  });
}

class GetAIMessageDetailsExceptionState extends GetAIMessageDetailsState {
  final String message;

  GetAIMessageDetailsExceptionState({
    required this.message,
  });
}
