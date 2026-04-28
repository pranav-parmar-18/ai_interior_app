part of 'fix_ai_message_from_gf_bloc.dart';

abstract class FixAIMessageFromGFState extends Equatable {
  FixAIMessageFromGFState();

  @override
  List<Object> get props => [];
}

class FixAIMessageFromGFInitialState extends FixAIMessageFromGFState {}

class FixAIMessageFromGFLoadingState extends FixAIMessageFromGFState {
  FixAIMessageFromGFLoadingState();
}

class FixAIMessageFromGFSuccessState extends FixAIMessageFromGFState {
  final CommonModelResponse? FixAIMessageFromGF;
  final String message;

  FixAIMessageFromGFSuccessState({
    required this.FixAIMessageFromGF,
    required this.message,
  });
}

class FixAIMessageFromGFFailureState extends FixAIMessageFromGFState {
  final String message;

  FixAIMessageFromGFFailureState({required this.message});
}

class FixAIMessageFromGFExceptionState extends FixAIMessageFromGFState {
  final String message;

  FixAIMessageFromGFExceptionState({required this.message});
}
