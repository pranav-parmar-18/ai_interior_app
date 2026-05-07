part of 'recent_list_bloc.dart';

abstract class RecentListEvent extends Equatable {
  const RecentListEvent();

  @override
  List<Object> get props => [];
}

class RecentListInitialEvent extends RecentListEvent {}

class RecentListDataEvent extends RecentListEvent {
  final Map<String,dynamic> data;
  const RecentListDataEvent({required this.data});
}
