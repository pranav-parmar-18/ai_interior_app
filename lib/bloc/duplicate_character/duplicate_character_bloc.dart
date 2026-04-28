import 'dart:convert';
import 'package:ai_interior/models/common_model_response.dart';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/category_model_response.dart';
import '../../models/explore_model_response.dart';
import '../../models/image_generator_response.dart';
import '../../models/make_song_response.dart';



part 'duplicate_character_event.dart';
part 'duplicate_character_repository.dart';
part 'duplicate_character_state.dart';

class DuplicateCharacterBloc extends Bloc<DuplicateCharacterEvent, DuplicateCharacterState> {
  DuplicateCharacterRepository adminKeyLoginRepository = DuplicateCharacterRepository();

  DuplicateCharacterBloc() : super(DuplicateCharacterInitialState()) {
    on<DuplicateCharacterInitialEvent>((event, emit) => emit(DuplicateCharacterInitialState()));
    on<DuplicateCharacterDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(DuplicateCharacterDataEvent event, Emitter<DuplicateCharacterState> emit) async {
    emit(DuplicateCharacterLoadingState());
    try {
      await adminKeyLoginRepository.duplicateCharacter(event.makeSongData);
      if (adminKeyLoginRepository.success == true) {
        emit(DuplicateCharacterSuccessState(
            categoryModalResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(DuplicateCharacterFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(DuplicateCharacterExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
