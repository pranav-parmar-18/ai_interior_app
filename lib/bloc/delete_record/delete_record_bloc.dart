import 'dart:convert';
import 'package:ai_interior/models/common_model_response.dart';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/explore_model_response.dart';
import '../../models/make_song_response.dart';

part 'delete_record_event.dart';
part 'delete_record_repository.dart';
part 'delete_record_state.dart';

class DeleteRecordBloc extends Bloc<DeleteRecordEvent, DeleteRecordState> {
  DeleteRecordRepository adminKeyDeleteRecordRepository = DeleteRecordRepository();

  DeleteRecordBloc() : super(DeleteRecordInitialState()) {
    on<DeleteRecordInitialEvent>((event, emit) => emit(DeleteRecordInitialState()));
    on<DeleteRecordDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(DeleteRecordDataEvent event, Emitter<DeleteRecordState> emit) async {
    emit(DeleteRecordLoadingState());
    try {
      await adminKeyDeleteRecordRepository.login(event.login);
      if (adminKeyDeleteRecordRepository.success == true) {
        emit(DeleteRecordSuccessState(
            login: adminKeyDeleteRecordRepository.makeSongResponse,
            message: adminKeyDeleteRecordRepository.message.toString().trim(),
        )
        );
      } else {
        emit(DeleteRecordFailureState(
          message: adminKeyDeleteRecordRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(DeleteRecordExceptionState(
        message: adminKeyDeleteRecordRepository.message.toString().trim(),
      ));
    }
  }

}
