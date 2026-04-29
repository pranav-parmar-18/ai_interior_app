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
import '../../models/make_song_response.dart';



part 'get_style_transfer_based_on_userid_event.dart';
part 'get_style_transfer_based_on_userid_repository.dart';
part 'get_style_transfer_based_on_userid_state.dart';

class GetGiftListBloc extends Bloc<GetGiftListEvent, GetGiftListState> {
  GetGiftListRepository adminKeyLoginRepository = GetGiftListRepository();

  GetGiftListBloc() : super(GetGiftListInitialState()) {
    on<GetGiftListInitialEvent>((event, emit) => emit(GetGiftListInitialState()));
    on<GetGiftListDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(GetGiftListDataEvent event, Emitter<GetGiftListState> emit) async {
    emit(GetGiftListLoadingState());
    try {
      await adminKeyLoginRepository.GetGiftList();
      if (adminKeyLoginRepository.success == true) {
        emit(GetGiftListSuccessState(
            exploreSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(GetGiftListFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(GetGiftListExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
