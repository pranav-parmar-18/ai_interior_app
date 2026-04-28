import 'dart:convert';
  import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../models/common_model_response.dart';
import '../../../models/get_ai_meesage_details_response.dart';
import '../../../utils/app_utils.dart';





part 'get_people_message_details_event.dart';
part 'get_people_message_details_repository.dart';
part 'get_people_message_details_state.dart';

class GetPeopleMessageDetailsBloc extends Bloc<GetPeopleMessageDetailsEvent, GetPeopleMessageDetailsState> {
  GetPeopleMessageDetailsRepository adminKeyLoginRepository = GetPeopleMessageDetailsRepository();

  GetPeopleMessageDetailsBloc() : super(GetPeopleMessageDetailsInitialState()) {
    on<GetPeopleMessageDetailsInitialEvent>((event, emit) => emit(GetPeopleMessageDetailsInitialState()));
    on<GetPeopleMessageDetailsDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(GetPeopleMessageDetailsDataEvent event, Emitter<GetPeopleMessageDetailsState> emit) async {
    emit(GetPeopleMessageDetailsLoadingState());
    try {
      await adminKeyLoginRepository.explore(event.id);
      if (adminKeyLoginRepository.success == true) {
        emit(GetPeopleMessageDetailsSuccessState(
            exploreSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(GetPeopleMessageDetailsFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(GetPeopleMessageDetailsExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
