part of 'profile_match_bloc.dart';

abstract class ProfileMatchState extends Equatable {
  ProfileMatchState();

  @override
  List<Object> get props => [];
}

class ProfileMatchInitialState extends ProfileMatchState {}

class ProfileMatchLoadingState extends ProfileMatchState {
  ProfileMatchLoadingState();
}

class ProfileMatchSuccessState extends ProfileMatchState {
  final ProfileMatchResponse? ProfileMatch;
  final String message;

  ProfileMatchSuccessState({
    required this.ProfileMatch,
    required this.message,
  });
}

class ProfileMatchFailureState extends ProfileMatchState {
  final String message;

  ProfileMatchFailureState({
    required this.message,
  });
}

class ProfileMatchExceptionState extends ProfileMatchState {
  final String message;

  ProfileMatchExceptionState({
    required this.message,
  });
}
