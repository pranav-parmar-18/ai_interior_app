part of 'contact_us_bloc.dart';

abstract class ContactUsState extends Equatable {
  ContactUsState();

  @override
  List<Object> get props => [];
}

class ContactUsInitialState extends ContactUsState {}

class ContactUsLoadingState extends ContactUsState {
  ContactUsLoadingState();
}

class ContactUsSuccessState extends ContactUsState {
  final CommonModelResponse? makeSongResponse;
  final String message;

  ContactUsSuccessState({
    required this.makeSongResponse,
    required this.message,
  });
}

class ContactUsFailureState extends ContactUsState {
  final String message;

  ContactUsFailureState({
    required this.message,
  });
}

class ContactUsExceptionState extends ContactUsState {
  final String message;

  ContactUsExceptionState({
    required this.message,
  });
}
