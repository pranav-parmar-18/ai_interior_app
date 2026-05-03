import 'dart:convert';
import 'dart:io';
import 'package:ai_interior/models/common_model_response.dart';
import 'package:ai_interior/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/interior_design_create_model_response.dart';
part 'interior_design_create_event.dart';
part 'interior_design_create_repository.dart';
part 'interior_design_create_state.dart';

class InteriorDeignCreateBloc extends Bloc<InteriorDeignCreateEvent, InteriorDeignCreateState> {
  InteriorDeignCreateRepository adminKeyInteriorDeignCreateRepository = InteriorDeignCreateRepository();

  InteriorDeignCreateBloc() : super(InteriorDeignCreateInitialState()) {
    on<InteriorDeignCreateInitialEvent>((event, emit) => emit(InteriorDeignCreateInitialState()));
    on<InteriorDeignCreateDataEvent>(_acceptOrderDataEvent);
  }

  void _acceptOrderDataEvent(InteriorDeignCreateDataEvent event, Emitter<InteriorDeignCreateState> emit) async {
    emit(InteriorDeignCreateLoadingState());
    try {
      await adminKeyInteriorDeignCreateRepository.interiorDesignCreate(event.login,event.image);
      if (adminKeyInteriorDeignCreateRepository.success == true) {
        emit(InteriorDeignCreateSuccessState(
            login: adminKeyInteriorDeignCreateRepository.makeSongResponse,
            message: adminKeyInteriorDeignCreateRepository.message.toString().trim(),
        )
        );
      } else {
        emit(InteriorDeignCreateFailureState(
          message: adminKeyInteriorDeignCreateRepository.message.toString().trim(),
        ));
      }
    } catch (error) {
      print(error);
      emit(InteriorDeignCreateExceptionState(
        message: adminKeyInteriorDeignCreateRepository.message.toString().trim(),
      ));
    }
  }

}
