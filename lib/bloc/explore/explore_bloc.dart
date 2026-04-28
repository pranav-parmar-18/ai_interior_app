import 'dart:convert';
  import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/explore_model_response.dart';
import '../../models/make_song_response.dart';
import '../../utils/app_utils.dart';



part 'explore_event.dart';
part 'explore_repository.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreRepository adminKeyLoginRepository = ExploreRepository();

  ExploreBloc() : super(ExploreInitialState()) {
    on<ExploreInitialEvent>((event, emit) => emit(ExploreInitialState()));
    on<ExploreDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(ExploreDataEvent event, Emitter<ExploreState> emit) async {
    emit(ExploreLoadingState());
    try {
      await adminKeyLoginRepository.explore();
      if (adminKeyLoginRepository.success == true) {
        emit(ExploreSuccessState(
            exploreSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(ExploreFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(ExploreExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
