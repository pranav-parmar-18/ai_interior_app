import 'dart:convert';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/common_model_response.dart';
import '../../../models/send_ai_message.dart';
import '../../../models/send_people_message.dart';



part 'send_ai_message_from_gf_event.dart';
part 'send_ai_message_from_gf_repository.dart';
part 'send_ai_message_from_gf_state.dart';

class SendAIMessageFromGFBloc extends Bloc<SendAIMessageFromGFEvent, SendAIMessageFromGFState> {
  SendAIMessageFromGFRepository adminKeySendAIMessageFromGFRepository = SendAIMessageFromGFRepository();

  SendAIMessageFromGFBloc() : super(SendAIMessageFromGFInitialState()) {
    on<SendAIMessageFromGFInitialEvent>((event, emit) => emit(SendAIMessageFromGFInitialState()));
    on<SendAIMessageFromGFDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(SendAIMessageFromGFDataEvent event, Emitter<SendAIMessageFromGFState> emit) async {
    emit(SendAIMessageFromGFLoadingState());
    try {
      await adminKeySendAIMessageFromGFRepository.SendAIMessageFromGF(event.SendAIMessageFromGF);
      if (adminKeySendAIMessageFromGFRepository.success == true) {
        emit(SendAIMessageFromGFSuccessState(
            SendAIMessageFromGF: adminKeySendAIMessageFromGFRepository.makeSongResponse,
            message: adminKeySendAIMessageFromGFRepository.message.toString().trim(),
        )
        );
      } else {
        emit(SendAIMessageFromGFFailureState(
          message: adminKeySendAIMessageFromGFRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(SendAIMessageFromGFExceptionState(
        message: adminKeySendAIMessageFromGFRepository.message.toString().trim(),
      ));
    }
  }

}
