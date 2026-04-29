part of 'recent_single_api_bloc.dart';

abstract class RecentSingleAPIEvent extends Equatable {
  const RecentSingleAPIEvent();

  @override
  List<Object> get props => [];
}

class RecentSingleAPIInitialEvent extends RecentSingleAPIEvent {}

class RecentSingleAPIDataEvent extends RecentSingleAPIEvent {

final String genderId;
  const RecentSingleAPIDataEvent({required this.genderId});
}
