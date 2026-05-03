part of 'create_style_transfer_bloc.dart';

abstract class CreateStyleTransferEvent extends Equatable {
  const CreateStyleTransferEvent();

  @override
  List<Object> get props => [];
}

class CreateStyleTransferInitialEvent extends CreateStyleTransferEvent {}

class CreateStyleTransferDataEvent extends CreateStyleTransferEvent {
  final Map<String, dynamic> login;
  final File image;
  final File refImage;

  const CreateStyleTransferDataEvent({
    required this.login,
    required this.image,
    required this.refImage,
  });
}
