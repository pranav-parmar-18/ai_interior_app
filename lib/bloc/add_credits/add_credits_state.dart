part of 'add_credits_bloc.dart';

abstract class AddCreditsState extends Equatable {
  AddCreditsState();

  @override
  List<Object> get props => [];
}

class AddCreditsInitialState extends AddCreditsState {}

class AddCreditsLoadingState extends AddCreditsState {
  AddCreditsLoadingState();
}

class AddCreditsSuccessState extends AddCreditsState {
  final AddCreditResponse? categoryModalResponse;
  final String message;

  AddCreditsSuccessState({
    required this.categoryModalResponse,
    required this.message,
  });
}

class AddCreditsFailureState extends AddCreditsState {
  final String message;

  AddCreditsFailureState({
    required this.message,
  });
}

class AddCreditsExceptionState extends AddCreditsState {
  final String message;

  AddCreditsExceptionState({
    required this.message,
  });
}
