part of 'publish_record_bloc.dart';

abstract class PublishRecordEvent extends Equatable {
  const PublishRecordEvent();

  @override
  List<Object> get props => [];
}

class PublishRecordInitialEvent extends PublishRecordEvent {}

class PublishRecordDataEvent extends PublishRecordEvent {
  final Map<String, dynamic> login;

  const PublishRecordDataEvent({required this.login});
}
