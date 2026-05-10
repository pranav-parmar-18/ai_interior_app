import 'dart:convert';
  import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/common_model_response.dart';
import '../../models/explore_model_response.dart';
import '../../models/image_enhance_model_response.dart';




part 'get_enhancment_response_api_event.dart';
part 'get_enhancment_response_api_repository.dart';
part 'get_enhancment_response_api_state.dart';

class GerEnhancmentResponseBloc extends Bloc<GerEnhancmentResponseEvent, GerEnhancmentResponseState> {
  GerEnhancmentResponseRepository adminKeyLoginRepository = GerEnhancmentResponseRepository();

  GerEnhancmentResponseBloc() : super(GerEnhancmentResponseInitialState()) {
    on<GerEnhancmentResponseInitialEvent>((event, emit) => emit(GerEnhancmentResponseInitialState()));
    on<GerEnhancmentResponseDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(GerEnhancmentResponseDataEvent event, Emitter<GerEnhancmentResponseState> emit) async {
    emit(GerEnhancmentResponseLoadingState());
    try {
      await adminKeyLoginRepository.getEnhancementList(event.data);
      if (adminKeyLoginRepository.success == true) {
        emit(GerEnhancmentResponseSuccessState(
            exploreSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(GerEnhancmentResponseFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(GerEnhancmentResponseExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
