import 'dart:convert';
  import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/explore_model_response.dart';
import '../../models/get_character_list_model_response.dart';
import '../../models/get_gift_list_response.dart';
import '../../models/get_photos_response.dart';
import '../../models/make_song_response.dart';



part 'get_photos_list_event.dart';
part 'get_photos_list_repository.dart';
part 'get_photos_list_state.dart';

class GetPhotosListBloc extends Bloc<GetPhotosListEvent, GetPhotosListState> {
  GetPhotosListRepository adminKeyLoginRepository = GetPhotosListRepository();

  GetPhotosListBloc() : super(GetPhotosListInitialState()) {
    on<GetPhotosListInitialEvent>((event, emit) => emit(GetPhotosListInitialState()));
    on<GetPhotosListDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(GetPhotosListDataEvent event, Emitter<GetPhotosListState> emit) async {
    emit(GetPhotosListLoadingState());
    try {
      await adminKeyLoginRepository.GetPhotosList();
      if (adminKeyLoginRepository.success == true) {
        emit(GetPhotosListSuccessState(
            photoModelResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(GetPhotosListFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(GetPhotosListExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
