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



part 'fix_ai_message_from_gf_event.dart';
part 'fix_ai_message_from_gf_repository.dart';
part 'fix_ai_message_from_gf_state.dart';

class FixAIMessageFromGFBloc extends Bloc<FixAIMessageFromGFEvent, FixAIMessageFromGFState> {
  FixAIMessageFromGFRepository adminKeyFixAIMessageFromGFRepository = FixAIMessageFromGFRepository();

  FixAIMessageFromGFBloc() : super(FixAIMessageFromGFInitialState()) {
    on<FixAIMessageFromGFInitialEvent>((event, emit) => emit(FixAIMessageFromGFInitialState()));
    on<FixAIMessageFromGFDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(FixAIMessageFromGFDataEvent event, Emitter<FixAIMessageFromGFState> emit) async {
    emit(FixAIMessageFromGFLoadingState());
    try {
      await adminKeyFixAIMessageFromGFRepository.FixAIMessageFromGF();
      if (adminKeyFixAIMessageFromGFRepository.success == true) {
        emit(FixAIMessageFromGFSuccessState(
            FixAIMessageFromGF: adminKeyFixAIMessageFromGFRepository.makeSongResponse,
            message: adminKeyFixAIMessageFromGFRepository.message.toString().trim(),
        )
        );
      } else {
        emit(FixAIMessageFromGFFailureState(
          message: adminKeyFixAIMessageFromGFRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(FixAIMessageFromGFExceptionState(
        message: adminKeyFixAIMessageFromGFRepository.message.toString().trim(),
      ));
    }
  }

}
