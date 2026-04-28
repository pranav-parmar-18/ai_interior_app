import 'dart:convert';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/category_model_response.dart';
import '../../models/common_model_response.dart';
import '../../models/explore_model_response.dart';
import '../../models/make_song_response.dart';

part 'daily_claim_event.dart';
part 'daily_claim_repository.dart';
part 'daily_claim_state.dart';

class DailyClaimBloc extends Bloc<DailyClaimEvent, DailyClaimState> {
  DailyClaimRepository adminKeyLoginRepository = DailyClaimRepository();

  DailyClaimBloc() : super(DailyClaimInitialState()) {
    on<DailyClaimInitialEvent>((event, emit) => emit(DailyClaimInitialState()));
    on<DailyClaimDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(DailyClaimDataEvent event, Emitter<DailyClaimState> emit) async {
    emit(DailyClaimLoadingState());
    try {
      await adminKeyLoginRepository.dailyClaim(event.makeSongData);
      if (adminKeyLoginRepository.success == true) {
        emit(DailyClaimSuccessState(
            categoryModalResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(DailyClaimFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(DailyClaimExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }

}
