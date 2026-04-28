import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/common_model_response.dart';
import '../../../utils/app_utils.dart';

part 'delete_ai_message_event.dart';

part 'delete_ai_message_repository.dart';

part 'delete_ai_message_state.dart';

class DeleteAIMessageBloc
    extends Bloc<DeleteAIMessageEvent, DeleteAIMessageState> {
  DeleteAIMessageRepository adminKeyLoginRepository =
      DeleteAIMessageRepository();

  DeleteAIMessageBloc() : super(DeleteAIMessageInitialState()) {
    on<KeyLoginInitialEvent>(
      (event, emit) => emit(DeleteAIMessageInitialState()),
    );
    on<DeleteAIMessageDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(
    DeleteAIMessageDataEvent event,
    Emitter<DeleteAIMessageState> emit,
  ) async {
    emit(DeleteAIMessageLoadingState());
    try {
      await adminKeyLoginRepository.deleteChat(event.id);
      if (adminKeyLoginRepository.success == true) {
        emit(
          DeleteAIMessageSuccessState(
            makeSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
          ),
        );
      } else {
        emit(
          DeleteAIMessageFailureState(
            message: adminKeyLoginRepository.message.toString().trim(),
          ),
        );
      }
    } catch (error) {
      print(error);
      emit(
        DeleteAIMessageExceptionState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ),
      );
    }
  }
}
