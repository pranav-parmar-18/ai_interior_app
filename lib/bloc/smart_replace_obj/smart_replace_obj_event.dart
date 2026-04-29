part of 'smart_replace_obj_bloc.dart';

abstract class SmartReplaceObjEvent extends Equatable {
  const SmartReplaceObjEvent();

  @override
  List<Object> get props => [];
}

class SmartReplaceObjInitialEvent extends SmartReplaceObjEvent {}

class SmartReplaceObjDataEvent extends SmartReplaceObjEvent {
  final Map<String, dynamic> login;

  const SmartReplaceObjDataEvent({required this.login});
}
