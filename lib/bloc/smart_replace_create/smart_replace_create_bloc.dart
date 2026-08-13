import 'dart:convert';
import 'dart:io';
import 'package:ai_interior/models/common_model_response.dart';
import 'package:ai_interior/models/smart_replace_create_model_response.dart';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/explore_model_response.dart';

part 'smart_replace_create_event.dart';
part 'smart_replace_create_repository.dart';
part 'smart_replace_create_state.dart';

class SmartReplaceCreateBloc extends Bloc<SmartReplaceCreateEvent, SmartReplaceCreateState> {
  SmartReplaceCreateRepository adminKeySmartReplaceCreateRepository = SmartReplaceCreateRepository();

  SmartReplaceCreateBloc() : super(SmartReplaceCreateInitialState()) {
    on<SmartReplaceCreateInitialEvent>((event, emit) => emit(SmartReplaceCreateInitialState()));
    on<SmartReplaceCreateDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(SmartReplaceCreateDataEvent event, Emitter<SmartReplaceCreateState> emit) async {
    emit(SmartReplaceCreateLoadingState());
    try {
      await adminKeySmartReplaceCreateRepository.smartReplaceCreate(event.login, event.image, event.mask);

      if (adminKeySmartReplaceCreateRepository.success == true) {
        emit(SmartReplaceCreateSuccessState(
            login: adminKeySmartReplaceCreateRepository.makeSongResponse,
            message: adminKeySmartReplaceCreateRepository.message.toString().trim(),
        )
        );
      } else {
        emit(SmartReplaceCreateFailureState(
          message: adminKeySmartReplaceCreateRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(SmartReplaceCreateExceptionState(
        message: adminKeySmartReplaceCreateRepository.message.toString().trim(),
      ));
    }
  }

}
