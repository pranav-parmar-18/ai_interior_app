part of 'delete_record_bloc.dart';

abstract class DeleteRecordEvent extends Equatable {
  const DeleteRecordEvent();

  @override
  List<Object> get props => [];
}

class DeleteRecordInitialEvent extends DeleteRecordEvent {}

class DeleteRecordDataEvent extends DeleteRecordEvent {
  final Map<String, dynamic> login;

  const DeleteRecordDataEvent({required this.login});
}
