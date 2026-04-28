import 'dart:convert';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/common_model_response.dart';
import '../../models/explore_model_response.dart';
import '../../models/make_song_response.dart';

part 'unlock_character_photo_event.dart';
part 'unlock_character_photo_repository.dart';
part 'unlock_character_photo_state.dart';

class UnlockCharacterPhotoBloc extends Bloc<UnlockCharacterPhotoEvent, UnlockCharacterPhotoState> {
  UnlockCharacterPhotoRepository adminKeyUnlockCharacterPhotoRepository = UnlockCharacterPhotoRepository();

  UnlockCharacterPhotoBloc() : super(UnlockCharacterPhotoInitialState()) {
    on<UnlockCharacterPhotoInitialEvent>((event, emit) => emit(UnlockCharacterPhotoInitialState()));
    on<UnlockCharacterPhotoDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(UnlockCharacterPhotoDataEvent event, Emitter<UnlockCharacterPhotoState> emit) async {
    emit(UnlockCharacterPhotoLoadingState());
    try {
      await adminKeyUnlockCharacterPhotoRepository.unlockCharacterPhoto(event.UnlockCharacterPhoto);
      if (adminKeyUnlockCharacterPhotoRepository.success == true) {
        emit(UnlockCharacterPhotoSuccessState(
            UnlockCharacterPhoto: adminKeyUnlockCharacterPhotoRepository.makeSongResponse,
            message: adminKeyUnlockCharacterPhotoRepository.message.toString().trim(),
        )
        );
      } else {
        emit(UnlockCharacterPhotoFailureState(
          message: adminKeyUnlockCharacterPhotoRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(UnlockCharacterPhotoExceptionState(
        message: adminKeyUnlockCharacterPhotoRepository.message.toString().trim(),
      ));
    }
  }

}
