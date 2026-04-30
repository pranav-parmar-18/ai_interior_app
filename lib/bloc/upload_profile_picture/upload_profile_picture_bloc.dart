import 'dart:convert';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/category_model_response.dart';
import '../../models/common_model_response.dart';
import '../../models/explore_model_response.dart';



part 'upload_profile_picture_event.dart';
part 'upload_profile_picture_repository.dart';
part 'upload_profile_picture_state.dart';

class UploadProfilePictureBloc extends Bloc<UploadProfilePictureEvent, UploadProfilePictureState> {
  UploadProfilePictureRepository adminKeyLoginRepository = UploadProfilePictureRepository();

  UploadProfilePictureBloc() : super(UploadProfilePictureInitialState()) {
    on<UploadProfilePictureInitialEvent>((event, emit) => emit(UploadProfilePictureInitialState()));
    on<UploadProfilePictureDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(UploadProfilePictureDataEvent event, Emitter<UploadProfilePictureState> emit) async {
    emit(UploadProfilePictureLoadingState());
    try {
      await adminKeyLoginRepository.uploadProfilePicture(event.makeSongData);
      if (adminKeyLoginRepository.success == true) {
        emit(UploadProfilePictureSuccessState(
            categoryModalResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(UploadProfilePictureFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(UploadProfilePictureExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
