part of 'profile_match_bloc.dart';

abstract class ProfileMatchEvent extends Equatable {
  const ProfileMatchEvent();

  @override
  List<Object> get props => [];
}

class ProfileMatchInitialEvent extends ProfileMatchEvent {}

class ProfileMatchDataEvent extends ProfileMatchEvent {
  final Map<String, dynamic> ProfileMatch;

  const ProfileMatchDataEvent({required this.ProfileMatch});
}
