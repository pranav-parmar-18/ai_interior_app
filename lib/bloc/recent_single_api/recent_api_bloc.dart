import 'dart:convert';
  import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/common_model_response.dart';
import '../../models/explore_model_response.dart';
import '../../models/make_song_response.dart';
import '../../models/partner_list_model_response.dart';
part 'partner_list_event.dart';
part 'partner_list_repository.dart';
part 'partner_list_state.dart';

class RecentSingleAPIBloc extends Bloc<RecentSingleAPIEvent, RecentSingleAPIState> {
  RecentSingleAPIRepository adminKeyLoginRepository = RecentSingleAPIRepository();

  RecentSingleAPIBloc() : super(RecentSingleAPIInitialState()) {
    on<RecentSingleAPIInitialEvent>((event, emit) => emit(RecentSingleAPIInitialState()));
    on<RecentSingleAPIDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(RecentSingleAPIDataEvent event, Emitter<RecentSingleAPIState> emit) async {
    emit(RecentSingleAPILoadingState());
    try {
      await adminKeyLoginRepository.RecentSingleAPI(event.genderId);
      if (adminKeyLoginRepository.success == true) {
        emit(RecentSingleAPISuccessState(
            exploreSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(RecentSingleAPIFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(RecentSingleAPIExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
