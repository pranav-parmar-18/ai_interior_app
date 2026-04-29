part of 'smart_staging_create_bloc.dart';

abstract class SmartStagingCreateEvent extends Equatable {
  const SmartStagingCreateEvent();

  @override
  List<Object> get props => [];
}

class SmartStagingCreateInitialEvent extends SmartStagingCreateEvent {}

class SmartStagingCreateDataEvent extends SmartStagingCreateEvent {
  final Map<String, dynamic> login;

  const SmartStagingCreateDataEvent({required this.login});
}
