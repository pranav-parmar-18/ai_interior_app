import 'dart:convert';
  import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/common_model_response.dart';
import '../../models/explore_model_response.dart';

import '../../utils/app_utils.dart';



part 'get_user_details_event.dart';
part 'get_user_details_repository.dart';
part 'get_user_details_state.dart';

class GetUsersBloc extends Bloc<GetUsersEvent, GetUsersState> {
  GetUsersRepository adminKeyLoginRepository = GetUsersRepository();

  GetUsersBloc() : super(GetUsersInitialState()) {
    on<GetUsersInitialEvent>((event, emit) => emit(GetUsersInitialState()));
    on<GetUsersDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(GetUsersDataEvent event, Emitter<GetUsersState> emit) async {
    emit(GetUsersLoadingState());
    try {
      await adminKeyLoginRepository.getUserDetails(event.id);
      if (adminKeyLoginRepository.success == true) {
        emit(GetUsersSuccessState(
            user: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(GetUsersFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(GetUsersExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
