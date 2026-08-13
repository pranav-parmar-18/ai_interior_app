part of 'contact_us_bloc.dart';

abstract class ContactUsEvent extends Equatable {
  const ContactUsEvent();

  @override
  List<Object> get props => [];
}

class KeyLoginInitialEvent extends ContactUsEvent {}

class ContactUsDataEvent extends ContactUsEvent {
  final Map<String, dynamic> makeSongData;
  final File? file;

  const ContactUsDataEvent({required this.makeSongData, required this.file});
}
