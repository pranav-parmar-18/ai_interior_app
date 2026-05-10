part of 'get_enhancment_response_api_bloc.dart';

abstract class GerEnhancmentResponseState extends Equatable {
  GerEnhancmentResponseState();

  @override
  List<Object> get props => [];
}

class GerEnhancmentResponseInitialState extends GerEnhancmentResponseState {}

class GerEnhancmentResponseLoadingState extends GerEnhancmentResponseState {
  GerEnhancmentResponseLoadingState();
}

class GerEnhancmentResponseSuccessState extends GerEnhancmentResponseState {
  final ImageEnhanceModelResponse? exploreSongResponse;
  final String message;

  GerEnhancmentResponseSuccessState({
    required this.exploreSongResponse,
    required this.message,
  });
}

class GerEnhancmentResponseFailureState extends GerEnhancmentResponseState {
  final String message;

  GerEnhancmentResponseFailureState({
    required this.message,
  });
}

class GerEnhancmentResponseExceptionState extends GerEnhancmentResponseState {
  final String message;

  GerEnhancmentResponseExceptionState({
    required this.message,
  });
}
