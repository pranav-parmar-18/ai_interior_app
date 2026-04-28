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

class GetCharactersListBloc extends Bloc<GetCharactersListEvent, GetCharactersListState> {
  GetCharactersListRepository adminKeyLoginRepository = GetCharactersListRepository();

  GetCharactersListBloc() : super(GetCharactersListInitialState()) {
    on<GetCharactersListInitialEvent>((event, emit) => emit(GetCharactersListInitialState()));
    on<GetCharactersListDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(GetCharactersListDataEvent event, Emitter<GetCharactersListState> emit) async {
    emit(GetCharactersListLoadingState());
    try {
      await adminKeyLoginRepository.getCharacterList();
      if (adminKeyLoginRepository.success == true) {
        emit(GetCharactersListSuccessState(
            exploreSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(GetCharactersListFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(GetCharactersListExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
