part of 'upload_profile_picture_bloc.dart';

abstract class UploadProfilePictureEvent extends Equatable {
  const UploadProfilePictureEvent();

  @override
  List<Object> get props => [];
}

class UploadProfilePictureInitialEvent extends UploadProfilePictureEvent {}

class UploadProfilePictureDataEvent extends UploadProfilePictureEvent {
  final Map<String, dynamic> makeSongData;

  const UploadProfilePictureDataEvent({required this.makeSongData});
}
