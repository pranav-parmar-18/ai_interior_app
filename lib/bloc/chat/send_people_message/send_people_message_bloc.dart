import 'dart:convert';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../models/send_ai_message.dart';
import '../../../models/send_people_message.dart';



part 'send_people_message_event.dart';
part 'send_people_message_repository.dart';
part 'send_people_message_state.dart';

class SendPeopleMessageBloc extends Bloc<SendPeopleMessageEvent, SendPeopleMessageState> {
  SendPeopleMessageRepository adminKeySendPeopleMessageRepository = SendPeopleMessageRepository();

  SendPeopleMessageBloc() : super(SendPeopleMessageInitialState()) {
    on<SendPeopleMessageInitialEvent>((event, emit) => emit(SendPeopleMessageInitialState()));
    on<SendPeopleMessageDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(SendPeopleMessageDataEvent event, Emitter<SendPeopleMessageState> emit) async {
    emit(SendPeopleMessageLoadingState());
    try {
      await adminKeySendPeopleMessageRepository.SendPeopleMessage(event.SendPeopleMessage);
      if (adminKeySendPeopleMessageRepository.success == true) {
        emit(SendPeopleMessageSuccessState(
            SendPeopleMessage: adminKeySendPeopleMessageRepository.makeSongResponse,
            message: adminKeySendPeopleMessageRepository.message.toString().trim(),
        )
        );
      } else {
        emit(SendPeopleMessageFailureState(
          message: adminKeySendPeopleMessageRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(SendPeopleMessageExceptionState(
        message: adminKeySendPeopleMessageRepository.message.toString().trim(),
      ));
    }
  }

}
