import 'dart:convert';
  import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/common_model_response.dart';
import '../../../models/get_ai_chat_message_list_response.dart';





part 'get_ai_message_list_event.dart';
part 'get_ai_message_list_repository.dart';
part 'get_ai_message_list_state.dart';

class GetAIMessageListBloc extends Bloc<GetAIMessageListEvent, GetAIMessageListState> {
  GetAIMessageListRepository adminKeyLoginRepository = GetAIMessageListRepository();

  GetAIMessageListBloc() : super(GetAIMessageListInitialState()) {
    on<GetAIMessageListInitialEvent>((event, emit) => emit(GetAIMessageListInitialState()));
    on<GetAIMessageListDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(GetAIMessageListDataEvent event, Emitter<GetAIMessageListState> emit) async {
    emit(GetAIMessageListLoadingState());
    try {
      await adminKeyLoginRepository.aiMessageList();
      if (adminKeyLoginRepository.success == true) {
        emit(GetAIMessageListSuccessState(
            exploreSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(GetAIMessageListFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(GetAIMessageListExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
