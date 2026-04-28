part of 'daily_claim_bloc.dart';

abstract class DailyClaimEvent extends Equatable {
  const DailyClaimEvent();

  @override
  List<Object> get props => [];
}

class DailyClaimInitialEvent extends DailyClaimEvent {}

class DailyClaimDataEvent extends DailyClaimEvent {
  final Map<String, dynamic> makeSongData;

  const DailyClaimDataEvent({required this.makeSongData});
}
