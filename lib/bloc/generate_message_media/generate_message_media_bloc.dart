import 'dart:convert';

import 'package:ai_interior/models/common_model_response.dart';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'generate_message_media_event.dart';
part 'generate_message_media_repository.dart';
part 'generate_message_media_state.dart';

class GenerateMessageMediaBloc extends Bloc<GenerateMessageMediaEvent, GenerateMessageMediaState> {
  GenerateMessageMediaRepository adminKeyGenerateMessageMediaRepository = GenerateMessageMediaRepository();

  GenerateMessageMediaBloc() : super(GenerateMessageMediaInitialState()) {
    on<GenerateMessageMediaInitialEvent>((event, emit) => emit(GenerateMessageMediaInitialState()));
    on<GenerateMessageMediaDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(GenerateMessageMediaDataEvent event, Emitter<GenerateMessageMediaState> emit) async {
    emit(GenerateMessageMediaLoadingState());
    try {
      await adminKeyGenerateMessageMediaRepository.GenerateMessageMedia(event.GenerateMessageMedia);
      if (adminKeyGenerateMessageMediaRepository.success == true) {
        emit(GenerateMessageMediaSuccessState(
            GenerateMessageMedia: adminKeyGenerateMessageMediaRepository.makeSongResponse,
            message: adminKeyGenerateMessageMediaRepository.message.toString().trim(),
        )
        );
      } else {
        emit(GenerateMessageMediaFailureState(
          message: adminKeyGenerateMessageMediaRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(GenerateMessageMediaExceptionState(
        message: adminKeyGenerateMessageMediaRepository.message.toString().trim(),
      ));
    }
  }

}
