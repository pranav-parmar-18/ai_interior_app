import 'dart:convert';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/common_model_response.dart';

part 'contact_us_event.dart';
part 'contact_us_repository.dart';
part 'contact_us_state.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  ContactUsRepository adminKeyLoginRepository = ContactUsRepository();

  ContactUsBloc() : super(ContactUsInitialState()) {
    on<KeyLoginInitialEvent>((event, emit) => emit(ContactUsInitialState()));
    on<ContactUsDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(ContactUsDataEvent event, Emitter<ContactUsState> emit) async {
    emit(ContactUsLoadingState());
    try {
      await adminKeyLoginRepository.contactUs(event.makeSongData, event.file);
      if (adminKeyLoginRepository.success == true) {
        emit(ContactUsSuccessState(
            makeSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(ContactUsFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(ContactUsExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
