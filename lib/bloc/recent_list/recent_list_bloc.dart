import 'dart:convert';
  import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/common_model_response.dart';
import '../../models/explore_model_response.dart';
import '../../models/recents_model_response.dart';

part 'recent_list_event.dart';
part 'recent_list_repository.dart';
part 'recent_list_state.dart';

class RecentListBloc extends Bloc<RecentListEvent, RecentListState> {
  RecentListRepository adminKeyLoginRepository = RecentListRepository();

  RecentListBloc() : super(RecentListInitialState()) {
    on<RecentListInitialEvent>((event, emit) => emit(RecentListInitialState()));
    on<RecentListDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(RecentListDataEvent event, Emitter<RecentListState> emit) async {
    emit(RecentListLoadingState());
    try {
      await adminKeyLoginRepository.partnerList(event.genderId);
      if (adminKeyLoginRepository.success == true) {
        emit(RecentListSuccessState(
            exploreSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(RecentListFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(RecentListExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
