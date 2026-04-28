import 'dart:convert';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/send_ai_message.dart';



part 'send_ai_message_event.dart';
part 'send_ai_message_repository.dart';
part 'send_ai_message_state.dart';

class SendAIMessageBloc extends Bloc<SendAIMessageEvent, SendAIMessageState> {
  SendAIMessageRepository adminKeySendAIMessageRepository = SendAIMessageRepository();

  SendAIMessageBloc() : super(SendAIMessageInitialState()) {
    on<SendAIMessageInitialEvent>((event, emit) => emit(SendAIMessageInitialState()));
    on<SendAIMessageDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(SendAIMessageDataEvent event, Emitter<SendAIMessageState> emit) async {
    emit(SendAIMessageLoadingState());
    try {
      await adminKeySendAIMessageRepository.SendAIMessage(event.SendAIMessage);
      if (adminKeySendAIMessageRepository.success == true) {
        emit(SendAIMessageSuccessState(
            SendAIMessage: adminKeySendAIMessageRepository.makeSongResponse,
            message: adminKeySendAIMessageRepository.message.toString().trim(),
        )
        );
      } else {
        emit(SendAIMessageFailureState(
          message: adminKeySendAIMessageRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(SendAIMessageExceptionState(
        message: adminKeySendAIMessageRepository.message.toString().trim(),
      ));
    }
  }

}
