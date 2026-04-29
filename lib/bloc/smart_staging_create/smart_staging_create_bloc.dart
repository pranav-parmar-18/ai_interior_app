import 'dart:convert';
import 'package:ai_interior/models/common_model_response.dart';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/explore_model_response.dart';
import '../../models/make_song_response.dart';

part 'smart_staging_create_event.dart';
part 'smart_staging_create_repository.dart';
part 'smart_staging_create_state.dart';

class SmartStagingCreateBloc extends Bloc<SmartStagingCreateEvent, SmartStagingCreateState> {
  SmartStagingCreateRepository adminKeySmartStagingCreateRepository = SmartStagingCreateRepository();

  SmartStagingCreateBloc() : super(SmartStagingCreateInitialState()) {
    on<SmartStagingCreateInitialEvent>((event, emit) => emit(SmartStagingCreateInitialState()));
    on<SmartStagingCreateDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(SmartStagingCreateDataEvent event, Emitter<SmartStagingCreateState> emit) async {
    emit(SmartStagingCreateLoadingState());
    try {
      await adminKeySmartStagingCreateRepository.login(event.login);
      if (adminKeySmartStagingCreateRepository.success == true) {
        emit(SmartStagingCreateSuccessState(
            login: adminKeySmartStagingCreateRepository.makeSongResponse,
            message: adminKeySmartStagingCreateRepository.message.toString().trim(),
        )
        );
      } else {
        emit(SmartStagingCreateFailureState(
          message: adminKeySmartStagingCreateRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(SmartStagingCreateExceptionState(
        message: adminKeySmartStagingCreateRepository.message.toString().trim(),
      ));
    }
  }

}
