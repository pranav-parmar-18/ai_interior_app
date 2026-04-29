import 'dart:convert';
import 'package:ai_interior/models/common_model_response.dart';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/explore_model_response.dart';
import '../../models/make_song_response.dart';

part 'smart_replace_create_event.dart';
part 'smart_replace_create_repository.dart';
part 'smart_replace_create_state.dart';

class SmartReplaceObjBloc extends Bloc<SmartReplaceObjEvent, SmartReplaceObjState> {
  SmartReplaceObjRepository adminKeySmartReplaceObjRepository = SmartReplaceObjRepository();

  SmartReplaceObjBloc() : super(SmartReplaceObjInitialState()) {
    on<SmartReplaceObjInitialEvent>((event, emit) => emit(SmartReplaceObjInitialState()));
    on<SmartReplaceObjDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(SmartReplaceObjDataEvent event, Emitter<SmartReplaceObjState> emit) async {
    emit(SmartReplaceObjLoadingState());
    try {
      await adminKeySmartReplaceObjRepository.login(event.login);
      if (adminKeySmartReplaceObjRepository.success == true) {
        emit(SmartReplaceObjSuccessState(
            login: adminKeySmartReplaceObjRepository.makeSongResponse,
            message: adminKeySmartReplaceObjRepository.message.toString().trim(),
        )
        );
      } else {
        emit(SmartReplaceObjFailureState(
          message: adminKeySmartReplaceObjRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(SmartReplaceObjExceptionState(
        message: adminKeySmartReplaceObjRepository.message.toString().trim(),
      ));
    }
  }

}
