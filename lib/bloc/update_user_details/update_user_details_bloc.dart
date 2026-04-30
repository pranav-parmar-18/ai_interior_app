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

part 'update_user_details_event.dart';
part 'update_user_details_repository.dart';
part 'update_user_details_state.dart';

class UpdateUserDetailsBloc extends Bloc<UpdateUserDetailsEvent, UpdateUserDetailsState> {
  UpdateUserDetailsRepository adminKeyLoginRepository = UpdateUserDetailsRepository();

  UpdateUserDetailsBloc() : super(UpdateUserDetailsInitialState()) {
    on<UpdateUserDetailsInitialEvent>((event, emit) => emit(UpdateUserDetailsInitialState()));
    on<UpdateUserDetailsDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(UpdateUserDetailsDataEvent event, Emitter<UpdateUserDetailsState> emit) async {
    emit(UpdateUserDetailsLoadingState());
    try {
      await adminKeyLoginRepository.editProfile(event.updateData);
      if (adminKeyLoginRepository.success == true) {
        emit(UpdateUserDetailsSuccessState(
            categoryModalResponse: adminKeyLoginRepository.makeSongResponse,
            message: adminKeyLoginRepository.message.toString().trim(),
        )
        );
      } else {
        emit(UpdateUserDetailsFailureState(
          message: adminKeyLoginRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(UpdateUserDetailsExceptionState(
        message: adminKeyLoginRepository.message.toString().trim(),
      ));
    }
  }
}
