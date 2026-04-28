import 'dart:convert';
  import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/common_model_response.dart';
import '../../../models/get_people_message_list_response.dart';
import '../../../utils/app_utils.dart';





part 'get_people_message_list_event.dart';
part 'get_people_message_list_repository.dart';
part 'get_people_message_list_state.dart';

class GetPeopleMessageListBloc extends Bloc<GetPeopleMessageListEvent, GetPeopleMessageListState> {
  GetPeopleMessageListRepository adminKeyLoginRepository = GetPeopleMessageListRepository();

  GetPeopleMessageListBloc() : super(GetPeopleMessageListInitialState()) {
    on<GetPeopleMessageListInitialEvent>((event, emit) => emit(GetPeopleMessageListInitialState()));
    on<GetPeopleMessageListDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(GetPeopleMessageListDataEvent event, Emitter<GetPeopleMessageListState> emit) async {
    emit(GetPeopleMessageListLoadingState());
    try {
      await adminKeyLoginRepository.peopleMessageList();
      if (adminKeyLoginRepository.success == true) {
        emit(GetPeopleMessageListSuccessState(
            exploreSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(GetPeopleMessageListFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(GetPeopleMessageListExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
