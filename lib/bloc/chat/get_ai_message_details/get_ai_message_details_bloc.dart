import 'dart:convert';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/common_model_response.dart';
import '../../../models/get_ai_meesage_details_response.dart';

part 'get_ai_message_details_event.dart';

part 'get_ai_message_details_repository.dart';

part 'get_ai_message_details_state.dart';

class GetAIMessageDetailsBloc
    extends Bloc<GetAIMessageDetailsEvent, GetAIMessageDetailsState> {
  GetAIMessageDetailsRepository adminKeyLoginRepository =
      GetAIMessageDetailsRepository();

  GetAIMessageDetailsBloc() : super(GetAIMessageDetailsInitialState()) {
    on<GetAIMessageDetailsInitialEvent>(
      (event, emit) => emit(GetAIMessageDetailsInitialState()),
    );
    on<GetAIMessageDetailsDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(
    GetAIMessageDetailsDataEvent event,
    Emitter<GetAIMessageDetailsState> emit,
  ) async {
    emit(GetAIMessageDetailsLoadingState());
    try {
      await adminKeyLoginRepository.getAIMessageDetails(event.id);
      if (adminKeyLoginRepository.success == true) {
        emit(
          GetAIMessageDetailsSuccessState(
            getAiMessageDetails: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
          ),
        );
      } else {
        emit(
          GetAIMessageDetailsFailureState(
            message: adminKeyLoginRepository.message.toString().trim(),
          ),
        );
      }
    } catch (error) {
      print(error);
      emit(
        GetAIMessageDetailsExceptionState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ),
      );
    }
  }
}
