part of 'daily_claim_bloc.dart';

abstract class DailyClaimState extends Equatable {
  DailyClaimState();

  @override
  List<Object> get props => [];
}

class DailyClaimInitialState extends DailyClaimState {}

class DailyClaimLoadingState extends DailyClaimState {
  DailyClaimLoadingState();
}

class DailyClaimSuccessState extends DailyClaimState {
  final CommonModelResponse? categoryModalResponse;
  final String message;

  DailyClaimSuccessState({
    required this.categoryModalResponse,
    required this.message,
  });
}

class DailyClaimFailureState extends DailyClaimState {
  final String message;

  DailyClaimFailureState({
    required this.message,
  });
}

class DailyClaimExceptionState extends DailyClaimState {
  final String message;

  DailyClaimExceptionState({
    required this.message,
  });
}
