part of 'upload_profile_picture_bloc.dart';

abstract class UploadProfilePictureState extends Equatable {
  UploadProfilePictureState();

  @override
  List<Object> get props => [];
}

class UploadProfilePictureInitialState extends UploadProfilePictureState {}

class UploadProfilePictureLoadingState extends UploadProfilePictureState {
  UploadProfilePictureLoadingState();
}

class UploadProfilePictureSuccessState extends UploadProfilePictureState {
  final CommonModelResponse? categoryModalResponse;
  final String message;

  UploadProfilePictureSuccessState({
    required this.categoryModalResponse,
    required this.message,
  });
}

class UploadProfilePictureFailureState extends UploadProfilePictureState {
  final String message;

  UploadProfilePictureFailureState({
    required this.message,
  });
}

class UploadProfilePictureExceptionState extends UploadProfilePictureState {
  final String message;

  UploadProfilePictureExceptionState({
    required this.message,
  });
}
