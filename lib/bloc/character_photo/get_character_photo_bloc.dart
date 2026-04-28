import 'dart:convert';
  import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/explore_model_response.dart';
import '../../models/get_character_list_model_response.dart';
import '../../models/get_character_photo_response.dart';
import '../../models/get_gift_list_response.dart';
import '../../models/get_photos_response.dart';
import '../../models/make_song_response.dart';



part 'get_character_photo_event.dart';
part 'get_character_photo_repository.dart';
part 'get_character_photo_state.dart';

class GetCharacterPhotoBloc extends Bloc<GetCharacterPhotoEvent, GetCharacterPhotoState> {
  GetCharacterPhotoRepository adminKeyLoginRepository = GetCharacterPhotoRepository();

  GetCharacterPhotoBloc() : super(GetCharacterPhotoInitialState()) {
    on<GetCharacterPhotoInitialEvent>((event, emit) => emit(GetCharacterPhotoInitialState()));
    on<GetCharacterPhotoDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(GetCharacterPhotoDataEvent event, Emitter<GetCharacterPhotoState> emit) async {
    emit(GetCharacterPhotoLoadingState());
    try {
      await adminKeyLoginRepository.GetCharacterPhoto(event.id);
      if (adminKeyLoginRepository.success == true) {
        emit(GetCharacterPhotoSuccessState(
            exploreSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(GetCharacterPhotoFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(GetCharacterPhotoExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
