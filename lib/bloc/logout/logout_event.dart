part of 'logout_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoryInitialEvent extends CategoryEvent {}

class CategoryDataEvent extends CategoryEvent {
  final Map<String, dynamic> makeSongData;

  const CategoryDataEvent({required this.makeSongData});
}
