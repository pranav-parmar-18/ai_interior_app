import 'dart:convert';
import 'package:ai_interior/models/common_model_response.dart';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/explore_model_response.dart';

part 'dream_space_event.dart';
part 'dream_space_repository.dart';
part 'dream_space_state.dart';

class DreamSpaceCreateBloc extends Bloc<DreamSpaceCreateEvent, DreamSpaceCreateState> {
  DreamSpaceCreateRepository adminKeyDreamSpaceCreateRepository = DreamSpaceCreateRepository();

  DreamSpaceCreateBloc() : super(DreamSpaceCreateInitialState()) {
    on<DreamSpaceCreateInitialEvent>((event, emit) => emit(DreamSpaceCreateInitialState()));
    on<DreamSpaceCreateDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(DreamSpaceCreateDataEvent event, Emitter<DreamSpaceCreateState> emit) async {
    emit(DreamSpaceCreateLoadingState());
    try {
      await adminKeyDreamSpaceCreateRepository.login(event.login);
      if (adminKeyDreamSpaceCreateRepository.success == true) {
        emit(DreamSpaceCreateSuccessState(
            login: adminKeyDreamSpaceCreateRepository.makeSongResponse,
            message: adminKeyDreamSpaceCreateRepository.message.toString().trim(),
        )
        );
      } else {
        emit(DreamSpaceCreateFailureState(
          message: adminKeyDreamSpaceCreateRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(DreamSpaceCreateExceptionState(
        message: adminKeyDreamSpaceCreateRepository.message.toString().trim(),
      ));
    }
  }

}
