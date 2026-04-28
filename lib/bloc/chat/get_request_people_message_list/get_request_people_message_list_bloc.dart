import 'dart:convert';
  import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/common_model_response.dart';
import '../../../utils/app_utils.dart';





part 'get_request_people_message_list_event.dart';
part 'get_request_people_message_list_repository.dart';
part 'get_request_people_message_list_state.dart';

class GetRequestPeopleMessageListBloc extends Bloc<GetRequestPeopleMessageListEvent, GetRequestPeopleMessageListState> {
  GetRequestPeopleMessageListRepository adminKeyLoginRepository = GetRequestPeopleMessageListRepository();

  GetRequestPeopleMessageListBloc() : super(GetRequestPeopleMessageListInitialState()) {
    on<GetRequestPeopleMessageListInitialEvent>((event, emit) => emit(GetRequestPeopleMessageListInitialState()));
    on<GetRequestPeopleMessageListDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(GetRequestPeopleMessageListDataEvent event, Emitter<GetRequestPeopleMessageListState> emit) async {
    emit(GetRequestPeopleMessageListLoadingState());
    try {
      await adminKeyLoginRepository.requestList();
      if (adminKeyLoginRepository.success == true) {
        emit(GetRequestPeopleMessageListSuccessState(
            exploreSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(GetRequestPeopleMessageListFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(GetRequestPeopleMessageListExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
