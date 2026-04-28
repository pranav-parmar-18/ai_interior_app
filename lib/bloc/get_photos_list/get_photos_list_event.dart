part of 'get_photos_list_bloc.dart';

abstract class GetPhotosListEvent extends Equatable {
  const GetPhotosListEvent();

  @override
  List<Object> get props => [];
}

class GetPhotosListInitialEvent extends GetPhotosListEvent {}

class GetPhotosListDataEvent extends GetPhotosListEvent {


  const GetPhotosListDataEvent();
}
