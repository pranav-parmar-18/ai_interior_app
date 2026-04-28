import 'dart:convert';

import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/profile_match_response.dart';

part 'profile_match_event.dart';
part 'profile_match_repository.dart';
part 'profile_match_state.dart';

class ProfileMatchBloc extends Bloc<ProfileMatchEvent, ProfileMatchState> {
  ProfileMatchRepository adminKeyProfileMatchRepository = ProfileMatchRepository();

  ProfileMatchBloc() : super(ProfileMatchInitialState()) {
    on<ProfileMatchInitialEvent>((event, emit) => emit(ProfileMatchInitialState()));
    on<ProfileMatchDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(ProfileMatchDataEvent event, Emitter<ProfileMatchState> emit) async {
    emit(ProfileMatchLoadingState());
    try {
      await adminKeyProfileMatchRepository.ProfileMatch(event.ProfileMatch);
      if (adminKeyProfileMatchRepository.success == true) {
        emit(ProfileMatchSuccessState(
            ProfileMatch: adminKeyProfileMatchRepository.makeSongResponse,
            message: adminKeyProfileMatchRepository.message.toString().trim(),
        )
        );
      } else {
        emit(ProfileMatchFailureState(
          message: adminKeyProfileMatchRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(ProfileMatchExceptionState(
        message: adminKeyProfileMatchRepository.message.toString().trim(),
      ));
    }
  }

}
