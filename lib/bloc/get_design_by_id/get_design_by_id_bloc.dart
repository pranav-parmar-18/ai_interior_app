import 'dart:convert';
  import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/explore_model_response.dart';
import '../../models/get_character_list_model_response.dart';
import '../../models/make_song_response.dart';



part 'get_character_list_event.dart';
part 'get_character_list_repository.dart';
part 'get_character_list_state.dart';

class GetDesignByIDBloc extends Bloc<GetDesignByIDEvent, GetDesignByIDState> {
  GetDesignByIDRepository adminKeyLoginRepository = GetDesignByIDRepository();

  GetDesignByIDBloc() : super(GetDesignByIDInitialState()) {
    on<GetDesignByIDInitialEvent>((event, emit) => emit(GetDesignByIDInitialState()));
    on<GetDesignByIDDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(GetDesignByIDDataEvent event, Emitter<GetDesignByIDState> emit) async {
    emit(GetDesignByIDLoadingState());
    try {
      await adminKeyLoginRepository.getCharacterList();
      if (adminKeyLoginRepository.success == true) {
        emit(GetDesignByIDSuccessState(
            exploreSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(GetDesignByIDFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(GetDesignByIDExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
