import 'dart:convert';
  import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/explore_model_response.dart';
import '../../models/get_character_list_model_response.dart';
import '../../models/get_character_response.dart';
import '../../models/make_song_response.dart';



part 'get_character_event.dart';
part 'get_character_repository.dart';
part 'get_character_state.dart';

class GetCharacterBloc extends Bloc<GetCharacterEvent, GetCharacterState> {
  GetCharacterRepository adminKeyLoginRepository = GetCharacterRepository();

  GetCharacterBloc() : super(GetCharacterInitialState()) {
    on<GetCharacterInitialEvent>((event, emit) => emit(GetCharacterInitialState()));
    on<GetCharacterDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(GetCharacterDataEvent event, Emitter<GetCharacterState> emit) async {
    emit(GetCharacterLoadingState());
    try {
      await adminKeyLoginRepository.getCharacter(event.id);
      if (adminKeyLoginRepository.success == true) {
        emit(GetCharacterSuccessState(
            characterResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(GetCharacterFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(GetCharacterExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
