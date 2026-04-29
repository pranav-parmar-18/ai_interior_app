import 'dart:convert';
import 'package:ai_interior/models/common_model_response.dart';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/explore_model_response.dart';
import '../../models/make_song_response.dart';

part 'publish_record_event.dart';
part 'publish_record_repository.dart';
part 'publish_record_state.dart';

class PublishRecordBloc extends Bloc<PublishRecordEvent, PublishRecordState> {
  PublishRecordRepository adminKeyPublishRecordRepository = PublishRecordRepository();

  PublishRecordBloc() : super(PublishRecordInitialState()) {
    on<PublishRecordInitialEvent>((event, emit) => emit(PublishRecordInitialState()));
    on<PublishRecordDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(PublishRecordDataEvent event, Emitter<PublishRecordState> emit) async {
    emit(PublishRecordLoadingState());
    try {
      await adminKeyPublishRecordRepository.login(event.login);
      if (adminKeyPublishRecordRepository.success == true) {
        emit(PublishRecordSuccessState(
            login: adminKeyPublishRecordRepository.makeSongResponse,
            message: adminKeyPublishRecordRepository.message.toString().trim(),
        )
        );
      } else {
        emit(PublishRecordFailureState(
          message: adminKeyPublishRecordRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(PublishRecordExceptionState(
        message: adminKeyPublishRecordRepository.message.toString().trim(),
      ));
    }
  }

}
