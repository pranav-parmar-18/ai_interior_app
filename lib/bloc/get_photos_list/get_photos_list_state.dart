part of 'get_photos_list_bloc.dart';

abstract class GetPhotosListState extends Equatable {
  GetPhotosListState();

  @override
  List<Object> get props => [];
}

class GetPhotosListInitialState extends GetPhotosListState {}

class GetPhotosListLoadingState extends GetPhotosListState {
  GetPhotosListLoadingState();
}

class GetPhotosListSuccessState extends GetPhotosListState {
  final PhotosModelResponse? photoModelResponse;
  final String message;

  GetPhotosListSuccessState({
    required this.photoModelResponse,
    required this.message,
  });
}

class GetPhotosListFailureState extends GetPhotosListState {
  final String message;

  GetPhotosListFailureState({
    required this.message,
  });
}

class GetPhotosListExceptionState extends GetPhotosListState {
  final String message;

  GetPhotosListExceptionState({
    required this.message,
  });
}
