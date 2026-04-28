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
import '../../models/partner_list_model_response.dart';
part 'partner_list_event.dart';
part 'partner_list_repository.dart';
part 'partner_list_state.dart';

class PartnerListBloc extends Bloc<PartnerListEvent, PartnerListState> {
  PartnerListRepository adminKeyLoginRepository = PartnerListRepository();

  PartnerListBloc() : super(PartnerListInitialState()) {
    on<PartnerListInitialEvent>((event, emit) => emit(PartnerListInitialState()));
    on<PartnerListDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(PartnerListDataEvent event, Emitter<PartnerListState> emit) async {
    emit(PartnerListLoadingState());
    try {
      await adminKeyLoginRepository.partnerList(event.genderId);
      if (adminKeyLoginRepository.success == true) {
        emit(PartnerListSuccessState(
            exploreSongResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(PartnerListFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(PartnerListExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
