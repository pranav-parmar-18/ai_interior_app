import 'dart:convert';
  import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/common_model_response.dart';
import '../../models/make_song_response.dart';



part 'delete_character_event.dart';
part 'delete_character_repository.dart';
part 'delete_character_state.dart';

class DeleteCharacterBloc extends Bloc<DeleteCharacterEvent, DeleteCharacterState> {
  DeleteCharacterRepository adminKeyLoginRepository = DeleteCharacterRepository();

  DeleteCharacterBloc() : super(DeleteCharacterInitialState()) {
    on<KeyLoginInitialEvent>((event, emit) => emit(DeleteCharacterInitialState()));
    on<DeleteCharacterDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(DeleteCharacterDataEvent event, Emitter<DeleteCharacterState> emit) async {
    emit(DeleteCharacterLoadingState());
    try {
      await adminKeyLoginRepository.deleteCharacter(event.id);
      if (adminKeyLoginRepository.success == true) {
        emit(DeleteCharacterSuccessState(
            makeSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(DeleteCharacterFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(DeleteCharacterExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
