part of 'update_user_details_bloc.dart';

abstract class UpdateUserDetailsEvent extends Equatable {
  const UpdateUserDetailsEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserDetailsInitialEvent extends UpdateUserDetailsEvent {}

class UpdateUserDetailsDataEvent extends UpdateUserDetailsEvent {
  final Map<String, dynamic> updateData;

  const UpdateUserDetailsDataEvent({required this.updateData});
}
